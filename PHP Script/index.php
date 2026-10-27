<?php
// Login URL
$loginUrl = 'https://apxsite.xs.net.pk/';

// Initialize cURL session
$ch = curl_init();

// Step 1: Fetch the login page to get the CSRF token
curl_setopt($ch, CURLOPT_URL, $loginUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt'); // Save cookies to a file
curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookie.txt'); // Send cookies from the file

// Set headers for the initial request
$headers = [
    'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'accept-language: en-US,en;q=0.9',
    'cache-control: max-age=0',
    'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
];
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

// Execute the request to fetch the login page
$loginPageResponse = curl_exec($ch);

// Check for errors
if (curl_errno($ch)) {
    echo 'cURL error: ' . curl_error($ch);
    exit;
}

// Extract the CSRF token from the login page
if (preg_match('/<input type="hidden" name="_token" value="([^"]+)"/', $loginPageResponse, $matches)) {
    $csrfToken = $matches[1]; // Extracted CSRF token
} else {
    echo 'CSRF token not found on the login page.';
    exit;
}

// Step 2: Send the login request with the CSRF token
$postData = [
    '_token' => $csrfToken, // Use the extracted CSRF token
    'email' => 'admin@gmail.com',
    'password' => 'admin'
];

// Set cURL options for the login request
curl_setopt($ch, CURLOPT_URL, $loginUrl);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));

// Execute the login request
$loginResponse = curl_exec($ch);

// Check for errors
if (curl_errno($ch)) {
    echo 'cURL error: ' . curl_error($ch);
    exit;
}

// Step 3: Access the restricted page
$restrictedUrl = 'https://apxsite.xs.net.pk/dashboard';
curl_setopt($ch, CURLOPT_URL, $restrictedUrl);
curl_setopt($ch, CURLOPT_POST, 0); // No POST data for this request

// Execute the restricted page request
$restrictedResponse = curl_exec($ch);

// Check for errors
if (curl_errno($ch)) {
    echo 'cURL error: ' . curl_error($ch);
    exit;
}

// Close cURL session
curl_close($ch);

// Output the restricted page content
echo $restrictedResponse;
?>