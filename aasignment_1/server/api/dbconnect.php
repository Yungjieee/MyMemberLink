<?php
$servername = "localhost";
$username   = "threenqs_mymemberlinkadmin";
$password   = "Threelittlecar456";
$dbname     = "threenqs_mymemberlinkdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>