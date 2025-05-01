<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Result</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;700;900&display=swap');

        :root {
            --color-icons: yellow;
            --color-dark: #37393a;
            --color-seconsary: #1c97e9;
            --color-light: #fff;
            --color-primary: #003af7;
            --color-darkest: #1f2122;
            --color-bg-body: var(--color-dark);
            --distance-primary: 50px;
            --font-size-primary: 16px;
            --padding-primary: var(--distance-primary);
            --margin-primary: var(--distance-primary);
            --border-radius-primary: calc(var(--distance-primary)/2);
            --font-weight-bold: 700;
            --font-weight-normal: 300;
            --font-weight-bolder: 900;
            --font-family-primary: "Poppins", sans-serif;
        }

        body {
            font-family: var(--font-family-primary);
            background-color: var(--color-bg-body);
            color: var(--color-light);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        .result-container {
            text-align: center;
            padding: var(--padding-primary);
            background-color: var(--color-darkest);
            border-radius: var(--border-radius-primary);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }

        .result-message {
            font-size: 1.5rem;
            margin-bottom: var(--margin-primary);
            font-weight: var(--font-weight-bold);
        }

        .success {
            color: #4CAF50;
        }

        .error {
            color: #f44336;
        }

        .home-button {
            display: inline-block;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: var(--font-weight-bold);
            transition: all 0.3s ease;
        }

        .success-button {
            background-color: #4CAF50;
            color: white;
        }

        .error-button {
            background-color: #f44336;
            color: white;
        }

        .home-button:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="result-container">
        <?php
        $status = $_GET['status'] ?? '';
        $message = $_GET['message'] ?? 'Unknown status';
        
        if ($status === 'success') {
            echo '<div class="result-message success">' . htmlspecialchars(urldecode($message)) . '</div>';
            echo '<a href="index.html" class="home-button success-button">Back to Home</a>';
        } else {
            echo '<div class="result-message error">' . htmlspecialchars(urldecode($message)) . '</div>';
            echo '<a href="index.html" class="home-button error-button">Back to Home</a>';
        }
        ?>
    </div>
</body>
</html>