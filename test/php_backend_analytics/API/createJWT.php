<?php

    
        require './vendor/autoload.php';
        use \Firebase\JWT\JWT;
        include '../Connections/connectionTPM.php';

        if(isset($_GET['userID'])){
            
            $userID = $_GET['userID'];
            // $password = $_GET['password'];


            //verify username and password
            $sql = "SELECT * FROM employee WHERE ID = '$userID'";

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            $user = mysqli_fetch_array($result);

            if(!empty($user)){
                $secret_key = "Acfd5xy4!";

                $payload_info = array(
                    "iss" => "localhost",
                    "iat" => time(),
                    "nbf" => time(),
                    "aud" => "myusers",
                    "user_data" => array(
                        "username" => $user['name'],
                        "password" => $userID
                    )
                );

                $jwt = JWT::encode($payload_info, $secret_key, 'HS512');
                echo JSON_encode(array("userID" => $userID, "userName" => $user['name'], "token" => $jwt));
            }else{
                echo "User not Found!";
            }

            

            
        }
    

    
?>
