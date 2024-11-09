<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

// $sqllogin = "SELECT  `user_email`, `user_pass` FROM `tbl_users` WHERE `user_email` = '$email' AND `user_pass` = '$password';";
// $result = $conn->query($sqllogin);

// if ($result->num_rows > 0) {  //more than 0 means success
//     $response = array('status' => 'success', 'data' => null); 
//     sendJsonResponse($response); 
// }else{  //not success
//     $response = array('status' => 'failed', 'data' => null); 
//     sendJsonResponse($response); 
// }

// Check if email exists
$sqlemailcheck = "SELECT `user_pass` FROM `tbl_users` WHERE `user_email` = '$email'";
$result = $conn->query($sqlemailcheck);

if ($result->num_rows > 0) {
    // Email exists, now verify password
    $user = $result->fetch_assoc();

    if ($user['user_pass'] === $password) {
        // Password is correct
        $response = array('status' => 'success', 'data' => null);
    } else {
        // Password is incorrect
        $response = array('status' => 'wrong_password', 'data' => null);
    }
} else {
    // Email does not exist
    $response = array('status' => 'no_email', 'data' => null);
}
sendJsonResponse($response); 

function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>