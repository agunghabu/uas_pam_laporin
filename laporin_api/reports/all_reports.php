<?php
require_once '../config/database.php';
require_once '../config/helpers.php';

$status = isset($_GET['status']) ? $_GET['status'] : null;

$database = new Database();
$conn = $database->getConnection();

if ($status) {
    $query = "SELECT r.*, u.name as user_name FROM reports r LEFT JOIN users u ON r.user_id = u.user_id WHERE r.status = :status ORDER BY r.created_at DESC";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':status', $status);
} else {
    $query = "SELECT r.*, u.name as user_name FROM reports r LEFT JOIN users u ON r.user_id = u.user_id ORDER BY r.created_at DESC";
    $stmt = $conn->prepare($query);
}

$stmt->execute();
$reports = $stmt->fetchAll(PDO::FETCH_ASSOC);

sendResponse(true, "Reports fetched successfully", $reports);
