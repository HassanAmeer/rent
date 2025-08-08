<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "rent_db"; // Your DB name

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed"]));
}

$sql = "SELECT * FROM listings";
$result = $conn->query($sql);

$listings = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $listings[] = $row;
    }
}

echo json_encode(["success" => true, "data" => $listings]);
$conn->close();
?>
