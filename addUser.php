<?php
// Database configuration
$db_host = 'localhost';
$db_user = 'root';
$db_pass = '';
$db_name = 'FitAura';

// Connect to database
$conn = mysqli_connect($db_host, $db_user, $db_pass, $db_name);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get form data
$first_name = $_POST['first-name'] ?? '';
$last_name = $_POST['last-name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$confirm = $_POST['confirm'] ?? '';

// Escape strings to prevent SQL injection
$first_name = mysqli_real_escape_string($conn, $first_name);
$last_name = mysqli_real_escape_string($conn, $last_name);
$email = mysqli_real_escape_string($conn, $email);

// Check if email already exists
$req = "SELECT * FROM users WHERE email = '$email'";
$rep = mysqli_query($conn, $req);
if (mysqli_num_rows($rep) != 0) {
    header("Location: registration_result.php?status=error&message=Email+already+registered");
    exit();
}

// Validate passwords match
if ($password !== $confirm) {
    header("Location: registration_result.php?status=error&message=Passwords+do+not+match");
    exit();
}

// Hash the password
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Insert new user
$req = "INSERT INTO users (first_name, last_name, email, password_hash) 
        VALUES ('$first_name', '$last_name', '$email', '$password_hash')";
$rep = mysqli_query($conn, $req);

if (mysqli_affected_rows($conn) > 0) {
    header("Location: registration_result.php?status=success&message=Registration+successful");
} else {
    header("Location: registration_result.php?status=error&message=Registration+failed");
}

// Close connection
mysqli_close($conn);
?>