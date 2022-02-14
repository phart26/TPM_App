<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include '../Connections/connectionTPM.php';
require_once 'createJWT.php';
require './vendor/autoload.php';
use \Firebase\JWT\JWT;

if(isset($_GET['userToken'])){
    $userToken = $_GET['userToken'];
    $job = $_GET['job'];
    try{
    $secret_key = 'Acfd5xy4!';
    $decoded_data = JSON_encode(JWT::decode($userToken, $secret_key, array('HS512')));
    

    
    $sql = "SELECT * FROM stamping_orders_tbl WHERE job = '$job'";

    if ($result= $conn -> query($sql)) {
        
        }
        
    //fetch resulting rows as an array
    $orderACT = mysqli_fetch_assoc($result);

    $sql1 = "SELECT * FROM part_tbl WHERE part = '".$orderACT['part']."'";

    if ($result1= $conn -> query($sql1)) {
        
        }
        
    //fetch resulting rows as an array
    $partSpec = mysqli_fetch_assoc($result1);

    
    

    $sql1 = "SELECT * FROM cust_tbl WHERE cust_id = '".$orderACT['cust_id']."'";

    if ($result1= $conn -> query($sql1)) {
        
        }
        
    //fetch resulting rows as an array
    $customerArr = mysqli_fetch_assoc($result1);

    if(doubleval($orderACT['linear_feet']) > 0){
        $cycles = strval(ceil(doubleval($orderACT['linear_feet'])/((doubleval($partSpec['progression']) * 1000) / 12)));
        $sql1 = "UPDATE stamping_orders_tbl SET cycles = '$cycles' WHERE job = '$job'";

        if ($result1= $conn -> query($sql1)) {
            
        }
        $orderACT['cycles'] = $cycles;
    }
    

    $jsonArr = array(
        'job' => $job,
        'has_started' => $orderACT['has_started'],
        'customer' => $customerArr['customer'],
        'part' => $orderACT['part'],
        'cycles' => $orderACT['cycles'],
        'linFeet' => $orderACT['linear_feet'],
        'rouselle' => $orderACT['rouselle'],
        'niagara' => $orderACT['niagara'],
        'rouselleAlt' => $orderACT['rouselleAlt'],
        'niagaraAlt' => $orderACT['niagaraAlt'],
        'blankArea' => $orderACT['blank_area'],
        'blankAreaAlt' => $orderACT['blank_areaAlt'],
        'stripWidth' => $orderACT['strip'],
        'stripWidthAlt' => $orderACT['stripAlt'],
        'millJob' => $orderACT['millJob'],
        'millCycles' => $orderACT['millCycles'],
        'remarks' => $orderACT['remarks'],
        'testCycles' => $orderACT['testCycles'],
        'press' => $orderACT['press'],
        'is_louver' => $partSpec['is_louver'],
        'gage' => $partSpec['gage'],
        'matType' => $partSpec['type'],
        'dimpleDepth' => $partSpec['depth_of_dimple'],
        'dimpleDepthP' => $partSpec['depth_of_dimple_plus'],
        'dimpleDepthM' => $partSpec['depth_of_dimple_minus'],
        'die' => $partSpec['die_stamp'],
        'progression' => $partSpec['progression']

    );


//getting coils for the job
    $sql = "SELECT * FROM raw_coil_tbl WHERE job = '$job'";

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }
    $coils = array();
    $coilsJob = array();
    while($order = mysqli_fetch_assoc($result)){
        $coils[] = $order;
    }

    foreach($coils as $coil){
        $sql = "SELECT * FROM steel_tbl WHERE work = '".$coil['work']."'";
        if ($result= $conn -> query($sql)) {

        }
        $heat= mysqli_fetch_assoc($result);
        array_push($coilsJob,array("coil_no" => $coil['coil_no'], "heat" => ($heat['heat'])));
    }

    $jsonArr['coils'] = $coilsJob;

//get current cycle number
    if(intval($orderACT['cycles']) > 0 ){
        $sql = "SELECT * FROM cycle_tbl WHERE job = '$job'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $numCycles = array();
        while($order = mysqli_fetch_assoc($result)){
            $numCycles[] = $order;
        }

        if(sizeof($numCycles) != 0){
            $lastCycle = $numCycles[sizeof($numCycles)-1]['cycle_no'];

            $jsonArr['currentCycle'] = substr($lastCycle, 0, strpos($lastCycle, '-') + 1) . strval(intval(substr($lastCycle, strpos($lastCycle, '-') + 1)) + 1);
            if(intval(substr($lastCycle, strpos($lastCycle, '-') + 1)) == $numCycles){
                $jsonArr['currentCycle'] = "";
            }
            $jsonArr['complCycles'] = strval(sizeof($numCycles));

        }else{
            $jsonArr['currentCycle'] = "";
            $jsonArr['complCycles'] = "0";
        }
    }
    $jsonArr = JSON_encode($jsonArr);

    $response['status_code_header'] = 'HTTP/1.1 200 OK';
    $response['body'] = $jsonArr; //JSON object from mergeJSON
    print_r($response);

    

    }catch(Exception $ex){
        http_response_code(500);
        echo json_encode(array(
            "status" => 0,
            "message" => $ex->getMessage()
        ));
    }
}