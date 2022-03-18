

<!-- updates the timestamp of when the last tube was welded or inspected-->
<?php
    include '../Connections/connection.php';
?>

<?php
    //take time stamp
    date_default_timezone_set("America/Chicago");
    $lastUpd = date("m-d") . ' ' . date("H:i:s");
    $id = $_GET['id'];

    // update active orders table
    $sql = "UPDATE active_orders SET Latest_Upd = '$lastUpd'  WHERE ID = '$id'";
    if ($result= $conn -> query($sql)) {

    }else{
        echo "Query Error:" . mysqli_error($conn);
    }

    //if its welding update welding
    if(isset($_GET['weld_today'])){
        $weldTod = $_GET['weld_today'];
        $sqlSel = "SELECT Welding_Total FROM tube_stations WHERE ID = '$id'";
        if ($result= $conn -> query($sqlSel)) {

            $value = mysqli_fetch_array($result);
            $weldTotal = $value[0];
	
        }else{
            echo "Query Error:" . mysqli_error($conn);
        }

        $weldTotal = $weldTotal + $weldTod;

        $sql = "UPDATE tube_stations SET Time_Weld = '$lastUpd', Welding_Tod = '$weldTod', Welding_Total = '$weldTotal' WHERE ID = '$id'";
        if ($result= $conn -> query($sql)) {

        }else{
            echo "Query Error:" . mysqli_error($conn);
        }
        
    }

    //if its inspection update inspection
    if(isset($_GET['insp_today'])){
        $inspTod = $_GET['insp_today'];
        $sqlSel = "SELECT Inspection_Total FROM tube_stations WHERE ID = '$id'";
        if ($result= $conn -> query($sqlSel)) {

            $value = mysqli_fetch_array($result);
            $inspTotal = $value[0];
	
        }else{
            echo "Query Error:" . mysqli_error($conn);
        }

        $inspTotal = $inspTotal + $inspTod;

        $sql = "UPDATE tube_stations SET Time_Insp = '$lastUpd', Inspection_Tod = '$inspTod', Inspection_Total = '$inspTotal' WHERE ID = '$id'";
        if ($result= $conn -> query($sql)) {

        }else{
            echo "Query Error:" . mysqli_error($conn);
        }
    }
?>