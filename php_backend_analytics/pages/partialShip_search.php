<?php
    $header_tilte = "TPM Shipments";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>

<?php
    $shipments = array();
    if(isset($_GET['Search'])){
        

        if($_GET['job']!= ""){
            $sql = 'SELECT * FROM partial_ship WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            while($queryResult = mysqli_fetch_array($result)){
                $shipments[] = $queryResult;
            }
        }

        
    }
    if(isset($_POST['delete'])){
        $job = $_POST['jobNum'];
        $cust = $_POST['cust_id'];
        $quan = $_POST['quantity'];
        $ship_date = $_POST['ship_date'];
        
        $sql = "DELETE FROM partial_ship WHERE job ='$job' AND cust_id = '$cust' AND quantity = '$quan' AND ship_date = '$ship_date'";

        //make query & get result
        if ($result= $conn -> query($sql)) {

        }

        header('Location:http://198.71.55.128/page/partialShip_search.php?job='.$job.'&Search=Search');
        exit();        
    }
	
?>
    <div class="container-fluid px-4 pb-4">
        <div class="card my-4">
            <div class="card-header">
                <h3 class="text-center py-0"><b>Shipments</b></h3>
            </div>
            <div class="card-body">
                <form action="partialShip_search.php" method="GET" class="text-center mx-auto col-3 mt-0 pt-0">
                    <label for="job" style="font-size:45px;">Job # <?= !empty($_GET['job']) ? $_GET['job'] : '';?></label>
                    <input type="text" class="form-control center" name="job" placeholder="1234">
                    <input type="submit" class="btn btn-info btn-primary mt-2" name="Search" value="Search">
                </form>
                
                <div class="outTable">
                    <table id="outgoingOrders" class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <td style ="vertical-align: middle;">Job</td>
                                <td style ="vertical-align: middle;">Company</td>
                                <td style ="vertical-align: middle;">Quantity</td>
                                <td style ="vertical-align: middle;">Ship Date</td>
                                <td style ="vertical-align: middle;"></td>
                            </tr>
                        </thead>
                        <tbody>
                                <?php foreach($shipments as $shipment): ?>
                                    <tr>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['job']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($shipment['cust_id'])); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['quantity']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars($shipment['ship_date']); ?></td> 
                                        <td style ="vertical-align: middle;" id="deleteBtn">
                                        <form action="" method="POST">
                                            <input type="hidden" name="jobNum" value="<?php echo $shipment['job'] ?>">
                                            <input type="hidden" name="cust_id" value="<?php echo $shipment['cust_id'] ?>">
                                            <input type="hidden" name="quantity" value="<?php echo $shipment['quantity'] ?>">
                                            <input type="hidden" name="ship_date" value="<?php echo $shipment['ship_date'] ?>">
                                            <input type="submit" name="delete" value="Delete" class="button">
                                        </form>  
                                    </tr>
                                <?php endforeach;?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div> 
<script type="text/javascript">
  $(function () {    
    $('#outgoingOrders').DataTable( {        
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
<?php
    function getCustomer($cust_id){
        include '../Connections/connectionTPM.php';
        $sqls = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

        //make query & get result
        if ($results= $conn -> query($sqls)) {
        
        }
        
        //fetch resulting rows as an array
        $orderACTS = mysqli_fetch_assoc($results);

        return $orderACTS['customer'];
    }
?>
</html>