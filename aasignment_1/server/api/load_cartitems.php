<?php
include_once("dbconnect.php");

$results_per_page = 20; // Number of results per page
if (isset($_GET['pageno'])) {
    $pageno = (int)$_GET['pageno'];
} else {
    $pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'message' => 'User ID not provided.');
    sendJsonResponse($response);
    die();
}

$user_id = $_GET['user_id'];

// Query to load cart items for the specific user ordered by added_date
$sqlloadcartitems = "SELECT tbl_cartitem.quantity, tbl_cartitem.added_date, 
    tbl_product.product_id, tbl_product.product_name, tbl_product.product_type, 
    tbl_product.product_price, tbl_product.product_filename 
    FROM tbl_cartitem 
    INNER JOIN tbl_product ON tbl_cartitem.product_id = tbl_product.product_id 
    WHERE tbl_cartitem.user_id = '$user_id'
    ORDER BY tbl_cartitem.added_date DESC"; // Order by added_date in descending order

$result = $conn->query($sqlloadcartitems);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadcartitems = $sqlloadcartitems . " LIMIT $page_first_result, $results_per_page";

$result = $conn->query($sqlloadcartitems);

if ($result->num_rows > 0) {
    $cartitemsarray['cartitems'] = array();
    while ($row = $result->fetch_assoc()) {
        $cartitem = array();
        $cartitem['product_id'] = $row['product_id'];
        $cartitem['product_name'] = $row['product_name'];
        $cartitem['product_type'] = $row['product_type'];
        $cartitem['product_price'] = $row['product_price']; // Include product price
        $cartitem['product_filename'] = $row['product_filename'];
        $cartitem['quantity'] = $row['quantity'];
        $cartitem['added_date'] = $row['added_date'];
        array_push($cartitemsarray['cartitems'], $cartitem);
    }
    $response = array('status' => 'success', 'data' => $cartitemsarray, 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null, 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
