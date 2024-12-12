<?php


// if (!isset($_POST)) { 
//     $response = array('status' => 'failed', 'data' => null); 
//     sendJsonResponse($response); 
//     die; 
// }

include_once("dbconnect.php");
// $userEmail = $_POST['userEmail'];
// $newsId = $_POST['newsId'];

// Suppress errors for clean JSON output
error_reporting(0);
ini_set('display_errors', 0);
header('Content-Type: application/json; charset=UTF-8');

if (isset($_POST['userEmail']) && isset($_POST['newsId'])) {
    $userEmail = $_POST['userEmail'];
    $newsId = $_POST['newsId'];
} else {
    $response = array('status' => 'failed', 'message' => 'Invalid parameters');
    sendJsonResponse($response);
    die();
}

// Get user ID from email
$sqlGetUserId = "SELECT `user_id` FROM `tbl_users` WHERE `user_email` = '$userEmail'";
$resultUserId = $conn->query($sqlGetUserId);

if (!$resultUserId || $resultUserId->num_rows <= 0) {
    $response = array('status' => 'failed', 'message' => 'User not found');
    sendJsonResponse($response);
    die();
}

$rowUser = $resultUserId->fetch_assoc();
$userId = $rowUser['user_id'];

// Check if the news is already favorited by the user
$sqlCheckFavorite = "SELECT * FROM `tbl_favourites` WHERE `user_id` = '$userId' AND `news_id` = '$newsId'";
$resultCheck = $conn->query($sqlCheckFavorite);

if ($resultCheck && $resultCheck->num_rows > 0) {
    // Remove from favourites
    $sqlDeleteFavorite = "DELETE FROM `tbl_favourites` WHERE `user_id` = '$userId' AND `news_id` = '$newsId'";
    if ($conn->query($sqlDeleteFavorite) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Removed from favourites');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to remove favorite');
    }
} else {
    // Add to favourites
    $sqlAddFavorite = "INSERT INTO `tbl_favourites` (`user_id`, `news_id`, `dateoffavourite`) VALUES ('$userId', '$newsId', NOW())";
    if ($conn->query($sqlAddFavorite) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Added to favourites');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to add favorite');
    }
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>
