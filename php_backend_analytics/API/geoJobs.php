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

        //get job number linked to that mill
        $sql = "SELECT * FROM orders_tbl WHERE has_finished = 0";

        if ($resultConn= $conn -> query($sql)) {
        
        }

        $jobs = array();
        $geoJobs = array();
        //fetch resulting rows as an array
        while($order = mysqli_fetch_assoc($resultConn)){
            $jobs[] = $order;
        }

        foreach($jobs as $job){
            $part_num = $job['part'];
            $sql = "SELECT * FROM part_tbl WHERE part = '$part_num'";

            if ($resultConn= $conn -> query($sql)) {
            
            }

            $part = mysqli_fetch_assoc($resultConn);

            if($part['geo_job'] == 1){
                $geo_job = array("job_no" => $job['job'], "od" => $part['dim'], "length" => $part['finished_length']);
                array_push($geoJobs, $geo_job);
            }
        }

        //JSON Output
        $jobOutput = array('geoJobs' => $geoJobs);
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