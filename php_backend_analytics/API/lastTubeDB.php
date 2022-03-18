<?php
    
    //Get all tubes from tube tbl to display last tube
    $millLT = 0;
    $sql4 = "SELECT * FROM tubes_tbl WHERE job = $job";

    if ($result4= $conn -> query($sql4)) {

    }
    $millTubes = array();
    while($order = mysqli_fetch_array($result4)){
        $millTubes[] = $order;
    }
    if(!empty($millTubes)){
        $millLT = $millTubes[sizeof($millTubes)-1]['id'];
    }else{
        $millLT = $job."-000";
    }
    



    //Get last cutoff tube
    $cutLT=0;
    $sql4 = "SELECT * FROM tubes_tbl WHERE job = $job AND cutoff_time > '0000-00-00 0000:00:00'";

    if ($result4= $conn -> query($sql4)) {

    }
    $COTubes = array();
    while($order = mysqli_fetch_array($result4)){
        $COTubes[] = $order;
    }

    if(!empty($COTubes)){
        $cutLT = $COTubes[sizeof($COTubes)-1]['id'];
    }else{
        $cutLT = $job."-000";
    }

    //get last inspected tube
    $inspLT=0;
    $sql4 = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_time > '0000-00-00 0000:00:00'";

    if ($result4= $conn -> query($sql4)) {

    }
    $inspTubes = array();
    while($order = mysqli_fetch_array($result4)){
        $inspTubes[] = $order;
    }


    if(!empty($inspTubes)){
        $inspLT = $inspTubes[sizeof($inspTubes)-1]['id'];
    }else{
        $inspLT = $job."-000";
    }



    //get last ring checksheet tube
    $ringEndLT=0;
    $sql4 = "SELECT * FROM tubes_tbl WHERE job = $job AND ring_end_time > '0000-00-00 0000:00:00'";

    if ($result4= $conn -> query($sql4)) {

    }
    $ringEndTubes = array();
    while($order = mysqli_fetch_array($result4)){
        $ringEndTubes[] = $order;
    }

    if(!empty($ringEndTubes)){
        $ringEndLT = $ringEndTubes[sizeof($ringEndTubes)-1]['id'];
    }else{
        $ringEndLT = $job."-000";
    }


    //get last ring inspected
    $inspLR=0;
    $sql4 = "SELECT * FROM ring_tbl WHERE job = $job";

    if ($result4= $conn -> query($sql4)) {

    }
    $ringInsp = array();
    while($order = mysqli_fetch_array($result4)){
        $ringInsp[] = $order;
    }

    if(!empty($ringInsp)){
        $inspLR = $ringInsp[sizeof($ringInsp)-1]['ring_id'];
    }else{
        $inspLR = $job."-000";
    }

?>