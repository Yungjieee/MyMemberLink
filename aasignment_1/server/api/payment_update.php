<?php

// Include the database connection file
include_once("dbconnect.php");

// Retrieve data from the GET request
$userid = $_GET['user_id'];
$phone = "+60" . $_GET['phone']; // Add +60 in front of the phone number
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];
$membershipid = $_GET['membershipId'];

$data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true") {
    $paidstatus = "Paid";
} else {
    $paidstatus = "Pending";
}
$receiptid = $_GET['billplz']['id']; // Get receipt ID

$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'YOUR KEY'); // Replace 'abcde' with your actual Billplz secret key
if ($signed === $data['x_signature']) {
    // Retrieve membership name from tbl_membership
    $membershipname = "Membership Name Not Found"; // Default value
    $sqlgetmembership = "SELECT membership_name FROM tbl_membership WHERE membership_id = '$membershipid'";
    $result = $conn->query($sqlgetmembership);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $membershipname = $row['membership_name'];
    }

    // Insert payment details into the tbl_payments table
    $sqlinsertpayment = "INSERT INTO tbl_payments (payment_amount, payment_status, user_id, membership_id, payment_receipt) 
                         VALUES ('$amount', '$paidstatus', '$userid', '$membershipid', '$receiptid')";
    if ($conn->query($sqlinsertpayment) === TRUE) {
        // Print receipt for success or failed transaction
        $statusColor = $paidstatus == "Paid" ? "#4CAF50" : "#f44336";
        $statusIcon = $paidstatus == "Paid" ? "✔" : "✖";
        $statusText = $paidstatus == "Paid" ? "Successful" : "Failed";
        $buttonText = $paidstatus == "Paid" ? "Done" : "Retry";
        $buttonAction = $paidstatus == "Paid" ? "window.print()" : "window.location.href='/retry'";

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
            .receipt-footer button {
                width: 100%;
                padding: 10px 15px;
                border: none;
                background-color: $statusColor;
                color: white;
                font-size: 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            .receipt-footer button:hover {
                background-color: #d32f2f;
            }
        </style>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    <h4>Receipt from MyMemberLink</h4>
                    <div class=\"status-icon\">$statusIcon</div>
                    <p>Receipt ID: $receiptid</p>
                </div>
                <div class=\"receipt-content\">
                    <h4>$name</h4>
                    <p class=\"payment-amount\">RM $amount</p>
                    <div class=\"receipt-details\">
                        <p><strong>Membership:</strong> $membershipname</p>
                        <p><strong>Email:</strong> $email</p>
                        <p><strong>Phone:</strong> $phone</p>
                        <p><strong>Status:</strong> $paidstatus</p>
                        <p><strong>Payment Method:</strong> Billplz</p>
                    </div>
                </div>
                <div class=\"receipt-footer\">
                    <button onclick=\"$buttonAction\">$buttonText</button>
                </div>
            </div>
        </body>
        </html>";
    } else {
        die("Error inserting payment record: " . $conn->error);
    }
} else {
    die("Signature mismatch. Payment not verified.");
}


?>