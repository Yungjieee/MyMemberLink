<?php

include_once("dbconnect.php");

$results_per_page = 10;

// Get the current page number
if (isset($_GET['pageno'])) {
    $pageno = (int)$_GET['pageno'];
} else {
    $pageno = 1;
}

// Check if userEmail is provided in the POST request
if (isset($_POST['userEmail'])) {
    $userEmail = $_POST['userEmail'];
} else {
    $response = array('status' => 'failed', 'message' => 'User email missing');
    sendJsonResponse($response);
    die();
}

// Retrieve search query if provided
$search = isset($_GET['search']) ? $_GET['search'] : null;

// Get user ID based on email
$sqlGetUserId = "SELECT `user_id` FROM `tbl_users` WHERE `user_email` = '$userEmail'";
$resultUserId = $conn->query($sqlGetUserId);

if ($resultUserId->num_rows > 0) {
    $rowUser = $resultUserId->fetch_assoc();
    $userId = $rowUser['user_id'];
} else {
    $response = array('status' => 'failed', 'message' => 'User not found');
    sendJsonResponse($response);
    die();
}

// Calculate pagination
$page_first_result = ($pageno - 1) * $results_per_page;

// Base SQL query to fetch favourite news
$sqlloadfavourites = "
    SELECT n.*, 1 AS isFavourite
    FROM `tbl_favourites` f
    JOIN `tbl_news` n ON f.news_id = n.news_id
    WHERE f.user_id = '$userId'";

// Append search condition if a search query is provided
if ($search) {
    $search = $conn->real_escape_string($search); // Prevent SQL injection
    $sqlloadfavourites .= " AND (n.news_title LIKE '%$search%' OR n.news_details LIKE '%$search%')";
}

// Get the total number of results for pagination
$sqlCountFavourites = "SELECT COUNT(*) AS total FROM ($sqlloadfavourites) AS filtered";
$resultCount = $conn->query($sqlCountFavourites);

$numofpage = 1;
$numberofresult = 0;

if ($resultCount && $rowCount = $resultCount->fetch_assoc()) {
    $numberofresult = $rowCount['total'];
    $numofpage = ceil($numberofresult / $results_per_page);
}

// Append ordering and pagination to the SQL query
$sqlloadfavourites .= " ORDER BY f.dateoffavourite DESC LIMIT $page_first_result, $results_per_page";

$result = $conn->query($sqlloadfavourites);

$newsarray = array();
if ($result && $result->num_rows > 0) {
    $newsarray['news'] = array();

    while ($row = $result->fetch_assoc()) {
        $news = array();
        $news['news_id'] = $row['news_id'];
        $news['news_title'] = $row['news_title'];
        $news['news_details'] = $row['news_details'];
        $news['news_date'] = $row['news_date'];
        $news['isFavourite'] = 1; // Explicitly set favourite status
        array_push($newsarray['news'], $news);
    }
} else {
    // Return an empty "news" array if no favourites are found
    $newsarray['news'] = array();
}

// Prepare final response
$response = array(
    'status' => 'success',
    'data' => $newsarray,
    'numofpage' => $numofpage, // Ensure numofpage is always set
    'numberofresult' => $numberofresult // Ensure numberofresult is always set
);

// Send JSON response
sendJsonResponse($response);

// Function to send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>
