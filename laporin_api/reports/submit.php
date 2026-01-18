<?php
require_once '../config/database.php';
require_once '../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendResponse(false, "Invalid request method");
}

if (!isset($_POST['user_id']) || !isset($_POST['title']) || !isset($_POST['area']) || !isset($_POST['unit'])) {
    sendResponse(false, "Missing required fields");
}

if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    sendResponse(false, "Image is required");
}

$user_id = $_POST['user_id'];
$title = $_POST['title'];
$description = isset($_POST['description']) ? $_POST['description'] : '';
$area = $_POST['area'];
$unit = $_POST['unit'];

$uploadDir = '../uploads/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

$imageExt = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
$imageName = uniqid('report_') . '.' . $imageExt;
$imagePath = $uploadDir . $imageName;

if (!move_uploaded_file($_FILES['image']['tmp_name'], $imagePath)) {
    sendResponse(false, "Failed to upload image");
}

$database = new Database();
$conn = $database->getConnection();

$query = "INSERT INTO reports (user_id, title, description, image, area, unit) VALUES (:user_id, :title, :description, :image, :area, :unit)";
$stmt = $conn->prepare($query);
$stmt->bindParam(':user_id', $user_id);
$stmt->bindParam(':title', $title);
$stmt->bindParam(':description', $description);
$stmt->bindParam(':image', $imageName);
$stmt->bindParam(':area', $area);
$stmt->bindParam(':unit', $unit);

if ($stmt->execute()) {
    $reportId = $conn->lastInsertId();
    sendResponse(true, "Report submitted successfully", ["id" => $reportId]);
} else {
    unlink($imagePath);
    sendResponse(false, "Failed to submit report");
}
