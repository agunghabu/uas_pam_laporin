<?php
require_once '../config/database.php';
require_once '../config/helpers.php';

$data = getInputData();

if (!isset($data['id']) || !isset($data['status'])) {
    sendResponse(false, "Report ID and status are required");
}

$id = $data['id'];
$status = $data['status'];

$validStatuses = ['pending', 'active', 'completed', 'rejected'];
if (!in_array($status, $validStatuses)) {
    sendResponse(false, "Invalid status");
}

$database = new Database();
$conn = $database->getConnection();

$query = "UPDATE reports SET status = :status WHERE id = :id";
$stmt = $conn->prepare($query);
$stmt->bindParam(':id', $id);
$stmt->bindParam(':status', $status);

if ($stmt->execute()) {
    sendResponse(true, "Report status updated successfully");
} else {
    sendResponse(false, "Failed to update report status");
}
