<?php

if (!isset($_GET['email']) || !isset($_GET['amount']) || !isset($_GET['membershipId'])) { 
    die("Missing required parameters."); 
}

include_once("dbconnect.php"); // Include the database connection file

$email = $_GET['email']; // User email
$amount = $_GET['amount']; // Payment amount
$membershipId = $_GET['membershipId']; // Membership ID

// Query the database to retrieve user details
$sql = "SELECT `user_id`, `user_name`, `user_phoneNum` FROM `tbl_users` WHERE `user_email` = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $user_id = $row['user_id'];
    $name = $row['user_name'];
    $phone = $row['user_phoneNum'];
} else {
    die("User not found.");
}

// Billplz API setup
$api_key = 'YOUR KEY'; // Replace with your actual API key
$collection_id = 'YOUR ID'; // Replace with your actual collection ID
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'mobile' => $phone,
    'name' => $name,
    'amount' => ($amount) * 100, // Convert to cents
    'description' => 'Payment for order by ' . $name,
    'callback_url' => "https://mymemberlink.threelittlecar.com/memberlink_asg1/return_url",
    'redirect_url' => "https://mymemberlink.threelittlecar.com/memberlink_asg1/api/payment_update.php?email=$email&phone=$phone&amount=$amount&name=$name&user_id=$user_id&membershipId=$membershipId"
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

// Redirect to the Billplz payment URL
if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    die("Error creating bill: " . $bill['error']['message']);
}
?>



