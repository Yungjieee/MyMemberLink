<?php
//refer to flutterA231/bookbytes/server/bookbytes/php/load_books.php

// include_once("dbconnect.php");

// $results_per_page = 10;

// if (isset($_GET['pageno'])){
// 	$pageno = (int)$_GET['pageno'];
// }else{
// 	$pageno = 1;
// }

// // Get the search query from the request (if provided)
// $search = isset($_GET['search']) ? $_GET['search'] : null;

// $page_first_result = ($pageno - 1) * $results_per_page;

// // Base SQL query to fetch news
// $sqlloadnews = "SELECT * FROM `tbl_news`";

// // Append search condition if a search query is provided
// if ($search) {
//     $search = $conn->real_escape_string($search); // Prevent SQL injection
//     $sqlloadnews .= " WHERE `news_title` LIKE '%$search%' OR `news_details` LIKE '%$search%'";
// }

// $result = $conn->query($sqlloadnews);
// $number_of_result = $result->num_rows;
// $number_of_page = ceil($number_of_result / $results_per_page); //ceiling means 1.2 = 2 pages or 3.5 = 4 pages

// $sqlloadnews = $sqlloadnews. " ORDER BY `news_date` DESC LIMIT $page_first_result , $results_per_page";
// $result = $conn->query($sqlloadnews);

// if ($result->num_rows > 0) {  //more than 0 means success
//     $newsarray['news'] = array();

//     while ($row = $result->fetch_assoc()) {
//         $news = array();
//         $news['news_id'] = $row['news_id'];
//         $news['news_title'] = $row['news_title'];
//         $news['news_details'] = $row['news_details'];
//         $news['news_date'] = $row['news_date'];
//         array_push($newsarray['news'], $news);
//     }

//     $response = array('status' => 'success', 'data' => $newsarray, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result); 
//     sendJsonResponse($response); 
// }else{  //not success
//     $response = array('status' => 'failed', 'data' => null, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result); 
//     sendJsonResponse($response); 
// }

// function sendJsonResponse($sentArray) 
// { 
//     header('Content-Type: application/json'); 
//     echo json_encode($sentArray); 
// }

include_once("dbconnect.php");

$results_per_page = 10;

// Check and fetch the current page number
if (isset($_GET['pageno'])) {
    $pageno = (int)$_GET['pageno'];
} else {
    $pageno = 1;
}

// Get the search query from the request (if provided)
$search = isset($_GET['search']) ? $_GET['search'] : null;

// Get the user email from the request
if (isset($_POST['userEmail'])) {
    $userEmail = $_POST['userEmail'];
} else {
    $response = array('status' => 'failed', 'message' => 'User email missing');
    sendJsonResponse($response);
    die();
}

// Get sorting order from the request (default is DESC)
$order = isset($_GET['order']) && $_GET['order'] === 'ASC' ? 'ASC' : 'DESC';

// Get user ID from email
$sqlGetUserId = "SELECT user_id FROM tbl_users WHERE user_email = '$userEmail'";
$resultUserId = $conn->query($sqlGetUserId);

if ($resultUserId->num_rows > 0) {
    $rowUser = $resultUserId->fetch_assoc();
    $userId = $rowUser['user_id'];
} else {
    $response = array('status' => 'failed', 'message' => 'User not found');
    sendJsonResponse($response);
    die();
}

$page_first_result = ($pageno - 1) * $results_per_page;

// Base SQL query to fetch news and favorite status
$sqlloadnews = "
    SELECT n.*, 
           (SELECT COUNT(*) 
            FROM tbl_favourites f 
            WHERE f.news_id = n.news_id AND f.user_id = '$userId') AS isFavourite
    FROM tbl_news n";

// Append search condition if a search query is provided
if ($search) {
    $search = $conn->real_escape_string($search); // Prevent SQL injection
    $sqlloadnews .= " WHERE n.news_title LIKE '%$search%' OR n.news_details LIKE '%$search%'";
}

// Get the total number of results for pagination
$result = $conn->query($sqlloadnews);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page); // Ceiling for pages

// Append ordering and pagination to the SQL query
$sqlloadnews .= " ORDER BY n.news_date $order LIMIT $page_first_result, $results_per_page";

$result = $conn->query($sqlloadnews);

if ($result->num_rows > 0) {
    $newsarray['news'] = array();

    while ($row = $result->fetch_assoc()) {
        $news = array();
        $news['news_id'] = $row['news_id'];
        $news['news_title'] = $row['news_title'];
        $news['news_details'] = $row['news_details'];
        $news['news_date'] = $row['news_date'];
        $news['isFavourite'] = $row['isFavourite']; // Include favorite status
        array_push($newsarray['news'], $news);
    }

    $response = array(
        'status' => 'success',
        'data' => $newsarray,
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