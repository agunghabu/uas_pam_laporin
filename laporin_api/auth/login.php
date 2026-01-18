<?php
require_once '../config/database.php';
require_once '../config/helpers.php';

$data = getInputData();

if (!isset($data['user_id']) || !isset($data['password'])) {
    sendResponse(false, "User ID and password are required");
}

$user_id = $data['user_id'];
$password = $data['password'];

$database = new Database();
$conn = $database->getConnection();

$query = "SELECT id, user_id, name, role FROM users WHERE user_id = :user_id AND password = :password";
$stmt = $conn->prepare($query);
$stmt->bindParam(':user_id', $user_id);
$stmt->bindParam(':password', $password);
$stmt->execute();

if ($stmt->rowCount() > 0) {
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    sendResponse(true, "Login successful", $user);
} else {
    sendResponse(false, "Invalid credentials");
}
