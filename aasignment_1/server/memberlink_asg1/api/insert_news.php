<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$title = addslashes($_POST['title']);     //addcslashes works for ' and " , or else other people can do sql injection, for security purposes
$details = addslashes($_POST['details']);

$sqlinsertnews = "INSERT INTO `tbl_news`(`news_title`, `news_details`) VALUES ('$title','$details')";
if ($conn->query($sqlinsertnews) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
} 


function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>