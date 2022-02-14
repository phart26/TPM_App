<?php

    
        require './vendor/autoload.php';
        use \Firebase\JWT\JWT;

        if(isset($_GET['username'])){
            
            $username = $_GET['username'];
            $password = $_GET['password'];


            //verify username and password

            $secret_key = "Acfd5xy4!";

            $payload_info = array(
                "iss" => "localhost",
                "iat" => time(),
                "nbf" => time() + 10,
                "aud" => "myusers",
                "user_data" => array(
                    "username" => $username,
                    "password" => $password
                )
            );

            $jwt = JSON_encode(JWT::encode($payload_info, $secret_key, 'HS512'));

            echo $jwt;
        }
    

    
?>
