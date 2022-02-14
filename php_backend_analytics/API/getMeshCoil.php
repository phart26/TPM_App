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
        $po = $_GET['po'];
        try{
        $secret_key = 'Acfd5xy4!';
        $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));

        //get job number linked to that mill
        $sql = "SELECT * FROM mesh_combos WHERE splice_chk = 0 AND mesh_po = '$po' ORDER BY coil_no ASC";

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $meshes = array();
        //fetch resulting rows as an array
        while($order = mysqli_fetch_assoc($resultConn)){
            $meshes[] = $order;
        }

        $mesh = $meshes[0];
        $mesh['line_item'] = JSON_decode($mesh['line_item']); // line item comes from db as a JSON string

        //JSON Output
        $jobOutput = array('mesh' => $mesh);
        // mesh remaining
        $jobOutput['meshRem'] = count($meshes);
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