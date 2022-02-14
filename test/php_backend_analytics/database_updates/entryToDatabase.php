<?php
    include '../Connections/connection.php';
    include '../Connections/connectionAllOrders.php';
?>

<?php    
    if(isset($_GET['job'])){
        date_default_timezone_set("America/Chicago");
        $millNum = mysqli_real_escape_string($conn, $_GET['mill_number']);
        $job = mysqli_real_escape_string($conn,$_GET['job']);
        $company = mysqli_real_escape_string($conn, $_GET['company']);
        $quantity = mysqli_real_escape_string($conn, $_GET['quantity']);
        $shipDate = mysqli_real_escape_string($conn, $_GET['ship_date']);
        $lastUpd = date("m-d") . ' ' . date("H:i:s");

        $sql = "SELECT ID FROM outgoing_orders WHERE Job_Number = '$job'AND Company = '$company'AND Quantity = '$quantity'AND Ship_Date = '$shipDate'";
        
        //make query and get result
        if ($result= $connOUT -> query($sql)) {

            $value = mysqli_fetch_array($result);
            $id = $value[0];
	
        }else{
            echo "Query Error:" . mysqli_error($connOUT);
        }

        //add to active orders table
        $sql = "INSERT INTO active_orders(ID, Mill_Number, Job_Number, Company, Quantity, Ship_Date, Latest_Upd, Shop_Status) VALUES('$id', '$millNum', '$job', '$company', '$quantity', '$shipDate', '$lastUpd', 'pending')";

        //save to db
        if($conn -> query($sql)){

        }else{
            echo "Query Error:" . mysqli_error($conn);
        }

        //add to tube stations table
        $sql = "INSERT INTO tube_stations(ID, Job_Number, Mill_Number, Time_Weld, Time_Insp) VALUES('$id', '$job', '$millNum', '$lastUpd', '$lastUpd')";
        
        //save to db
        if($conn -> query($sql)){

        }else{
            echo "Query Error:" . mysqli_error($conn);
        }

    }
?>