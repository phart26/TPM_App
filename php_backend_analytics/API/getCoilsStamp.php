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
        $job = $_GET['job']; 
        try{

        $secret_key = 'Acfd5xy4!';
        $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));

        //get job number linked to that mill
        $sql = "SELECT * FROM coil_tbl WHERE stamp_job = '$job' AND in_shop = 0";

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $dbResult = array();
        //fetch resulting rows as an array
        while($order = mysqli_fetch_assoc($resultConn)){
            $dbResult[] = $order;
        }
        $currentCoils = [];
        if(empty($dbResult)){
            $currentCoils = [];
        }else{
            foreach($dbResult as $coilNum){
                array_push($currentCoils, strval($coilNum['coil_no']));

            }
        }

        //JSON Output
        $jobOutput = array('coils' => $currentCoils);
        $response['status_code_header'] = 'HTTP/1.1 200 OK';
        $response['body'] = JSON_encode($jobOutput);
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