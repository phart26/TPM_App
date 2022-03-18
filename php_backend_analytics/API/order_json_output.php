
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

//define("BASE_PATH", "./REST_PDFs/"); //folder I have all the JSON php files in



/*$token = $_GET['token'];
$orderID = $_GET['id'];
$startNum = $_GET['start_no'];
$endNum = $_GET['end_no'];*/


/*require_once BASE_PATH . 'config.php';
require_once BASE_PATH . 'vendor/functions.php';
require_once BASE_PATH . 'vendor/Mysql.php';*/

require_once 'REST_Calls.php';
require_once 'createJWT.php';
require './vendor/autoload.php';
use \Firebase\JWT\JWT;

if(isset($_GET['userToken'])){
    $userToken = $_GET['userToken'];
    $job = $_GET['job'];
    try{
        $secret_key = 'Acfd5xy4!';
        $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));
        

        $pages = array();

        if(isset($_GET['page1'])){
            array_push($pages, $_GET['page1']);
        }
        
        if(isset($_GET['page2'])){
            array_push($pages, $_GET['page2']);
        }
    
    if(isset($_GET['page3'])){
        array_push($pages, $_GET['page3']);
        }

        if(isset($_GET['page4'])){
            array_push($pages, $_GET['page4']);
        }

        if(isset($_GET['page5'])){
            array_push($pages, $_GET['page5']);
        }

        if(isset($_GET['page6'])){
            array_push($pages, $_GET['page6']);
        }

        if(isset($_GET['page7'])){
            array_push($pages, $_GET['page7']);
        }

        if(isset($_GET['page8'])){
            array_push($pages, $_GET['page8']);
        }

        if(isset($_GET['page9'])){
            array_push($pages, $_GET['page9']);
        }

        if(isset($_GET['page10'])){
            array_push($pages, $_GET['page10']);
        }

        if(isset($_GET['page11'])){
            array_push($pages, $_GET['page11']);
        }

        if(isset($_GET['page12'])){
            array_push($pages, $_GET['page12']);
        }

        if(isset($_GET['page13'])){
            array_push($pages, $_GET['page13']);
        }

        if(isset($_GET['page14'])){
            array_push($pages, $_GET['page14']);
        }

        if(isset($_GET['page15'])){
            array_push($pages, $_GET['page15']);
        }

        $sql = "UPDATE orders_tbl SET has_started = 1 WHERE job = $job";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        $result = processRequest($pages, $_SERVER['REQUEST_METHOD'], $job);

        echo json_encode(['status_code_header' => $result["status_code_header"],
                          'body'               => json_decode($result["body"])
                        ]);
        exit;

    }catch(Exception $ex){
        http_response_code(500);
        echo json_encode(array(
            "status" => 0,
            "message" => $ex->getMessage()
        ));
    }
}

//$pagess= $_GET["pages"];











?>