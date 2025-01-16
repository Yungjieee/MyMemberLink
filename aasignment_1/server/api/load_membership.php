<?php
include_once("dbconnect.php");

$results_per_page = 20;
if (isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

$sqlloadmembership = "SELECT * FROM `tbl_membership`";
$result = $conn->query($sqlloadmembership);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadmembership = $sqlloadmembership." LIMIT $page_first_result, $results_per_page";

$result = $conn->query($sqlloadmembership);
// `membership_name`,`membership_description`,`membership_price`,`membership_benefit1`,`membership_benefit2`,
// `membership_benefit3`,`membership_duration`,`membership_term1`,`membership_term2`
if ($result->num_rows > 0) {
    $membershiparray['memberships'] = array();
    while ($row = $result->fetch_assoc()) {
        $membership = array();
        $membership['membership_id'] = $row['membership_id'];
        $membership['membership_name'] = $row['membership_name'];
        $membership['membership_description'] = $row['membership_description'];
        $membership['membership_price'] = $row['membership_price'];

        // Split membership_benefit and membership_term by full stop (.)
        $membership['membership_benefits'] = array_filter(explode('.', $row['membership_benefit']));
        $membership['membership_terms'] = array_filter(explode('.', $row['membership_terms']));

        $membership['membership_duration'] = $row['membership_duration'];
        array_push($membershiparray['memberships'], $membership);
    }
    $response = array(
        'status' => 'success',
        'data' => $membershiparray,
        'numofpage' => $number_of_page,
        'numberofresult' => $number_of_result
    );
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