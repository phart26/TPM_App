<!-- Active TPM query for past orders-->
<?php
    $header_tilte = "Search Query";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>
<?php
//#####################################################
function getResultWithQuery($con, $sql){
    if(empty($con)) return false;
    
    $result = $con->query($sql);
    $data = [];
    while($item = mysqli_fetch_array($result)){
        $data[] = $item;
    }
    return $data;
}
//#####################################################
    $jobNum     = !empty($_POST['jobNum']) ? " job  = '".$_POST['jobNum']."'" : "";
    $partNum    = !empty($_POST['partNum']) ? " AND part = '".$_POST['partNum']."'" : "";
    $startDate  = !empty($_POST['startDate']) ? " AND shipped >= '".$_POST['startDate']."'" : "";
    $endDate    = !empty($_POST['endDate']) ? " AND shipped <= '".$_POST['endDate']."'" : "";

    $ordersACT = [];
    if(!empty($jobNum)){
        $sql = "SELECT * FROM orders_tbl WHERE $jobNum $partNum $startDate $endDate";

        $ordersACT = getResultWithQuery($conn, $sql);
    }
?>
<div class="container-fluid px-4 pb-4">
    <div class="card mt-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b>TPM Order Search Query</b></h3>
        </div>
        <div class="card-body">
            <div class="row">
                <form action="searchQuery.php" method="POST">
                    <!-- Grid row -->
                    <div class="form-row" style="font-size:40px;">
                        <!-- Default input -->
                        <div class="form-group col-md-6" style="padding-left:0">
                            <label for="jobNum" style="font-size:45px;">Job #</label>
                            <input type="text" class="form-control" style="font-size:30px;" name="jobNum" placeholder="1234" value="<?= !empty($_POST['jobNum']) ? $_POST['jobNum'] : ''?>">
                        </div>
                        <!-- Default input -->
                        <div class="form-group col-md-6">
                            <label for="partNum" style="font-size:45px;">Part #</label>
                            <input type="text" class="form-control"  style="font-size:30px;" name="partNum" placeholder="12345678" value="<?= !empty($_POST['partNum']) ? $_POST['partNum'] : ''?>">
                        </div>
                    </div>
                
                    <!-- Grid row -->
                    <div class="form-row">
                        <!-- Default input -->
                        <div class="form-group col-md-6"  style="padding-left:0">
                            <label for="startDate" style="font-size:45px;">From</label>
                            <input type="date" class="form-control" style="font-size:30px;" name="startDate" placeholder="0000-00-00" value="<?= !empty($_POST['startDate']) ? $_POST['startDate'] : ''?>">
                        </div>
                        <!-- Default input -->
                        <div class="form-group col-md-6"  style="padding-left:0">
                            <label for="endDate" style="font-size:45px;">To</label>
                            <input type="date" class="form-control" style="font-size:30px;" name="endDate" placeholder="0000-00-00" value="<?= !empty($_POST['endDate']) ? $_POST['endDate'] : ''?>">
                        </div>
                    </div>
                    <!-- Grid row -->
                    <input type="submit" class="btn btn-primary btn-md " name="Search" value="Search">
                </form>
            </div>

            <div class="row">
                <table id= "outgoingOrders" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td style ="vertical-align: middle;" >Mill</td>
                            <td style ="vertical-align: middle;">Job Number</td>
                            <td style ="vertical-align: middle;">Company Name</td>
                            <td style ="vertical-align: middle;">Quantity</td>
                            <td style ="vertical-align: middle;">Ship Date</td>
                            <td style ="vertical-align: middle;">Status</td>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if(!empty($ordersACT)):?>
                            <?php foreach($ordersACT as $order): ?>
                                <tr>
                                    <td class="firstRow" style ="vertical-align: middle;"><?php echo ($order['device'] != "" ? "<a href='displayProg.php?company=".getCustomer($order['cust_id'])."&quantity=".$order['quantity']."&job=".$order['job']."'>" . htmlspecialchars($order['device']) . "</a> " : ""); ?></td>
                                    <td style ="vertical-align: middle;" class="firstRow"><?php echo ($order['has_started'] == 1 ? "<a href='tubeDates.php?job=".$order['job']."&company=".getCustomer($order['cust_id'])."'>" . htmlspecialchars($order['job']) . "</a> " : htmlspecialchars($order['job'])); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['shipped']); ?></td>
                                    <td style ="vertical-align: middle;">
                                        <?php 
                                        if($order['has_started'] == 0){
                                            echo "Pending";
                                        }else if(($order['has_started'] == 1) && ($order['has_finished'] == 0)){
                                            echo "Active";
                                        }else{
                                            echo "Completed";
                                        }
                                        ?>
                                    </td>     
                                </tr> 
                            <?php endforeach; ?>
                        <?php else:?>
                            <tr><td colspan="6">No Result !</td></tr>
                        <?php endif;?>
                        
                        <?php

                            function getCustomer($cust_id){
                                include '../Connections/connectionTPM.php';
                                $sql = "SELECT customer FROM cust_tbl WHERE cust_id = '".$cust_id."'";

                                //make query & get result
                                $result= $conn -> query($sql);
                                
                                //fetch resulting rows as an array
                                $customer = mysqli_fetch_assoc($result);

                                return $customer['customer'];
                            }
                        ?>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>     
    
  </body>
</html>