<?php
require_once '../config/database.php';
require_once '../config/helpers.php';

if (!isset($_GET['user_id'])) {
    sendResponse(false, "User ID is required");
}

$user_id = $_GET['user_id'];

$database = new Database();
$conn = $database->getConnection();

$query = "SELECT * FROM reports WHERE user_id = :user_id ORDER BY created_at DESC";
$stmt = $conn->prepare($query);
$stmt->bindParam(':user_id', $user_id);
$stmt->execute();

$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);

sendResponse(true, "Reports fetched successfully", $reports);
