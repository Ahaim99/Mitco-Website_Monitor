#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use LWP::UserAgent;

my $Conn;
my %attr;

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
my $Sql = "SELECT ms_id, url, text_match, match_type, cookies, headers FROM monitored_sites WHERE status = 'active'";
my $ref = $Conn->selectall_arrayref($Sql, { Slice => {} });

my $status = 0;
my $cResponse = "Error: ";
my $okResponse = "In Working: ";
my $isFirstError = 1;  # Flag to track the first error
my $isFirstWorking = 1;  # Flag to track the first working URL

foreach (@$ref) {
    # Assign Variable from loop values
    my ($ms_id, $url, $text_match, $match_type, $cookies, $headers) = @{$_}{qw(ms_id url text_match match_type cookies headers)};

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
        my $normalized_response = $response->decoded_content;
        $normalized_response =~ s/[\n\r\s]//g;
        
        my $normalized_text_match = $text_match;
        $normalized_text_match =~ s/[\n\r\s]//g;

        print "normalized_response: $normalized_response\n\n\n";
        print "normalized_text_match: $normalized_text_match\n";

        # # Check if the normalized text_match exists in the normalized response
        # if ($normalized_response =~ /\Q$normalized_text_match\E/) {
        #     # For Nagios Alert
        #     if ($isFirstWorking) {
        #         $okResponse .= $url;
        #         $isFirstWorking = 0;
        #     } else {
        #         $okResponse .= ", " . $url;
        #     }

        #     # Update database for successful match
        #     my $statement = "UPDATE monitored_sites SET status = 'active', last_result = 'Match found', last_check_datetime = NOW(), response_time = ? WHERE ms_id = ?";
        #     my $rv = $Conn->do($statement, undef, $response->header('Client-Response-Time') || 0, $ms_id);
        #     $DBI::err && die $DBI::errstr;
        # } else {
        #     # For Nagios Alert
        #     $status++;
        #     if ($isFirstError) {
        #         $cResponse .= $url;
        #         $isFirstError = 0;
        #     } else {
        #         $cResponse .= ", " . $url;
        #     }

        #     # Update database for no match
        #     my $statement = "UPDATE monitored_sites SET status = 'inactive', last_result = 'Match not found', last_check_datetime = NOW(), response_time = ? WHERE ms_id = ?";
        #     my $rv = $Conn->do($statement, undef, $response->header('Client-Response-Time') || 0, $ms_id);
        #     $DBI::err && die $DBI::errstr;
        # }
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