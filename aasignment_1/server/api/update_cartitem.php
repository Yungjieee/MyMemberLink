<?php
include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$product_id = $_POST['product_id'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE tbl_cartitem SET quantity = '$quantity' WHERE user_id = '$user_id' AND product_id = '$product_id'";

if ($conn->query($sqlupdate) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Quantity updated');
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to update quantity');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
