<!-- Displays time stamps for specific started job-->
<?php
    $header_tilte = "Displaying Job Progress";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>

<?php
    if(isset($_POST['unassign'])){

        $job = $_POST['job'];

        $sql = "UPDATE orders_tbl SET device = '' WHERE job = $job";

        if ($result= $conn -> query($sql)) {
            header("Location: index.php");
        }

    }
    $job = $_GET['job'];
    //write query for all orders
    $sql = "SELECT * FROM orders_tbl WHERE job = $job";
    $orderACT = $db->query($sql)->fetchArray();

    $sql = "SELECT * FROM tubes_tbl WHERE job = $job AND insp_check = 1";   
    $tubes = $db->query($sql)->fetchAll();

    //getting updated number of tubes
    $currTub = count($tubes);
    $percent = !empty($orderACT['quantity']) ? round(($currTub/$orderACT['quantity'])*100) : 0;    


    // ###########################################################
    $sql = "SELECT * FROM tubes_tbl WHERE job = $job";

    //make query & get result
    $result= $conn -> query($sql);

    date_default_timezone_set("US/Central");
    $timeStamp = date("Y-m-d H:i:s");
    $total_time = 0;

    if(mysqli_num_rows($result) > 0){

        $tubes = array();

        while($order = mysqli_fetch_array($result)){
            $tubes[] = $order;
        }
            
        //calculating time from mill
        for($tube = 1; $tube < sizeof($tubes); $tube++){

            //checks to see if difference in time between timestamps of two tubes is > 5 hours
            if(round((strtotime($tubes[$tube]['mill_time']) - strtotime($tubes[$tube-1]['mill_time']))/3600) < 5){
                $total_time += (strtotime($tubes[$tube]['mill_time']) - strtotime($tubes[$tube-1]['mill_time']));
            }
        }
    
        //calculate time of tubes where the insp time > than mill time if the mill is finished
        if(sizeof($tubes) == $orderACT['quantity'] && !empty($tubes[-1]) ){            
            $lastMillTime = $tubes[-1]['mill_time'];

            $sql = "SELECT * FROM tubes_tbl WHERE insp_time > '$lastMillTime'";

            if ($result= $conn -> query($sql)) {
            
            }

            if(mysqli_num_rows($result) > 0){

                $tubesInsp = array();

                while($order = mysqli_fetch_array($result)){
                    $tubesInsp[] = $order;
                }            
            
                for($tube = 1; $tube < sizeof($tubesInsp); $tube++){
        
                    //checks to see if difference in time between timestamps of two tubes is > 5 hours
                    if(round((strtotime($tubesInsp[$tube]['insp_time']) - strtotime($tubesInsp[$tube-1]['insp_time']))/3600) < 5){                                
                        $total_time += (strtotime($tubesInsp[$tube]['insp_time']) - strtotime($tubesInsp[$tube-1]['insp_time']));
                    }
                }

            }
        }
    }
        
    $total_time = round($total_time/3600);

    if($total_time < 0){
        $total_time = 0;
    }


?>

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
?>
    <div class="container-fluid px-4 pb-4">
        <div class="card mt-4">
            <div class="card-header">
                <h3 class="text-center py-0"><b> Job <?php echo $job; ?></b></h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <?php if(!empty($orderACT['device'])):?>
                            <form class="p-0 m-auto text-center" action="timeStamp.php" method="POST">
                                <input type="hidden" name="job" value= "<?php echo $job?>">
                                <input type="submit" name="unassign" value="Unassign Mill" class="btn btn-danger mb-4">
                            </form>
                    <?php endif;?>
                </div>

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Mill: <label class="text-info"><?php echo ($orderACT['device'] == '' ? 'Unassigned' : substr($orderACT['device'],6)); ?></label></h4>                                
                            </div>
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Company: <label class="text-info font-weight-bold"><?= getCustomer($orderACT['cust_id']);?></label></h4>                                
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Quantity: <label class="text-info"><?= $orderACT['quantity']?></label></h4>                                
                            </div>
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Tubes Left to Inspect: <label class="text-info"><?= $orderACT['quantity'] - $currTub?></label></h4>                                
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Start Time: <label class="text-info"><?= $orderACT['began']?></label></h4>                                
                            </div>
                            <div class="col-6 text-left px-0">
                                <h4 class="font-weight-bold text-secondary">Run Time: <label class="text-info"><?= $total_time ?> Hrs</label></h4>                                
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">                      
                    <div class="w-50 m-auto progress" style="height: 20px;">
                        <div class="progress-bar progress-bar-striped bg-info" role="progressbar" 
                             style="width: <?= $percent?>%;" aria-valuenow="<?= $percent?>" aria-valuemin="0" aria-valuemax="100" title="<?= $percent?>%"><?= $percent?>%</div>
                    </div>
                </div>

                <!-- >> #################################################### -->
                <div class="row px-4 my-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Setup Start Time:</h4>
                                <label class="text-info"><?=  $orderACT['has_started'] ? $orderACT['began'] : '0000-00-00'; ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Setup End Time:</h4>
                                <label class="text-info"><?=  $orderACT['has_finished'] ? $orderACT['finished'] : '0000-00-00'; ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>
                
                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Mill Start Time:</h4>
                                <label class="text-info"><?=  !empty($tubes[0]['mill_time']) ? $tubes[0]['mill_time'] : '0000-00-00'; ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>

                <div class="row px-4 mb-4">
                    <div class="col-md-3 col-xs-hidden"></div>
                    <div class="col-md-6 col-xs-12">
                        <div class="row">
                            <div class="col-12 text-center px-0">
                                <h4 class="font-weight-bold text-secondary">Mill End Time:</h4>
                                <label class="text-info"><?=  !empty($orderACT['has_finished'] == 1) ? $tubes[-1]['mill_time'] : 'Job in progress' ?></label>
                            </div>                            
                        </div>
                    </div>
                </div>
                <!-- >> ##################################### -->

            </div>
        </div>
    </div>
  </body>
</html>