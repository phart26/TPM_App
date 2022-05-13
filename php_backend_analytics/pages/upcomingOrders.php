
<!-- Displays all non-active orders-->

<?php
    $header_tilte = "Upcoming Orders";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>

<?php

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE has_started = 0 AND has_finished = 0 ORDER BY Ship_Date';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $ordersACT = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $ordersACT[] = $order;
    }

?>

<!-- updates database after mill selection -->
<?php

    if(isset($_POST['millNum'])){
        $mill_num = $_POST['millSelect'];
        //write query for all orders
        $sql = "UPDATE orders_tbl SET device = '$mill_num', has_finished = 0 WHERE job = '".$_POST['jobNumber']."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            header("Location: upcomingOrders.php");        
        }
    }

    if(isset($_POST['startMillNum'])){
        date_default_timezone_set("US/Central");
        $timeStamp = date("m-d H:i");
        $mill_num = 'mill_0'.$_POST['startMillSelect'];
        //write query for all orders
        $sql = "UPDATE orders_tbl SET device = '$mill_num' WHERE job = '".$_POST['jobNumber']."'";

        //make query & get result
        if ($result= $conn -> query($sql)) {
            
        }

        if($_POST['paused'] == 1){
            $sql = " SELECT * FROM orders_tbl WHERE job = '".$_POST['jobNumber']."'"; 

            //make query & get result
            if ($result= $conn -> query($sql)) {
                $jobRow = mysqli_fetch_assoc($result);
            
                $sql = " UPDATE live_shop_tbl SET mill = '".$jobRow['Mill']."' WHERE job = '".$_POST['jobNumber']."'";

                if ($result= $conn -> query($sql)) {
                        
                }

                $sql = " UPDATE orders_tbl SET paused = 0 WHERE job = '".$_POST['jobNumber']."'";

                if ($result= $conn -> query($sql)) {
                    header("Location: index.php");
                }
            }

        }else{
            $sql = "INSERT INTO live_shop_tbl(job, mill) SELECT job, mill FROM orders_tbl WHERE job = '".$_POST['jobNumber']."'"; 

            //make query & get result
            if ($result= $conn -> query($sql)) {

            }

            $sql = "UPDATE live_shop_tbl SET time_weld = '$timeStamp' , time_insp = '$timeStamp' WHERE job = '".$_POST['jobNumber']."'" ; 

            //make query & get result
            if ($result= $conn -> query($sql)) {
                header("Location: index.php");
            }
        }
    }

    // selecting active mills

    $sql = 'SELECT device, COUNT(*) as CNT FROM orders_tbl WHERE device != ""  AND has_started = 1 GROUP BY device';

    $pendingMills = $db->query($sql)->fetchAll();    
    
?>

<?php
    // find jobs that could potentially be paused
    $sql = "SELECT * FROM orders_tbl WHERE has_started = 1 AND has_finished = 1 AND job > 7820";

    if ($result= $conn -> query($sql)) {
	
	}
	
    $Jobs = array();
    $pausedJobs = array();
    while($order = mysqli_fetch_array($result)){
        $Jobs[] = $order;
    }
    
    // run through each job and check if tubes are finished, if not, add to paused list
    foreach($Jobs as $job){
        $sql = "SELECT * FROM tubes_tbl WHERE job = '".$job['job']."'";
        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $tubes = array();
        while($order = mysqli_fetch_array($result)){
            $tubes[] = $order;
        }
        
        if(sizeof($tubes) < $job['quantity']){
            array_push($pausedJobs, $job);
        }
    }
?>

<script>
    function hideStart(){
        document.getElementById("startMillForm").style.display = "none";
        document.getElementById("upOrders").style.opacity = 1;
    }

    function hideAssign(){
        document.getElementById("millUpForm").style.display = "none";
        document.getElementById("upOrders").style.opacity = 1;
    }
</script>

<div class="container-fluid px-4 pb-4">
    <div class="card my-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b> <?= $header_tilte; ?></b></h3>
        </div>
        <div class="card-body">
            <!-- form set up >> -->
            <form   action="upcomingOrders.php" 
                    method= "POST" 
                    class="row w-25 mx-auto <?= !empty($_POST['assign']) ? '' : 'd-none'; ?>" 
                    id="millUpForm">

                <input type="hidden" name="jobNumber" value="<?php echo !empty($_POST['jobNum']) ? $_POST['jobNum'] : ''; ?>">
                <h4>Mill</h4>
                <select class="form-control row" name="millSelect" title="Mill select">
                    <?php foreach($pendingMills as $key => $mill):?>
                        <option value="<?= $mill['device'] ?>" <?= !empty($_POST['assigned_mill']) && ($_POST['assigned_mill'] == $mill['device']) ? 'selected' : ''; ?>>
                            <?= $mill['device'] ?>
                        </option>
                    <?php endforeach;?>
                </select>
                <div class="row pt-4 mx-auto">
                    <button type="submit" class="btn btn-info mr-2" name="millNum" value="Assign">Assign</button>
                    <a  href="upcomingOrders.php" class="btn btn-info">« Back</a>
                </div>
            </form>

            <form   action="upcomingOrders.php" 
                    method="POST" 
                    class="row form-control" 
                    id="startMillForm">

                <input type="hidden" name="jobNumber" value="<?php echo $_POST['jobNum'] ?>">
                <input type="hidden" name="paused" value="<?php echo $_POST['paused'] ?>">
                <label>Mill</label>
                <select class="form-control" name="startMillSelect" title="Mill select">
                    <?php foreach($pendingMills as $key => $mill):?>
                        <option value="<?= explode('mill_0', $mill['device'])[1]?>"><?= $mill['device'] ?></option>
                    <?php endforeach;?>
                </select>            
                <input type="submit" name="startMillNum" onclick= "return confirm('<?php echo 'Are you sure you would like to start job '.$_POST['jobNum']?>')" value="Start" class="button">
                <button onclick= "hideStart()" class="button">Back</button>
            </form>
            
            <!-- table setup -->
            <div class="<?= !empty($_POST['assign']) ? 'd-none' : ''; ?>">
                <table id="upOrders" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td style ="vertical-align: middle;">Customer</td>
                            <td style ="vertical-align: middle;">Ship Date</td>
                            <td style ="vertical-align: middle;">Part #</td>
                            <td style ="vertical-align: middle;">Job #</td>
                            <td style ="vertical-align: middle;">QTY</td>
                            <td style ="vertical-align: middle;">Description</td>
                            <td style ="vertical-align: middle; width: 100px;">Mill</td>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach($ordersACT as $order): ?>
                                <tr>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                    <td style ="vertical-align: middle;" class= "shipDate"><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['part']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['job']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                    <td id="desc" style ="vertical-align: middle;"><?php echo htmlspecialchars(getDesc($order['part'])); ?></td>
                                    <td >
                                        <?php if($order['device'] != ""): ?>
                                            <small class="font-weight-bold"><?= explode('mill_0', $order['device'])[1] ?></small>
                                        <?php endif; ?>

                                        <div class="row">
                                            <form   class="p-0 m-0 <?= !empty($order['device']) ? 'col-6' : 'col-12'?>" 
                                                    action="upcomingOrders.php" method="POST">
                                                <input  type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                                <input  type="hidden" name="assign" value="Assign">
                                                <input  type="hidden" 
                                                        name="assigned_mill" 
                                                        value="<?= $order['device']?>">

                                                <button class="btn btn-danger" type="submit">
                                                    <?= !empty($order['device']) ? 'Reset' : 'Assign'?>
                                                </button>
                                            </form>
                                            
                                            <?php if(!empty($order['device'])):?>
                                            <form class="p-0 m-0 col-6" action="upcomingOrders.php" method="POST" >
                                                <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                                <input type="hidden" name="paused" value="<?php echo !empty($order['paused']) ? $order['paused'] : ""  ?>">
                                                <input type="hidden "name="start" value="Start" >
                                                <button class="btn btn-info" type="submit">Start</button>
                                            </form>
                                            <?php endif;?>
                                        </div>
                                    </td>
                                </tr> 
                        <?php endforeach; ?>
                        

                        <!-- getting customer and description functions -->

                        <?php
                            function getCustomer($cust_id){
                                include '../Connections/connectionTPM.php';
                                $sql = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

                                //make query & get result
                                if ($result= $conn -> query($sql)) {
                                
                                }
                                
                                //fetch resulting rows as an array
                                $orderACT = mysqli_fetch_assoc($result);

                                return $orderACT['customer'];
                            }

                            function getDesc($part){
                                include '../Connections/connectionTPM.php';
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$part."'";

                                //make query & get result
                                if ($result= $conn -> query($sql)) {
                                
                                }
                                
                                //fetch resulting rows as an array
                                $orderACT = mysqli_fetch_assoc($result);

                                return $orderACT['description'];
                            }
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ################################## >> -->
    <div class="card mt-4 <?= !empty($_POST['assign']) ? 'd-none' : ''; ?>">
        <div class="card-header">
            <h3 class="text-center py-0"><b> Paused Orders</b></h3>
        </div>
        <div class="card-body">
            <table id="pausedOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;">Customer</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;">Part #</td>
                        <td style ="vertical-align: middle;">Job #</td>
                        <td style ="vertical-align: middle;">QTY</td>
                        <td style ="vertical-align: middle;">Description</td>
                        <td style ="vertical-align: middle;">Mill</td>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($pausedJobs as $order): ?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                <td style ="vertical-align: middle;" class= "shipDate"><?php echo htmlspecialchars($order['ship_date']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['part']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['job']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                <td style ="vertical-align: middle;" id="desc1"><?php echo htmlspecialchars(getDesc($order['part'])); ?></td>
                                <td style ="vertical-align: middle;" id = "millBtn1">
                                    <?php if($order['device'] != ""): ?>
                                        <small class="font-weight-bold"><?= explode('mill_0', $order['device'])[1] ?></small>
                                    <?php endif; ?>

                                    <div class="row">
                                        <form   class="p-0 m-0 <?= !empty($order['device']) ? 'col-6' : 'col-12'?>" 
                                                action="upcomingOrders.php" method="POST">
                                            <input  type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                            <input  type="hidden" name="assign" value="Assign">
                                            <input  type="hidden" 
                                                    name="assigned_mill" 
                                                    value="<?= $order['device']?>">

                                            <button class="btn btn-danger" type="submit">
                                                <?= !empty($order['device']) ? 'Reset' : 'Assign'?>
                                            </button>
                                        </form>
                                        
                                        <?php if(!empty($order['device'])):?>
                                        <form class="p-0 m-0 col-6" action="upcomingOrders.php" method="POST" >
                                            <input type="hidden" name="jobNum" value="<?php echo $order['job'] ?>">
                                            <input type="hidden" name="paused" value="<?php echo !empty($order['paused']) ? $order['paused'] : ""  ?>">
                                            <input type="hidden "name="start" value="Start" >
                                            <button class="btn btn-info" type="submit">Start</button>
                                        </form>
                                        <?php endif;?>
                                    </div>
                                    
                                </td>
                            </tr> 
                    <?php endforeach; ?>

                </tbody>
            </table>
        </div>
    </div>
</div>    

<script type="text/javascript">
    $(function () {    
        $('#upOrders').DataTable( {        
            responsive: true,
            // pageLength : 25,
        } );        
        $('#pausedOrders').DataTable( {        
            responsive: true,
            // pageLength : 25,
        } );        
    });
</script>  
<style>
    tbody {
        font-size: 12pt;
    }
    .dataTables_length label, .dataTables_filter label{
        font-size: 12pt;
    }
</style>
    </body>
</html>