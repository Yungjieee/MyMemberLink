<?php
include_once("dbconnect.php");

$results_per_page = 6; // Number of results per page
$pageno = isset($_GET['pageno']) ? (int)$_GET['pageno'] : 1;
$search = isset($_GET['search']) ? trim($_GET['search']) : null;
$category = isset($_GET['category']) ? $_GET['category'] : 'All Products';

// SQL base query
$sqlloadproducts = "SELECT * FROM `tbl_product` WHERE 1=1";

// Append category condition
if ($category !== 'All Products') {
    $category = $conn->real_escape_string($category);
    $sqlloadproducts .= " AND `product_type` = '$category'";
}

// Append search condition if search query exists
if (!empty($search)) {
    $search = $conn->real_escape_string($search);
    $sqlloadproducts .= " AND (`product_name` LIKE '%$search%' OR `product_description` LIKE '%$search%')";
}

// Pagination logic
$page_first_result = ($pageno - 1) * $results_per_page;

// Count total results
$result = $conn->query($sqlloadproducts);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);

// Append LIMIT clause for pagination
$sqlloadproducts .= " LIMIT $page_first_result, $results_per_page";

// Execute the final query
$result = $conn->query($sqlloadproducts);

if ($result && $result->num_rows > 0) {
    $productsarray['products'] = array();
    while ($row = $result->fetch_assoc()) {
        $product = array(
            'product_id' => $row['product_id'],
            'product_name' => $row['product_name'],
            'product_description' => $row['product_description'],
            'product_price' => $row['product_price'],
            'product_type' => $row['product_type'],
            'product_filename' => $row['product_filename'],
            'product_rating' => $row['product_rating'],
        );
        array_push($productsarray['products'], $product);
    }
    $response = array(
        'status' => 'success',
        'data' => $productsarray,
        'numofpage' => $number_of_page,
        'numberofresult' => $number_of_result
    );
    sendJsonResponse($response);
} else {
    $response = array(
        'status' => 'failed',
        'data' => null,
        'numofpage' => $number_of_page,
        'numberofresult' => $number_of_result
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
