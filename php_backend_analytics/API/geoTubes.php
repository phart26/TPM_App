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
        try{
        $secret_key = 'Acfd5xy4!';
        $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));

        $job = $_GET['job'];
        // determine sheet
        $tube_ids = array();

        //cutoff tubes
        if($_GET['sheet'] == "cSCs"){
            $sql = "SELECT * FROM tubes_tbl WHERE job= '$job' AND mill_check = 1 AND cutoff_check = 0";

            if ($resultConn= $conn -> query($sql)) {
            
            }
            $tubes = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_assoc($resultConn)){
                $tubes[] = $order;
            }

        }

        //inspection tubes
        if($_GET['sheet'] == "iSCs"){
            $sql = "SELECT * FROM tubes_tbl WHERE job= '$job' AND cutoff_check = 1 AND insp_check = 0";

            if ($resultConn= $conn -> query($sql)) {
            
            }
            $tubes = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_assoc($resultConn)){
                $tubes[] = $order;
            }

        }

        //ring weld tubes
        if($_GET['sheet'] == "rWS"){
            $sql = "SELECT * FROM tubes_tbl WHERE job= '$job' AND insp_check = 1 AND geo_ring_weld = 0";

            if ($resultConn= $conn -> query($sql)) {
            
            }
            $tubes = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_assoc($resultConn)){
                $tubes[] = $order;
            }

        }

        //Final inspection tubes
        if($_GET['sheet'] == "fIGf"){
            $sql = "SELECT * FROM tubes_tbl WHERE job= '$job' AND geo_ring_weld = 1 AND final_insp = 0";

            if ($resultConn= $conn -> query($sql)) {
            
            }
            $tubes = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_assoc($resultConn)){
                $tubes[] = $order;
            }

        }

        //add tube ids to array
        foreach($tubes as $tube){
            array_push($tube_ids, $tube['id']);
        }

        //JSON Output
        $jobOutput = array('tubes' => $tube_ids);
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