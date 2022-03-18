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
            $sql = "SELECT * FROM mac_add_tbl WHERE MAC_address = '".$mac_add."'";

            $resultConn = $conn -> query($sql);

            if (!empty($resultConn)) {

                $dbResult = $resultConn->fetch_array();

                if(empty($dbResult['device'])){
                    errorNotify("Not exist mac_address: $mac_add");
                    exit;
                }
                
                $mill = $dbResult['device'];

                //get job number linked to that mill
                $sql = "SELECT * FROM orders_tbl WHERE device = '".$mill."' AND has_finished = 0";
                $_resultConn = $conn -> query($sql);

                if(!empty($_resultConn)){

                    $dbResult = array();
                    //fetch resulting rows as an array
                    while($order = $_resultConn->fetch_assoc()){
                        $dbResult[] = $order;
                    }

                    $currentJob = "";
                    if(empty($dbResult)){
                        $currentJob = "";
                    }else{
                        foreach($dbResult as $jobNum){

                            if($jobNum['has_started'] == 1){
                                $currentJob = strval($jobNum['job']);
                            }
                        }

                        if($currentJob == ''){
                            $currentJob = strval($dbResult[0]['job']);
                        }
                    }

                    //JSON Output
                    $response['status_code_header'] = 'HTTP/1.1 200 OK';
                    $response['body'] = ['job' => $currentJob];
                    echo json_encode($response);

                }else{
                    errorNotify("Invalid DB query!");
                }
                
            }else{
                errorNotify("Invalid DB query!");          
            }

        }catch(Exception $ex){
            errorNotify($ex->getMessage());            
        }
    }

    function errorNotify($msg, $code=500){
        http_response_code($code);
        echo json_encode(["status" => 0, "message" => $msg]);
        exit;
    }
?>
