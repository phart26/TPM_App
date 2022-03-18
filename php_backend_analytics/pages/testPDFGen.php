
<?php
    use Dompdf\Dompdf;
    include '../Connections/connectionTPM.php';
    

    if(isset($_GET['pdf'])){
        

        $job = $_GET['job'];
        ob_start();

        
        include 'DBForReports.php';

        require_once 'overviewSheet_pdf.php';
        require_once 'first_part_drift_confirmation_pdf.php';
        require_once 'welding_pdf.php';
        require_once '240518cutoff_station_check_sheet_pdf.php';
        require_once '240518inspection_rpt_pdf.php';

        if($tubes[0]['end1_read1'] != 0){
            require_once '240518ring_station_check_list_pdf.php';
        }

        if(!empty($rings)){
            require_once '240518geo_form_ring_inspection_pdf.php';
        }

        if($tubes[0]['ring_num1'] != ""){
            require_once 'final_inspection_geo_form_pdf.php';
        }

        // require_once 'worksheet_pdf.php';
        require_once 'dompdf/autoload.inc.php';
        $fileName = strval($job)."_forms.pdf";
        

        $html = ob_get_clean();
        

        // instantiate and use the dompdf class
        $dompdf = new Dompdf();
        $dompdf->set_option('isHtml5ParserEnabled', true);
        $dompdf->loadHtml($html);

        // (Optional) Setup the paper size and orientation
        $dompdf->setPaper('A4', 'landscape');

        // Render the HTML as PDF
        $dompdf->render();

        // Output the generated PDF to Browser
        $output = $dompdf->output();

        $f;
$l;
if(headers_sent($f,$l))
{
    echo $f,'<br/>',$l,'<br/>';
    die('now detect line');
}
        $dompdf -> stream($fileName);
    }
?>

<?php
    //include '../Connections/connectionTPM.php';
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

        <title>PDF Generation</title>
    </head>
  <body>
  <div class="straightNav center">
        <div class="menu">
            <a href="upcomingOrders.php" >Upcoming Orders</a>
            <a href="../../TPM_Orders/todTomOrders.php" >Shipping Today and Tomorrow</a>
            <a href="millTable.php">Mills</a>
            <a href="index.php">All Orders</a>
        </div>
    </div>
   <!-- nav bar -->
   <div class="navBar">
        <div class="nav-toggle">
            <div class="nav-toggle-bar"></div>
        </div>

        <nav id="nav" class="nav">
            <ul>
                <li><h3><a href="upcomingOrders.php" id="two">Upcoming Orders</a></h3></li>
                <li><h3><a href="../../TPM_Orders/todTomOrders.php" id="two" >Shipping Today</a></h3></li>
                <li><h3><a href="millTable.php" id="two">Mills &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li>
                <li><h3><a href="index.php" id="two">All Orders &nbsp &nbsp &nbsp</a></h3></li>
            </ul>
        </nav>
    </div>
    <script>
        (function() {

            let hamburger = {
                nav: document.querySelector('#nav'),
                navToggle: document.querySelector('.nav-toggle'),

                initialize() {
                    this.navToggle.addEventListener('click',
                () => { this.toggle(); });
                },

                toggle() {
                    this.navToggle.classList.toggle('expanded');
                    this.nav.classList.toggle('expanded');
                },
            };

            hamburger.initialize();

        }());
    </script>
    
    <div class="tableContainer">
        <div class ="title">
                <h2 id="OOTitle"><b>Generate Forms</b></h2>
        </div>
        <form action="testPDFGen.php" method="GET" class="center">
            <label for="job" style="font-size:45px;">Job #</label>
            <input type="text" class="form-control center" style="font-size:30px; width: 30%; margin-left: 35%;" name="job" placeholder="1234">
            <input type="submit" class="btn btn-primary btn-md " name="Search" value="Search">
        </form>
        
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <!-- <td style ="vertical-align: middle;" >Mill</td> -->
                        <td style ="vertical-align: middle;">Job Number</td>
                        <td style ="vertical-align: middle;">Company Name</td>
                        <td style ="vertical-align: middle;">Quantity</td>
                        <td style ="vertical-align: middle;">Ship Date</td>
                        <td style ="vertical-align: middle;">Status</td>
                    </tr>
                </thead>
                <tbody>
                        <?php if(!empty($order)): ?>
                            <tr>
                                <!-- <td style ="vertical-align: middle;"><?php //echo ($order['device']); ?></td> -->
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
                                    ?></td>     
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
        <div class="pdfBtn">
            <form action="testPDFGen.php" method="GET" class="center">
                <input type="hidden" name="job" value="<?php echo $order['job'] ?>">
                <input type="submit" name="pdf" value="Generate PDF" class="button">
            </form>
        </div>

        <?php
            if(isset($_GET['Search'])){
                echo '<style type="text/css">
                    .pdfBtn{
                    display: block;
                }
                </style>';
            }
         ?>
    </div> 

    
    
  </body>
</html>