<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE has_finished = 1 ORDER BY ship_date DESC';

    //make query & get result
    $result = $conn -> query($sql);	

    $ordersACT = [];
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $ordersACT[] = $order;
    }    

    function getCoilsWithJobID($conn, $jobID){

        if(empty($jobID)) return null;

        $order = [];
        //grabbing allocated coils
        $sql100 = 'SELECT * FROM coil_tbl WHERE job = "'.$jobID.'"';

        //make query & get result
        $result100= $conn -> query($sql100);

        $allocatedCoils = [];
        while($order = mysqli_fetch_array($result100)){
            $allocatedCoils[] = $order;
        }       
        
        return ['coils' => $allocatedCoils ];
    } 
    
    function getTubeCnt($conn, $jobID, $coilID){
        $sql    = "SELECT COUNT(*) AS CNT FROM tubes_tbl WHERE  job = '".$jobID."' AND coil = '".$coilID."' AND coil_change = 1 GROUP BY job, coil";        
        $result = $conn -> query($sql);
        $tube   = mysqli_fetch_array($result);

        return !empty($tube['CNT']) ? $tube['CNT'] : 0;
    }

    function getTubeMinMax($conn, $jobID, $coilID){
        $sqlMax    = "SELECT id FROM tubes_tbl WHERE  job = '".$jobID."' AND coil = '".$coilID."' AND coil_change = 1 ORDER BY id DESC LIMIT 1";
        $result = $conn -> query($sqlMax);
        $tubeMaxID   = mysqli_fetch_array($result);
        
        $sqlMin    = "SELECT id FROM tubes_tbl WHERE  job = '".$jobID."' AND coil = '".$coilID."' AND coil_change = 1 ORDER BY id ASC LIMIT 1";
        $result = $conn -> query($sqlMin);
        $tubeMinID   = mysqli_fetch_array($result);

        return ['min' => !empty($tubeMinID) ? $tubeMinID['id'] : 0, 
                'max' => !empty($tubeMaxID) ? $tubeMaxID['id'] : 0];
    }

    function getHeatNumber($conn, $coilWork){
        $sql = 'SELECT heat FROM steel_tbl WHERE work = "'.$coilWork.'" LIMIT 1';
        $result = $conn->query($sql);
        $heatNumber   = mysqli_fetch_array($result);

        return !empty($heatNumber['heat']) ? $heatNumber['heat'] : "";
    }
	
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="description" content="Table display for out going TPM orders for the next two weeks">
        <meta name="viewport" content="width=device-width, initial-scale = 1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <script src = "https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script>
        <script src = "https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

        <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400|Slabo+27px" rel="stylesheet">
        <link rel = "stylesheet" href = "activeOrders.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Job Coils</title>
    </head>
  <body>
  <div class="straightNav center">
        <div class="menu">
            <a href="upcomingOrders.php" >Upcoming Orders</a>
            <a href="todTomOrders.php" >Shipping Today and Tomorrow</a>
            <a href="millTable.php">Mills</a>
            <a href="index.php">All Orders</a>
            <a href="partialShip_search.php">Shipments</a>
        </div>
    </div>
    <div class="tableContainer">
        <div class ="title">
            <h2 id="OOTitle"><b>Job Coil Report</b></h2>
        </div>

        <div class ="title">
                <h3 id="OOTitle"><b>Used Coils</b></h2>
        </div>
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Job ID</td>
                        <td style ="vertical-align: middle;">Coil</td>
                        <td style ="vertical-align: middle;">First & Last Tube Number</td>
                        <td style ="vertical-align: middle;">Total number of tube</td>
                        <td style ="vertical-align: middle;" >Heat Number</td>
                    </tr>
                </thead>
                <tbody>                        
                    <?php foreach($ordersACT as  $job):?>                        
                        <?php 
                            $coils =  getCoilsWithJobID($conn, $job['job']);                              
                        ?>
                        <?php 
                            foreach($coils['coils'] as $key => $coil){
                                $tubeNumbers = getTubeMinMax($conn, $job['job'], $coil['coil_no']);
                                $tubeNumber  = getTubeCnt($conn, $job['job'], $coil['coil_no']);
                                $heatNumber  = getHeatNumber($conn, $coil['work']);
                        ?>
                        <tr>
                            <?php if(empty($key)):?>
                                <td style ="vertical-align: middle;"><?= $job['job'] ?></td>   
                            <?php else:?>
                                <td style ="vertical-align: middle;">"</td>   
                            <?php endif;?>
                            <td style ="vertical-align: middle;"><?= $coil["coil_no"] ?></td>                            
                            <td style ="vertical-align: middle;"><?= $tubeNumbers['min']?> ~ <?= $tubeNumbers['max'] ?></td>
                            <td style ="vertical-align: middle;"><?= $tubeNumber?></td>   
                            <td style ="vertical-align: middle;"><?= $heatNumber ?></td>                            
                        </tr>
                        <?php }?>
                    <?php endforeach;?>
                </tbody>
            </table>
        </div>        
    </div> 
  </body>
</html>