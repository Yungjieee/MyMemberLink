<?php
include_once("dbconnect.php");

// Check if the email and status are provided in the request
if (!isset($_GET['email']) || !isset($_GET['status'])) {
    $response = array('status' => 'failed', 'message' => 'User email or status missing');
    sendJsonResponse($response);
    die();
}

$email = $_GET['email'];
$status = strtolower($_GET['status']); // Get the payment status (Paid or Pending)

// Validate the status input
$allowedStatuses = ['paid', 'pending'];
if (!in_array($status, $allowedStatuses)) {
    $response = array('status' => 'failed', 'message' => 'Invalid payment status');
    sendJsonResponse($response);
    die();
}

// Retrieve the user ID based on the provided email
$sqlGetUserId = "SELECT user_id FROM tbl_users WHERE user_email = ?";
$stmt = $conn->prepare($sqlGetUserId);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userId = $row['user_id'];
} else {
    $response = array('status' => 'failed', 'message' => 'User not found');
    sendJsonResponse($response);
    die();
}

// Retrieve payments for the specific user and filter by status
$sqlLoadPayments = "SELECT p.payment_id, p.payment_amount, p.payment_date, p.payment_status, 
                    p.payment_receipt, m.membership_id, m.membership_name 
                    FROM tbl_payments p
                    JOIN tbl_membership m ON p.membership_id = m.membership_id
                    WHERE p.user_id = ? AND LOWER(p.payment_status) = ?";
$stmt = $conn->prepare($sqlLoadPayments);
$stmt->bind_param("is", $userId, $status);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $paymentArray['payments'] = array();
    while ($row = $result->fetch_assoc()) {
        $payment = array();
        $payment['payment_id'] = $row['payment_id'];
        $payment['payment_amount'] = $row['payment_amount'];
        $payment['payment_date'] = $row['payment_date'];
        $payment['payment_status'] = $row['payment_status'];
        $payment['payment_receipt'] = $row['payment_receipt'];
        $payment['membership_id'] = $row['membership_id'];
        $payment['membership_name'] = $row['membership_name'];
        array_push($paymentArray['payments'], $payment);
    }
    $response = array('status' => 'success', 'data' => $paymentArray);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'No payments found for the selected status');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
