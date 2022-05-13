<?php
    $header_tilte = "PDF Generation";
    include '../Connections/connectionTPM.php';
    include 'header.php';    
?>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<?php    

    if(isset($_GET['pdf'])){        

        $job = $_GET['job'];

        $sql = "UPDATE orders_tbl SET gen_pdf = 1 WHERE job = '".$_GET['job']."'";
        
        if ($result= $conn -> query($sql)) {
                
        }

        // echo '<script> alert("The pdf for job '.$job.' will be emailed to you shortly!")</script>';
        echo '<script> toastr.success("The pdf for job '.$job.' will be emailed to you shortly!") </script>';
        shell_exec('/opt/bitnami/php/bin/php -q /opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/genPaperwork.php > /dev/null 2>/dev/null &');       
    }
?>

<?php
    $order = array();
    if(isset($_GET['Search']) || isset($_GET['pdf'])){        

        if($_GET['job']!= ""){
            $sql100 = 'SELECT * FROM orders_tbl WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result100= $conn -> query($sql100)) {
            
            }
            $order = mysqli_fetch_array($result100);
        }        
    }
    //
    $orderRecords = [];
    $sql = 'SELECT * FROM orders_tbl WHERE 1 order by `job` DESC';
    if ($rslt = $conn -> query($sql)) {
        while ($row = $rslt -> fetch_assoc()) {            
            array_push($orderRecords, $row);
        }
        $rslt -> free_result();
    }   

?>

<div class="container-fluid px-4 pb-4">
    <div class="card my-4">
        <div class="card-header">
            <h3 class="text-center py-0"><b> Generate Forms</b></h3>
        </div>
        <div class="card-body">
            <form action="testPDFGen.php" method="GET" class="text-center mx-auto col-3 mt-0 pt-0">
                <label for="job" style="font-size:45px;">Job # <?= !empty($_GET['job']) ? $_GET['job'] : '';?></label>                
                <!-- <input type="text" class="form-control center" name="job" placeholder="1234" required> -->
                <select class="job-search form-control center py-1" name="job">
                    <?php foreach($orderRecords as $key => $row): ?>
                        <option value="<?= $row['job']?>" <?php if(!empty($_GET['job']) && ( $_GET['job'] == $row['job'] ) ) echo 'selected'; ?> >
                            <?= $row['job']?>
                        </option>
                    <?php endforeach;?>
                </select>
                <input type="submit" class="btn btn-info btn-primary mt-4" name="Search" value="Search">
            </form>
            
            <div class="outTable">
                <table id="outgoingOrders" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td style ="vertical-align: middle;" >Mill</td>
                            <td style ="vertical-align: middle;">Job Number</td>
                            <td style ="vertical-align: middle;">Company Name</td>
                            <td style ="vertical-align: middle;">Quantity</td>
                            <td style ="vertical-align: middle;">Ship Date</td>
                            <td style ="vertical-align: middle;">Status</td>
                            <?php if(!empty($_GET['pdf']) && !empty($_GET['job'])):?>
                                <td style ="vertical-align: middle;">
                                    Form Preview
                                </td>
                            <?php endif;?>
                        </tr>
                    </thead>
                    <tbody>
                            <?php if(!empty($order)): ?>
                                <tr>
                                    <td style ="vertical-align: middle;"><?php echo ($order['device']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['job']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars(getCustomer($order['cust_id'])); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['quantity']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($order['ship_date']); ?></td>
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
                                    <?php if(!empty($_GET['pdf']) && !empty($_GET['job'])):?>
                                        <td style ="vertical-align: middle;">
                                            <a class="btn btn-success" href="http://198.71.55.128/page/paperwork/<?= $_GET['job']?>_forms.pdf" target="_blank"><i class="fa fa-file-pdf-o"></i> Preview PDF</a>
                                        </td>   
                                    <?php endif;?>
                                </tr>
                            <?php endif;?>
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
                    </tbody>
                </table>
            </div>
            <div class="<?= !empty($_GET['Search']) ? '' : 'd-none'; ?>">
                <form action="testPDFGen.php" method="GET" class="center">
                    <input type="hidden" name="job" value="<?php echo !empty($order['job']) ? $order['job'] : '' ?>">
                    <input type="hidden" name="pdf" value="Generate PDF">
                    <button type="submit" class="btn btn-danger"><i class="fa fa-file-pdf-o" aria-hidden="true"></i> Generate PDF</button>
                </form>
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
    
    $('.job-search').select2();
  });
</script>  
<style>
    tbody {
        font-size: 12pt;
    }
    .dataTables_length label, .dataTables_filter label{
        font-size: 12pt;
    }


    .select2-container .select2-selection--single{
        font-size: 1.5em;
        height: 41px; 
        overflow: auto;
    }
    .select2-container--default .select2-selection--single .select2-selection__rendered{
        line-height: 39px;
    }    
</style>

  </body>
</html>