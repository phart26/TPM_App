
<!-- Displays the active and pending jobs for each mill-->
<?php
    $header_tilte = "Mill Jobs";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>
<?php
    function getScrap($mill){
        include '../Connections/connectionTPM.php';

        $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$mill[0]['job'].'"';

        //make query & get result
        $result= $conn -> query($sql);

        $millScrap = array();
        while($order = mysqli_fetch_array($result)){
            $millScrap[] = $order;
        }

        $sql = 'SELECT * FROM part_tbl WHERE part = "'.$mill[0]['part'].'"';

        //make query & get result
        $result= $conn -> query($sql);

        if(!empty($result)){
            $millPart = mysqli_fetch_array($result);
    
            $millTotalScrap = 0;
    
            foreach ($millScrap as $tube){
                $millTotalScrap += intval($tube['tube_length']);
            }
    
            if($mill[0]['quantity']*$millPart['cutoff_length']*1 == 0){
                $millScrRate = 0;
            }else{
                $millScrRate = round(($millTotalScrap / (floatval($mill[0]['quantity'])*floatval($millPart['cutoff_length']))) * 100, 1);
            }

            return $millScrRate;
        }else{
            return 0;
        }
    }

    function getResultWithQuery($con, $sql){
        if(empty($con)) return false;
        
        $result = $con->query($sql);
        $data = [];
        while($item = mysqli_fetch_array($result)){
            $data[] = $item;
        }
        return $data;
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

    <?php
        //get the full mills 
        $mills = getResultWithQuery($conn, "SELECT * FROM mac_add_tbl WHERE device LIKE 'mill_%' ORDER BY device ASC");
    ?>

    <div class="container">
        <!-- >> -->
        <?php $finished = 0; ?>
        <div class="col-sm-12 col-xs-12">
            <div class="questions">
                <div class="questions__question">
                    <input type="radio" name="finished" id="finished-0" checked  value="0">
                    <label for="finished-0" data-question-number="✓">Not Finished Order</label>
                </div>                
            </div>
        </div>

        <?php foreach($mills as $key => $mill):?>
        <?php             
            $rows = getResultWithQuery($conn, "SELECT * FROM orders_tbl WHERE device = '".$mill['device']."'  AND has_finished = $finished");            
            $millUno = !empty($rows[0]) ? $rows[0] : [];
        ?>
        <div class="row col-sm-12 col-xs-12 mb-0">
            <div class="col-sm-12 col-xs-12">
                <h2 class="header mb-0 mt-0">
                    <?php echo (!empty($millUno) ?"<a id='millLink' href='displayProg.php?company=".getCustomer($millUno['cust_id'])."&quantity=".$millUno['quantity']."&job=".$millUno['job']."'>" . ucfirst($mill['device']) . "</a>" : ucfirst($mill['device']) ); ?>
                </h2>
            </div>
            <div class="col-sm-12 col-xs-12">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td>Job #</td>
                            <td>OD</td>
                            <td>Operator</td>
                            <td>Scrap</td>
                        </tr>
                    </thead>
                    <tbody>                        
                        <?php foreach($rows as $order): 
                            // getting od from part_tbl
                            $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                            $odUno = [];
                            $dim = 0;
                            //make query & get result
                            if ($result= $conn -> query($sql)) {

                                $odUno = mysqli_fetch_assoc($result);
                                
                                if(mysqli_num_rows($result) == 0){
                                    $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';
                                    $part_row = array();
                                    if ($result= $conn -> query($sql)) {
                                        $part_row = mysqli_fetch_assoc($result);
                                        $sql = 'SELECT * FROM gage_tbl WHERE gage = "'.$part_row['gage'].'"';
                                        $result= $conn -> query($sql);
                                        $odUno = mysqli_fetch_assoc($result);                                        

                                        $dim = $part_row['dim'] + 2*($odUno['thickness']);
                                    }
                                }else{
                                    $dim = $odUno['dim'];
                                }

                            }?>
                                <tr>
                                    <td><?php echo htmlspecialchars($order['job']); ?></td>
                                    <td><?php echo htmlspecialchars($dim); ?></td>
                                    <td><?php echo htmlspecialchars(getOp($order['job'])); ?></td>
                                    <td><?php echo htmlspecialchars(strval(getScrap($rows)).'%'); ?></td>
                                </tr> 
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
        <?php endforeach;?> 
    </div>
    
  </body>
  <script>
      $('input[name="finished"]').on('change', function(e){
            let sort = $("input[name='finished']:checked").val();
            location.href = `?finished=${sort}`;
      });
  </script>    
</html>

<?php
    // takes in an employee id and returns their last name
    function getEmployee($id){

        include '../Connections/connectionTPM.php';

        $sql = "SELECT * FROM employee WHERE ID = '$id'";

        $result= $conn -> query($sql);

        $employee = mysqli_fetch_assoc($result);

        $name = $employee['name'];


        return substr($name, strpos($name, ' ') + 1);

    }
?>

<?php
    //takes in a job number at returns most recent mill op on job
    function getOp($job){
        include '../Connections/connectionTPM.php';
        $sql = "SELECT * FROM tubes_tbl WHERE job = '$job' ORDER BY id DESC";

        //make query & get result
        if ($result= $conn -> query($sql)) {
        
        }
        $lastTube = mysqli_fetch_array($result);

        return !empty($lastTube['mill_operator']) ? getEmployee( $lastTube['mill_operator'] ) : "";
    }
?>