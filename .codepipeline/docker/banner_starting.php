<?php http_response_code(503); ?>
<!DOCTYPE html>
<!--NORELOAD-->
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starting Cosine</title>
    <style>
        body {
            background-color: #ddd;
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        h1 {
            font-size: 3em;
            color: #333;
        }
        p {
            font-size: 1.5em;
            color: #666;
        }
        /* Animation */
        .dots::after {
            content: '.';
            animation: dot-animation 2s infinite steps(1, end);
        }

        @keyframes dot-animation {
            0% { content: '\00a0\00a0\00a0'; }
            25% { content: '.\00a0\00a0'; }
            50% { content: '..\00a0'; }
            75% { content: '...'; }
        }
    </style>
    <script>
        // Every 1s Fetch / and if it doesnt contain <!--BANNER--> then redirect to /
        setInterval(() => {
            fetch('/').then(response => response.text()).then(text => {
                if (!text.includes('<!--NORELOAD-->')) {
                    window.location.href = '/';
                }
            });
        }, 1000);
    </script>
</head>
<body>
    <h1>Starting Cosine</h1>
    <p>Please wait<span class="dots"></span></p>
</body>
</html>
