#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use LWP::UserAgent;
use Encode;
use Net::SMTP::SSL;
use Net::SMTP;
use MIME::Lite;

# Database variables
my $Conn;
my %attr;

# Email variables
my $Mailfrom = 'ali.hamza@mitco.pk';

# Create UserAgent object
my $ua = LWP::UserAgent->new();
$ua->timeout(10);
$ua->agent('MyCustomUserAgent/1.0'); # Optional: Set a custom user-agent string
$ua->max_redirect(5); # Optional: Allow up to 5 redirects

# Database connection
my $DB = "database=website_monitoring:host=localhost:";
my $dbUser = "alihamza";
my $dbPasswd = "alihamza";

%attr = ( PrintError => 0, RaiseError => 0 );

# Database Connection
if (!($Conn = DBI->connect("DBI:mysql:$DB;mysql_compression=1", $dbUser, $dbPasswd, \%attr))) {
    die "Error connecting to Master Server\n";
}

# Fetch active monitored sites
my $Sql = "SELECT ms_id, url, alert_email, text_match, match_type, cookies, headers FROM monitored_sites WHERE status = 'active'";
my $ref = $Conn->selectall_arrayref($Sql, { Slice => {} });

my $status = 0;
my $cResponse = "Error: ";
my $okResponse = "In Working: ";
my $isFirstError = 1;  # Flag to track the first error
my $isFirstWorking = 1;  # Flag to track the first working URL

foreach (@$ref) {
    # Assign Variable from loop values
    my ($ms_id, $url, $alert_email, $text_match, $match_type, $cookies, $headers) = @{$_}{qw(ms_id url alert_email text_match match_type cookies headers)};

    # Set request headers if available
    my $req = HTTP::Request->new(GET => $url);

    # Set cookies if available
    if ($cookies) {
        $req->header('Cookie' => $cookies);
    }

    # Set custom headers if available
    if ($headers) {
        foreach my $header (split /\n/, $headers) {
            $req->header(split /:\s*/, $header);
        }
    }

    # Fetch webpage content (HTMl)
    my $response = $ua->request($req);

    # Check for success and handle response
    if ($response->is_success) {

        # Filter response content and text_match by removing spaces and line breaks etc
        my $normalized_response = $response->decoded_content(charset => 'none');
        $normalized_response =~ s/[\n\r\s]//g;
        
        my $normalized_text_match = $text_match;
        $normalized_text_match =~ s/[\n\r\s]//g;

        # Check if the normalized text_match exists in the normalized response
        if ($normalized_response =~ /\Q$normalized_text_match\E/) {
            # For Nagios Alert
            if ($isFirstWorking) {
                $okResponse .= $url;
                $isFirstWorking = 0;
            } else {
                $okResponse .= ", " . $url;
            }

            # Update database for successful match
            my $statement = "UPDATE monitored_sites SET status = 'active', last_result = 'Match found', last_check_datetime = NOW(), response_time = ? WHERE ms_id = ?";
            my $rv = $Conn->do($statement, undef, $response->header('Client-Response-Time') || 0, $ms_id);
            $DBI::err && die $DBI::errstr;
        } else {
            # For Nagios Alert
            $status++;
            if ($isFirstError) {
                $cResponse .= $url;
                $isFirstError = 0;
            } else {
                $cResponse .= ", " . $url;
            }

            # Update database for no match
            my $statement = "UPDATE monitored_sites SET status = 'inactive', last_result = 'Match not found', last_check_datetime = NOW(), response_time = ? WHERE ms_id = ?";
            my $rv = $Conn->do($statement, undef, $response->header('Client-Response-Time') || 0, $ms_id);
            $DBI::err && die $DBI::errstr;

            # Email alert
            
            my $smtp = Net::SMTP::SSL->new(
                'webhost-1.xs.net.pk',
                Port => 465,
                Timeout => 30,
                Debug => 0,  # Set to 1 for troubleshooting
            ) or die "Failed to connect to SMTP server: $!";

            $smtp->auth('ali.hamza@mitco.pk', '0lJ^3o11x') or die "Auth failed: $!";
            $smtp->mail('ali.hamza@mitco.pk');
            $smtp->to($alert_email);
            $smtp->data();
            $smtp->datasend("From: Website Monitor <$Mailfrom>\n");
            $smtp->datasend("To: $alert_email\n");
            $smtp->datasend("Subject: Website Monitoring Alert\n");
            $smtp->datasend("MIME-Version: 1.0\n");
            $smtp->datasend("Content-Type: text/html; charset=UTF-8\n\n");
            # Email body
            # $smtp->datasend("ALERT: Website check failed for $url\n");
            # $smtp->datasend("Status: Match not found for text: $text_match\n");
            # $smtp->datasend("Time: ".localtime()."\n");
            
            $smtp->datasend(qq{
                <!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; }
                        .alert { color: #d9534f; font-weight: bold; }
                        .details { background: #f9f9f9; padding: 15px; border-left: 4px solid #d9534f; }
                        .footer { margin-top: 20px; font-size: 0.9em; color: #777; }
                    </style>
                </head>
                <body>
                    <h2 class="alert">Website Monitoring Alert</h2>
                    <div class="details">
                        <p><strong>URL:</strong> $url</p>
                        <p><strong>Status:</strong> Match not found, Site faces issues.</p>
                        <p><strong>Match Type:</strong> $match_type</p>
                        <p><strong>Time:</strong> }.localtime().qq{</p>
                    </div>
                    <div class="footer">
                        <p>This is an automated message from Website Monitoring System.</p>
                    </div>
                </body>
                </html>
            });
            
            $smtp->dataend();
            $smtp->quit;

            # End of email alert
        }
    } else {
        # For Nagios Alert (Error URLs)
        $status++;
        if ($isFirstError) {
            $cResponse .= $url;
            $isFirstError = 0;  # Update flag after the first URL
        } else {
            $cResponse .= ", " . $url;
        }

        # Update database for failed request
        my $statement = "UPDATE monitored_sites SET status = 'inactive', last_result = ?, last_check_datetime = NOW(), response_time = ? WHERE ms_id = ?";
        my $rv = $Conn->do($statement, undef, $response->status_line, $response->header('Client-Response-Time') || 0, $ms_id);
        $DBI::err && die $DBI::errstr;
    }
}

if($status > 0){
    print "CRITICAL - $cResponse \n" ;
    exit 2 ;
}

print "OK - $okResponse \n" ;

# Disconnect database
my $rc = $Conn->disconnect;