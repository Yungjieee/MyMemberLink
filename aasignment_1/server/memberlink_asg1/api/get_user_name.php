<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$userEmail = $_POST['userEmail'];

// Query the database to retrieve the user name based on email
$sql = "SELECT `user_name` FROM `tbl_users` WHERE `user_email` = '$userEmail'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Fetch the user's name from the result
    $row = $result->fetch_assoc();
    $response = ['status' => 'success', 'user_name' => $row['user_name']];
} else {
    // Return an error if no user is found
    $response = ['status' => 'failed', 'message' => 'No user found'];
}

sendJsonResponse($response); 

function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>