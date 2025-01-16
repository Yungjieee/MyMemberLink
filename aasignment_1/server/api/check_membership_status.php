<?php
header('Content-Type: application/json');
include_once("dbconnect.php"); // Include your database connection script

$email = $_GET['email'];
$membership_id = $_GET['membership_id'];

if (!$email || !$membership_id) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit();
}

// Retrieve user_id from tbl_users using email
$sql_user = "SELECT user_id FROM tbl_users WHERE user_email = ?";
$stmt_user = $conn->prepare($sql_user);
$stmt_user->bind_param("s", $email);
$stmt_user->execute();
$result_user = $stmt_user->get_result();

if ($result_user->num_rows > 0) {
    $row_user = $result_user->fetch_assoc();
    $user_id = $row_user['user_id'];

    // Check for payment status in tbl_payments
    $sql_payment = "SELECT payment_status FROM tbl_payments WHERE user_id = ? AND membership_id = ?";
    $stmt_payment = $conn->prepare($sql_payment);
    $stmt_payment->bind_param("ss", $user_id, $membership_id);
    $stmt_payment->execute();
    $result_payment = $stmt_payment->get_result();

    if ($result_payment->num_rows > 0) {
        $row_payment = $result_payment->fetch_assoc();
        $payment_status = $row_payment['payment_status'];

        if ($payment_status === "paid") {
            echo json_encode(["status" => "exists", "message" => "You have already purchased this membership."]);
        } elseif ($payment_status === "pending") {
            echo json_encode(["status" => "pending", "message" => "You have a pending payment for this membership."]);
        }
    } else {
        echo json_encode(["status" => "not_found", "message" => "No payment record found for this membership."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found."]);
}

$conn->close();
?>
