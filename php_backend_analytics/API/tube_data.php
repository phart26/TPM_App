<?php
    include '../Connections/connectionTPM.php';
?>

<?php

    function processRequest($method){
            
        //$path = $_GET['path'];
        $response = [];
         
        switch ($method) {
        case 'PUT':  
            break;
        case 'POST':
            $data = JSON_decode(file_get_contents('php://input'), TRUE);
            $response = $data['tubeData'];
            break;
        case 'GET':
            break;
        default:
            $response = notFound();  
            break;
        }

        return $response;
    }

    function notFound(){
        echo  'No data found';
    }
?>

<?php
    if(isset($_POST)){
        $results = processRequest($_SERVER['REQUEST_METHOD']);

        if(array_key_exists('first_tube', $results)){
            $result= $results['first_tube'];

            date_default_timezone_set("US/Central");
            $setup_op = $result['setup_op'];
            $timeStamp = date("Y-m-d H:i:s");
            $job = $result['job'];
            $coil = $result['coil'];
            $filterTop = !empty($result['filter_mesh_top']) ? $result['filter_mesh_top'] : "";
            $drainTop = !empty($result['drain_mesh_top']) ?  $result['drain_mesh_top'] : "";
            $filterBot = !empty($result['filter_mesh_bot']) ? $result['filter_mesh_bot'] : "";
            $drainBot = !empty($result['drain_mesh_bot']) ? $result['drain_mesh_bot'] : "";
            $qty = !empty($result['qty']) ? $result['qty'] : 0;
            $job_id = strval($job) . "-";
            $tube_no = "1";
            $tube_id = str_pad($tube_no, strlen($qty), "0", STR_PAD_LEFT);
            $tube_id = $job_id . $tube_id;   

            $sql = "INSERT INTO tubes_tbl(id, job, setup_op, coil_change, coil, fil_mesh_change_top, filter_mesh_top, fil_mesh_change_bot, filter_mesh_bot, drain_change_top, drain_mesh_top, drain_change_bot, drain_mesh_bot, mill_time, mill_check) VALUES('$tube_id', '$job', '$setup_op', '".(!empty($result['new_coil']) ? $result['new_coil'] : "")."', '$coil', '".(!empty($result['new_filter_top']) ? $result['new_filter_top'] : "")."', '$filterTop', '".(!empty($result['new_filter_bot']) ? $result['new_filter_bot'] : "")."', '$filterBot', '".(!empty($result['new_drain_top']) ? $result['new_drain_top'] : "")."', '$drainTop', '".(!empty($result['new_drain_bot']) ? $result['new_drain_bot'] : "")."', '$drainBot', '$timeStamp', 0)";

            $resultConn = $conn->query($sql);

            if(!$resultConn) {
                echo json_encode(['first_tube_reg' => false, 'msg' => 'first tube already exist' ]);
                exit;                

            }else{
                
                $sql = "UPDATE orders_tbl SET began = '$timeStamp' WHERE job = '$job'";                
                $conn -> query($sql);

                echo json_encode(['first_tube_reg' => true, 'msg' => 'first tube registered' ]);                
                exit;
            }

        }

        if(array_key_exists('weld_chksheet', $results)){
           $result= $results['weld_chksheet'];

            date_default_timezone_set("US/Central");
            $setup_op = $result['setup_op'];
            $timeStamp = date("Y-m-d H:i:s");
            $mill_op = $result['mill_op'];
            $job = $result['job'];
            $tube_id = $result['tube_id'];
            $od_check1 = $result['od_check1'];
            $od_check2 = $result['od_check2'];
            $scrap_tube = $result['scrap_tube'];
            $coil = $result['coil'];
            $filterTop = $result['filter_mesh_top'];
            $drainTop = $result['drain_mesh_top'];
            $filterBot = $result['filter_mesh_bot'];
            $drainBot = $result['drain_mesh_bot'];
            $isFirstTube = $result['isFirstTube'];
            print_r($result);
            
            if($scrap_tube == 1){
                $sql = "UPDATE tubes_tbl SET mill_check = 1, od_check1 = '$od_check1', od_check2 = '$od_check2', coil_change = '".$result['new_coil']."', coil = '$coil', fil_mesh_change_top = '".$result['new_filter_top']."', filter_mesh_top = '$filterTop', fil_mesh_change_bot = '".$result['new_filter_bot']."', filter_mesh_bot = '$filterBot', drain_change_top = '".$result['new_drain_top']."', drain_mesh_top = '$drainTop', drain_change_bot = '".$result['new_drain_bot']."', drain_mesh_bot = '$drainBot', mill_operator = '$mill_op', mill_time = '$timeStamp' WHERE id = '$tube_id'";

                if ($resultConn= $conn -> query($sql)) {
            
                }
            }else if($isFirstTube == 1){
                

                $sql = "UPDATE tubes_tbl SET od_check1 = '$od_check1', od_check2 = '$od_check2', mill_operator = '$mill_op', mill_check = 1, mill_time = '$timeStamp' WHERE id = '$tube_id'";
            
                if ($resultConn= $conn -> query($sql)) {
            
                }

                
            }else{ 
                $sql = "INSERT INTO tubes_tbl(id, job, setup_op, od_check1, od_check2, coil_change, coil, fil_mesh_change_top, filter_mesh_top, fil_mesh_change_bot, filter_mesh_bot, drain_change_top, drain_mesh_top, drain_change_bot, drain_mesh_bot, mill_operator, mill_time, mill_check) VALUES('$tube_id', '$job', '$setup_op', '$od_check1', '$od_check2', '".$result['new_coil']."', '$coil', '".$result['new_filter_top']."', '$filterTop', '".$result['new_filter_bot']."', '$filterBot', '".$result['new_drain_top']."', '$drainTop', '".$result['new_drain_bot']."', '$drainBot', '$mill_op', '$timeStamp', 1)";

                if ($resultConn= $conn -> query($sql)) {
                
                }
            }
                
        }

        if(array_key_exists('cutoff', $results)){
            $result= $results['cutoff'];

            date_default_timezone_set("US/Central");
            $length_check1 = $result['length_check1'];
            $cut_time = date("Y-m-d H:i:s");
            
            $tube_id = $result['tube_id'];
            $cut_op = $result['cut_op'];
            print_r($result);
            
            

            $sql = "UPDATE tubes_tbl SET length_check1 = '$length_check1', cutoff_operator = '$cut_op', cutoff_time = '$cut_time', cutoff_check = 1 WHERE id = '$tube_id'";

            if ($resultConn= $conn -> query($sql)) {
        
            }

            if(!empty($result['heat_num_cutoff'])){
                $heat_num = $result['heat_num_cutoff'];
                $manufac = $result['manufac_cutoff'];
                $sql = "UPDATE tubes_tbl SET filler_rod_change_cutoff = 1, heat_num_cutoff = '$heat_num', manufac_cutoff = '$manufac' WHERE id = '$tube_id'";

                if ($resultConn= $conn -> query($sql)) {
            
                }
            }

            if(array_key_exists('remarks_cut', $result)){
                $remarks_cut = $result['remarks_cut'];
                $sql = "UPDATE tubes_tbl SET  remarks_cut = '$remarks_cut' WHERE id = '$tube_id'";

                if ($resultConn= $conn -> query($sql)) {
            
                }
            }

           
        }



        if(array_key_exists('ring_station_chksheet', $results)){
            $result= $results['ring_station_chksheet'];

            date_default_timezone_set("US/Central");
            $end1_read1 = $result['end1_read1'];
            $timeStamp = date("Y-m-d H:i:s");
            $end1_read2 = $result['end1_read2'];
            $end1_avg = $result['end1_avg'];
            $end2_read1 = $result['end2_read1'];
            $end2_read2 = $result['end2_read2'];
            $end2_avg = $result['end2_avg'];
            $ring_end_insp = $result['ring_end_insp'];
            $tube_id = $result['tube_id'];
            print_r($result);
            
            

            $sql = "UPDATE tubes_tbl SET end1_read1 = '$end1_read1', end1_read2 = '$end1_read2', end1_avg = '$end1_avg', end2_read1 = '$end2_read1', end2_read2 = '$end2_read2', end2_avg = '$end2_avg', ring_end_insp = '$ring_end_insp', ring_end_time = '$timeStamp' WHERE id = '$tube_id'";

            if ($resultConn= $conn -> query($sql)) {
        
            }

            
        }

   

        if(array_key_exists('geo_ring_insp', $results)){
           $result= $results['geo_ring_insp'];

            date_default_timezone_set("US/Central");
            $ring_id = $result['ring_id'];
            $timeStamp = date("Y-m-d H:i:s");
            $inspector = $result['inspector'];
            $job = $result['job'];
            $batch_num = $result['batch_num'];
            $ID = $result['ID'];
            $OD = $result['OD'];
            $length_check = $result['length_check'];
            $finish = $result['finish'];
            print_r($result);
            

            $sql = "INSERT INTO ring_tbl(ring_id, job, inspector, batch_num, ID, OD, length_check, finish, time_insp) VALUES('$ring_id', '$job', '$inspector', '$batch_num', '$ID', '$OD', '$length_check', '$finish', '$timeStamp')";

            if ($resultConn= $conn -> query($sql)) {
        
            }
        }



        if(array_key_exists('final_insp_geo', $results)){
            $result= $results['final_insp_geo'];

            date_default_timezone_set("US/Central");
            $id_drift = $result['id_drift'];
            $timeStamp = date("Y-m-d H:i:s");
            $length_check3 = $result['length_check3'];
            $ring_num1 = $result['ring_num1'];
            $ring_num2 = $result['ring_num2'];
            $inspector = $result['inspector'];
            $tube_id = $result['tube_id'];
            print_r($result);
            
            
            

            $sql = "UPDATE tubes_tbl SET id_drift2 = '$id_drift', final_length_check = '$length_check3', ring_num1 = '$ring_num1', ring_num2 = '$ring_num2', final_inspector = '$inspector', final_insp_time = '$timeStamp', final_insp = 1 WHERE id = '$tube_id'";

            if ($resultConn= $conn -> query($sql)) {
        
            }
        }

        if(array_key_exists('drift_dimension', $results)){
            $result= $results['drift_dimension'];

            date_default_timezone_set("US/Central");
            $drift_dim = $result['drift_dim'];
            $timeStamp = date("Y-m-d H:i:s");
            $drift_insp = $result['drift_insp'];
            $job = $result['job'];
            print_r($result);

            $sql = "UPDATE orders_tbl SET drift_dim = '$drift_dim', drift_insp = '$drift_insp', drift_insp_time = '$timeStamp' WHERE job = '$job'";

            if ($resultConn= $conn -> query($sql)) {
        
            }
        }


        if(array_key_exists('insp_station_chksheet', $results)){
            $result= $results['insp_station_chksheet'];

            date_default_timezone_set("US/Central");
            $id_drift = $result['id_drift'];
            $timeStamp = date("Y-m-d H:i:s");
            $od_check3 = $result['od_check3'];
            $length_check2 = $result['length_check2'];
            $weld = $result['weld'];
            $repairs = $result['repairs'];
            $inspector = $result['inspector'];
            $tube_id = $result['tube_id'];
            $job = $result['job'];
            print_r($result);

            $sql = "UPDATE tubes_tbl SET id_drift = '$id_drift', od_check3 = '$od_check3', length_check2 = '$length_check2', weld = '$weld', repairs = '$repairs', inspector = '$inspector', insp_time = '$timeStamp', insp_check = 1 WHERE id = '$tube_id'";

            if ($resultConn= $conn -> query($sql)) {
        
            }
        }

        if(array_key_exists('geo_weld', $results)){
            $result= $results['geo_weld'];

            date_default_timezone_set("US/Central");
            $geo_ring_weld_time = date("Y-m-d H:i:s");
            $tube_id = $result['tube_id'];
            $ringA = $result['ringA'];
            $ringB = $result['ringB'];
            print_r($result);
           
            
            

            $sql = "UPDATE tubes_tbl SET geo_ring_weld = 1, ringA = '$ringA', ringB='$ringB', geo_ring_weld_time = '$geo_ring_weld_time' WHERE id = '$tube_id'";

            if ($resultConn= $conn -> query($sql)) {
        
            }

            if(!empty($result['heat_num_weld'])){
                $heat_num = $result['heat_num_weld'];
                $manufac = $result['manufac_weld'];
                $sql = "UPDATE tubes_tbl SET filler_rod_change_weld = 1, heat_num_weld = '$heat_num', manufac_weld = '$manufac' WHERE id = '$tube_id'";

                if ($resultConn= $conn -> query($sql)) {
            
                }
            }
        }

}
    
?>