<?php
    include '../Connections/connectionTPM.php';
?>


<?php
    require_once 'createJWT.php';
    require './vendor/autoload.php';
    use \Firebase\JWT\JWT;
    if(isset($_GET['userToken'])){

        //checking authentication
        $userToken = $_GET['userToken'];
        $mac_add = $_GET['mac_add'];
        try{
        $secret_key = 'Acfd5xy4!';
        $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));
        
        //get mill device is linked to
        $sql = 'SELECT * FROM mac_add_tbl WHERE MAC_address = "'.$mac_add.'"';

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $dbResult = mysqli_fetch_assoc($resultConn);
        $mill = $dbResult['device'];

        //get job number linked to that mill
        $sql = 'SELECT * FROM orders_tbl WHERE device = "'.$mill.'" AND has_finished = 0';

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $dbResult = mysqli_fetch_assoc($resultConn);

        //JSON Output
        $jobOutput = array('job' => $dbResult['job']);
        $response['status_code_header'] = 'HTTP/1.1 200 OK';
        $response['body'] = $jobOutput;
        print_r($response);

        }catch(Exception $ex){
            http_response_code(500);
            echo json_encode(array(
                "status" => 0,
                "message" => $ex->getMessage()
            ));
        }
    }
?>
