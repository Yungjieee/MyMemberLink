<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

// Get the inputs
$userId = $_POST['user_id'];
$productId = $_POST['product_id'];
$quantity = $_POST['quantity'];

// Check if the row already exists
$sqlCheck = "SELECT * FROM `tbl_cartitem` WHERE `user_id` = '$userId' AND `product_id` = '$productId'";
$result = $conn->query($sqlCheck);

if ($result->num_rows > 0) {
    // Row exists, update quantity and added_date
    $sqlUpdate = "UPDATE `tbl_cartitem` 
                  SET `quantity` = `quantity` + $quantity, `added_date` = CURRENT_TIMESTAMP
                  WHERE `user_id` = '$userId' AND `product_id` = '$productId'";
    if ($conn->query($sqlUpdate) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Quantity updated');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to update');
    }
} else {
    // Row does not exist, insert new record
    $sqlInsert = "INSERT INTO `tbl_cartitem` (`user_id`, `product_id`, `quantity`) 
                  VALUES ('$userId', '$productId', '$quantity')";
    if ($conn->query($sqlInsert) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Item added to cart');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to insert');
    }
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
