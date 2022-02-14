<?php

    
    function merge($pages, $job){

        define("BASE_PATH", "./REST_PDFs/JSON/");
        $data = array();

        if (in_array("tube_mill_setup", $pages)) {
            

            require_once BASE_PATH . 'tube_mill_setup_json.php';

            $data = $jsonArr;

        }
        
        
        if (in_array("first_part_drift_confirmation", $pages)) {

            require_once BASE_PATH . 'first_part_drift_confirmation_json.php';

            $data = array_merge($data, $jsonArr);
        }
        
        if (in_array("welding_station_check_list", $pages)) {

            require_once BASE_PATH . 'welding_station_check_list_json.php';
            $data = array_merge($data, $jsonArr);        }
        
        if (in_array("worksheet", $pages)) {

            require_once BASE_PATH . 'worksheet_json.php';
            $data = array_merge($data, $jsonArr);        }
        
        if (in_array("dp_inspection", $pages)) {


            require_once BASE_PATH . 'dp_inspection_json.php';
            $data = array_merge($data, $jsonArr);

        }
        
        if (in_array("cutoff_station_check_sheet", $pages)) {

            require_once BASE_PATH . 'cutoff_station_check_sheet_json.php';
            $data = array_merge($data, $jsonArr);
        }
        
        if (in_array("inspection_rpt", $pages)) {

            require_once BASE_PATH . 'inspection_rpt_json.php';
            $data = array_merge($data, $jsonArr);
        }

        if (in_array("final_inspection_geo_form", $pages)) {

            require_once BASE_PATH . 'final_inspection_geo_form_json.php';
            $data = array_merge($data, $jsonArr);
        }
        
        
        if (in_array("ring_station_check_list", $pages)) {

            require_once BASE_PATH . 'ring_station_check_list_json.php';
            $data = array_merge($data, $jsonArr);
        }
        if (in_array("geo_form_ring_inspection", $pages)) {

            require_once BASE_PATH . 'geo_form_ring_inspection_json.php';
            $data = array_merge($data, $jsonArr);
        }
        if (in_array("Mill_station_first_part", $pages)) {

            require_once BASE_PATH . 'Mill_station_first_part_json.php';
            $data = array_merge($data, $jsonArr);
        }
        if (in_array("alloc", $pages)) {

            require_once BASE_PATH . 'alloc_json.php';
            $data = array_merge($data, $jsonArr);
            $data = array_merge($data, $jsonArrFirst);
            $data = array_merge($data, $currentCoil);
        }

        if (in_array("alloc_mesh", $pages)) {

            require_once BASE_PATH . 'alloc_mesh_json.php';

            $data = array_merge($data, $jsonArr);
            $data = array_merge($data, $jsonArrFirst);
            $data = array_merge($data, $currentMesh);
            
        }
        include '../Connections/connectionTPM.php';
        include 'lastTubeDB.php';

        $sql = "SELECT * FROM orders_tbl WHERE job = $job";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        $mill_job = mysqli_fetch_array($result);
        
        $device = $mill_job['device'];

        $sql26 = "SELECT * FROM mac_add_tbl WHERE device = '$device'";

        //make query & get result
        if ($result26= $conn -> query($sql26)) {
            
        }

        $MAC_add = mysqli_fetch_array($result26);

        

        $endJson = array(
            'formData' => $data,
            'lastTubeMill' => $millLT,
            'lastTubeCutoff' => $cutLT,
            'lastTubeInsp' => $inspLT,
            'lastRingEnd' => $ringEndLT,
            'lastRingInsp' => $inspLR,
            'mill' => $mill_job['device'],
            'MAC_add' => $MAC_add['MAC_address']

        );

        
        
        $jobMillarr = array();
        $jobsInsp = array();
        $sql = "SELECT * FROM orders_tbl WHERE has_finished = 0 AND has_started = 1";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        $ordersACT = array();
        
        $activeJobs = array();
        while($order = mysqli_fetch_array($result)){
            $ordersACT[] = $order;
        }
        
        foreach($ordersACT as $jobNum){
            $jobWithODL = array();
            array_push($jobWithODL, $jobNum['job']);
            $sql = "SELECT * FROM part_tbl WHERE part = '".$jobNum['part']."'";
            if ($result= $conn -> query($sql)) {
            
            }
            $subOrder = mysqli_fetch_array($result);
            array_push($jobWithODL, $subOrder['dim']);
            array_push($jobWithODL, $subOrder['finished_length']);
            array_push($activeJobs, $jobWithODL);

        }

        $sql1 = "SELECT * FROM orders_tbl WHERE has_finished = 1 AND has_started = 1 AND job > 7800";

        //make query & get result
        if ($result1= $conn -> query($sql1)) {
            
        }

        $ordersACT = array();
        
        while($order = mysqli_fetch_array($result1)){
            $ordersACT[] = $order;
        }
        
        foreach($ordersACT as $jobNum){
            $sql2 = "SELECT * FROM tubes_tbl WHERE job = '".$jobNum['job']."' AND insp_check = 1";
            if ($result2= $conn -> query($sql2)) {
                
            }

            $tubesArr = array();
            while($order = mysqli_fetch_array($result2)){
                $tubesArr[] = $order;
            }

            $sql3 = "SELECT * FROM orders_tbl WHERE job = '".$jobNum['job']."'";
            if ($result3= $conn -> query($sql3)) {
                
            }
            $order = mysqli_fetch_array($result3);

            if($order['quantity'] != sizeof($tubesArr)){
                $jobWithODL = array();
                array_push($jobWithODL, $jobNum['job']);
                $sql = "SELECT * FROM part_tbl WHERE part = '".$jobNum['part']."'";
                if ($result= $conn -> query($sql)) {
                
                }
                

                $subOrder = mysqli_fetch_array($result);
                array_push($jobWithODL, $subOrder['dim']);
                array_push($jobWithODL, $subOrder['finished_length']);
                array_push($activeJobs, $jobWithODL);
            }
        }

        if(in_array("welding_station_check_list", $pages)){
            $jobMillarr = array('jobMill' => $job);
            $endJson = array_merge($endJson, $jobMillarr);

        }

        if(!empty($activeJobs)){
            $jobsInsp = array('jobsInsp' => $activeJobs);
            $endJson = array_merge($endJson, $jobsInsp);
        }else{
            $jobsInsp = array('jobsInsp' => "");
            $endJson = array_merge($endJson, $jobsInsp);
        }

        //returning tubes remaining for cutoff
        $sql = "SELECT * FROM tubes_tbl WHERE job = '$job' AND mill_check = 1 AND cutoff_check = 1";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        $tubesRemCutArr = array();
        while($tubes = mysqli_fetch_array($result)){
            $tubesRemCutArr[] = $tubes;
        }

        $tubesRemCut = strVal($data['quantity'] - sizeOf($tubesRemCutArr));

        //finding tubes remaining insp
        $sql1 = "SELECT * FROM tubes_tbl WHERE job = '$job' AND mill_check = 1 AND cutoff_check = 1 AND insp_check = 1";

        //make query & get result
        if ($result1= $conn -> query($sql1)) {
            
        }

        $tubesInspArr = array();
        while($tubes = mysqli_fetch_array($result1)){
            $tubesInspArr[] = $tubes;
        }

        $tubesRemInsp = strVal($data['quantity'] - sizeOf($tubesInspArr));

        $tubesRemCutArr = array('tubesCut' => $tubesRemCut);
        $tubesRemInspArr = array('tubesInsp' => $tubesRemInsp);
        $endJson = array_merge($endJson, $tubesRemCutArr);
        $endJson = array_merge($endJson, $tubesRemInspArr);


        //checking if mill has completed tubes
        $sql2 = "SELECT * FROM tubes_tbl WHERE job = '$job' AND mill_check = 1";

        //make query & get result
        if ($result2= $conn -> query($sql2)) {
            
        }

        $tubesDoneMill = array();
        while($tubes = mysqli_fetch_array($result2)){
            $tubesDoneMill[] = $tubes;
        }

        $tubesDMill = array('tubesMill' => strVal($data['quantity'] - sizeOf($tubesDoneMill)));
        $endJson = array_merge($endJson, $tubesDMill);

        //checking if job has fininshed
        $hasJobFin = array();
        $sql3 = "SELECT * FROM orders_tbl WHERE job = '$job' AND has_finished = 1";
        if ($result3= $conn -> query($sql3)) {
            
        }

        $jobFinished = mysqli_fetch_array($result3);

        if(!empty($jobFinished)){
            $hasJobFin = array('jobFinished' => "1");
        }else{
            $hasJobFin = array('jobFinished' => "0");
        }

        $endJson = array_merge($endJson, $hasJobFin);


        // getting tubes remaining for geo form weld
        $sql = "SELECT * FROM tubes_tbl WHERE job = '$job' AND geo_ring_weld = 1";

        if ($result= $conn -> query($sql)) {
            
        }

        $tubesRemWeld = array();
        while($tubes = mysqli_fetch_array($result)){
            $tubesRemWeld[] = $tubes;
        }

        $numTubesRemWeld = array('tubesToWeld' => strVal($data['quantity'] - count($tubesRemWeld)));
        $endJson = array_merge($endJson, $numTubesRemWeld);


        // getting tubes remaining for geo form weld
        $sql = "SELECT * FROM tubes_tbl WHERE job = '$job' AND final_insp = 1";

        if ($result= $conn -> query($sql)) {
            
        }

        $tubesRemFinInsp = array();
        while($tubes = mysqli_fetch_array($result)){
            $tubesRemFinInsp[] = $tubes;
        }

        $numtubesRemFinInsp = array('tubesToFinInsp' => strVal($data['quantity'] - count($tubesRemFinInsp)));
        $endJson = array_merge($endJson, $numtubesRemFinInsp);

        //getting final Length for geoForm
        $sql = "SELECT * FROM orders_tbl WHERE job = $job";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        $job_part = mysqli_fetch_array($result);

        $sql = "SELECT * FROM part_tbl WHERE part = '".$job_part['part']."'";
        if ($result= $conn -> query($sql)) {
            
        }

        $part = mysqli_fetch_array($result);

        $finalLenGeo = array('final_len_geo' => strVal($part['final_length_geo']));
        $endJson = array_merge($endJson, $finalLenGeo);

        //find tubes left for tack weld
        $sql4 = "SELECT * FROM tubes_tbl WHERE job = '$job' AND tack_weld = 1";
        if ($result4= $conn -> query($sql4)) {
            
        }

        $tackTubes = array();
        while($tubes = mysqli_fetch_array($result4)){
            $tackTubes[] = $tubes;
        }

        $tackTubesRem = array('tubesTac' => strVal($data['quantity'] - count($tackTubes)));
        $endJson = array_merge($endJson, $tackTubesRem);

        return JSON_encode($endJson);
    }
?>