<?php http_response_code(500); ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cosine</title>
    <style>
        body {
            background-color: #ddd;
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        h1 {
            font-size: 3em;
            color: #4e1e1e;
        }
        p {
            font-size: 1.5em;
            color: #666;
        }
    </style>
</head>
<body>
    <h1>Could not start Cosine</h1>
    <p>There was an error starting Cosine</p>
    <p class="reason"><!--REASON--></p>
</body>
</html>
