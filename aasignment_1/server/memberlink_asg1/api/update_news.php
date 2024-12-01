<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$newsId = $_POST['newsId'];
$title = addslashes($_POST['title']);     //addcslashes works for ' and " , or else other people can do sql injection, for security purposes
$details = addslashes($_POST['details']);

$sqlupdatenews = "UPDATE `tbl_news` SET `news_title`='$title',`news_details`='$details' WHERE `news_id`= '$newsId'";
if ($conn->query($sqlupdatenews) === TRUE) {
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