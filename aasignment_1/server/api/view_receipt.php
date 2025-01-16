<?php

// Include the database connection file
include_once("dbconnect.php");

// Retrieve parameters from the GET request
$email = $_GET['email'];
$receiptId = $_GET['receiptId'];
$membershipId = $_GET['membershipId'];

if (!isset($_GET['email'], $_GET['receiptId'], $_GET['membershipId'])) {
    die("Missing parameters.");
}

// Default response in case of missing or invalid receipt
$error_message = "Receipt not found. Please check the details.";

// Fetch user details from tbl_users using email
$sqlGetUser = "SELECT user_id, user_name FROM tbl_users WHERE user_email = '$email'";
$resultUser = $conn->query($sqlGetUser);

if ($resultUser->num_rows > 0) {
    $user = $resultUser->fetch_assoc();
    $userId = $user['user_id'];
    $userName = $user['user_name'];

    // Fetch payment details from tbl_payments
    $sqlGetPayment = "SELECT * FROM tbl_payments WHERE payment_receipt = '$receiptId' AND user_id = '$userId' AND membership_id = '$membershipId'";
    $resultPayment = $conn->query($sqlGetPayment);

    if ($resultPayment->num_rows > 0) {
        $payment = $resultPayment->fetch_assoc();

        // Retrieve membership name
        $membershipName = "Membership Name Not Found"; // Default value
        $sqlGetMembership = "SELECT membership_name FROM tbl_membership WHERE membership_id = '$membershipId'";
        $resultMembership = $conn->query($sqlGetMembership);
        if ($resultMembership->num_rows > 0) {
            $membershipRow = $resultMembership->fetch_assoc();
            $membershipName = $membershipRow['membership_name'];
        }

        // Extract payment details
        $amount = $payment['payment_amount'];
        $paidStatus = $payment['payment_status'];
        $statusColor = $paidStatus == "paid" ? "#4CAF50" : "#f44336";
        $statusIcon = $paidStatus == "paid" ? "✔" : "✖";
        $statusText = $paidStatus == "paid" ? "Successful" : "Failed";

        // Render the receipt
        echo "
        <html>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
        <style>
            body {
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .receipt-container {
                width: 90%;
                max-width: 400px;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                overflow: hidden;
                text-align: center;
            }
            .receipt-header {
                background-color: $statusColor;
                color: white;
                padding: 20px;
            }
            .receipt-header h4 {
                margin: 0;
                font-size: 18px;
            }
            .receipt-header .status-icon {
                font-size: 50px;
                margin-top: 10px;
            }
            .receipt-content {
                padding: 20px;
            }
            .receipt-content h4 {
                margin-bottom: 10px;
                font-size: 22px;
                color: #333;
            }
            .receipt-content .payment-amount {
                font-size: 28px;
                font-weight: bold;
                color: $statusColor;
                margin: 10px 0;
            }
            .receipt-details {
                text-align: left;
                margin-top: 20px;
            }
            .receipt-details p {
                margin: 8px 0;
                font-size: 14px;
                color: #555;
            }
            .receipt-footer {
                padding: 15px;
                border-top: 1px solid #eee;
            }
        </style>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    <h4>Receipt from MyMemberLink</h4>
                    <div class=\"status-icon\">$statusIcon</div>
                    <p>Receipt ID: $receiptId</p>
                </div>
                <div class=\"receipt-content\">
                    <h4>$membershipName Membership</h4>
                    <p class=\"payment-amount\">RM $amount</p>
                    <div class=\"receipt-details\">
                        <p><strong>User:</strong> $userName</p>
                        <p><strong>Email:</strong> $email</p>
                        <p><strong>Status:</strong> $paidStatus</p>
                        <p><strong>Payment Method:</strong> Billplz</p>
                    </div>
                </div>
            </div>
        </body>
        </html>";
    } else {
        // If receipt is not found
        echo "<html><body><h2>$error_message</h2></body></html>";
    }
} else {
    // If user is not found
    echo "<html><body><h2>User not found. Please check the email.</h2></body></html>";
}

?>
