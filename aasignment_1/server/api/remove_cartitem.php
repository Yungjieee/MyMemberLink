<?php
include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$product_id = $_POST['product_id'];

$sqldelete = "DELETE FROM tbl_cartitem WHERE user_id = '$user_id' AND product_id = '$product_id'";

if ($conn->query($sqldelete) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Item removed from cart');
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to remove item');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
