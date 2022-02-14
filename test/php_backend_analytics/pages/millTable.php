
<!-- Displays the active and pending jobs for each mill-->

<?php
    include '../Connections/connectionTPM.php';
?>

<?php

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_01" AND has_finished = 0';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	}
	

    $millOne = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $millOne[] = $order;
    }

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_02"  AND has_finished = 0';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $millTwo = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $millTwo[] = $order;
    }

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_03"  AND has_finished = 0';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $millThree = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $millThree[] = $order;
    }

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_04"  AND has_finished = 0';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $millFour = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $millFour[] = $order;
    }

    //write query for all orders
    $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_05"  AND has_finished = 0';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
	}
	

    $millFive = array();
    //fetch resulting rows as an array
    while($order = mysqli_fetch_array($result)){
        $millFive[] = $order;
    }

    //get scrap rate for each mill
    // mill 1
    $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$millOne[0]['job'].'"';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }

    $millOneScrap = array();
    while($order = mysqli_fetch_array($result)){
        $millOneScrap[] = $order;
    }

    $millOneScrRate = round((count($millOneScrap) / floatval($millOne[0]['quantity'])) * 100, 1);



    // mill 2
    $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$millTwo[0]['job'].'"';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }

    $millTwoScrap = array();
    while($order = mysqli_fetch_array($result)){
        $millTwoScrap[] = $order;
    }


    $millTwoScrRate = round((count($millTwoScrap) / floatval($millTwo[0]['quantity'])) * 100, 1);




    // mill 3
    $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$millThree[0]['job'].'"';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }

    $millThreeScrap = array();
    while($order = mysqli_fetch_array($result)){
        $millThreeScrap[] = $order;
    }

    $millThreeScrRate = round((count($millThreeScrap) / floatval($millThree[0]['quantity'])) * 100, 1);



    // mill 4
    $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$millFour[0]['job'].'"';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }

    $millFourScrap = array();
    while($order = mysqli_fetch_array($result)){
        $millFourScrap[] = $order;
    }

    $millFourScrRate = round((count($millFourScrap) / floatval($millFour[0]['quantity'])) * 100, 1);




    // mill 5
    $sql = 'SELECT * FROM scrap_tbl WHERE job = "'.$millFive[0]['job'].'"';

    //make query & get result
    if ($result= $conn -> query($sql)) {
	
    }

    $millFiveScrap = array();
    while($order = mysqli_fetch_array($result)){
        $millFiveScrap[] = $order;
    }

    $millFiveScrRate = round((count($millFiveScrap) / floatval($millFive[0]['quantity'])) * 100, 1);
    

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

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <link rel = "stylesheet" href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" />
        <link rel = "stylesheet" href = "millStylesheet.css">
        <link rel = "stylesheet" href = "hamburger.css">
        <link rel = "stylesheet" href = "https://cdn.datatables.net/1.10.12/css/dataTables.bootstrap.min.css" />
        <link href = "https://fonts.googleapis.com/css?family=Merriweather|Playfair+Display|Raleway:400,700|Vollkorn:700&display=swap" rel="stylesheet">

        <title>Mill Jobs</title>
    </head>
  <body>
       <!-- nav bar -->
   <div class="navBar">
        <div class="nav-toggle">
            <div class="nav-toggle-bar"></div>
        </div>

        <nav id="nav" class="nav">
            <ul>
                <li><h3><a href="upcomingOrders.php" id="two">Upcoming Orders</a></h3></li>
                <li><h3><a href="../../TPM_Orders/todTomOrders.php" id="two" >Shipping Today &nbsp</a></h3></li>
                <!-- <li><h3><a href="../../TPM_Orders/viewOrders.php" id="two">All Orders &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li> -->
                <li><h3><a href="index.php" id="two">All Orders &nbsp &nbsp &nbsp &nbsp &nbsp</a></h3></li>
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
         //write query for all orders
        $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_01"  AND has_finished = 0';

        //make query & get result
        if ($result= $conn -> query($sql)) {
        }
        

        $millUno = array();
        $millUno = mysqli_fetch_assoc($result);
        
    ?>

    <div class="center">
        <div class= "allTablesOTT">
            <div class="tableContainerOTT">
                <div class ="millTitle">
                        <h2><b><?php echo (!empty($millUno) ?"<a id='millLink' href='displayProg.php?company=".getCustomer($millUno['cust_id'])."&quantity=".$millUno['quantity']."&job=".$millUno['job']."'>" . 'Mill 1' . "</a> ": "Mill 1"); ?></b></h2>
                </div>
                <div class="millTable">
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
                            <?php foreach($millOne as $order): 
                                // getting od from part_tbl
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                                $odUno = array();
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
                                            if ($result= $conn -> query($sql)) {
                                                $odUno = mysqli_fetch_assoc($result);
                                            }

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
                                        <td><?php echo htmlspecialchars(strval($millOneScrRate).'%'); ?></td>
                                    </tr> 
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <?php
                //write query for all orders
                $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_02"  AND has_finished = 0';

                //make query & get result
                if ($result= $conn -> query($sql)) {
                }
                

                $millDos = array();
                $millDos = mysqli_fetch_assoc($result);
                
            ?>

            <div class="tableContainerOTT">
            <div class ="millTitle">
                        <h2><b><?php echo (!empty($millDos) ?"<a id='millLink' href='displayProg.php?company=".getCustomer($millDos['cust_id'])."&quantity=".$millDos['quantity']."&job=".$millDos['job']."'>" . 'Mill 2' . "</a> " : "Mill 2"); ?></b></h2>
                </div>
                <div class="millTable">
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
                            <?php foreach($millTwo as $order):
                                // getting od from part_tbl
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                                $odDos = array();
                                $dim = 0;
                                //make query & get result
                                if ($result= $conn -> query($sql)) {

                                    $odDos = mysqli_fetch_assoc($result);
                                    
                                    if(mysqli_num_rows($result) == 0){
                                        $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';
                                        $part_row = array();
                                        if ($result= $conn -> query($sql)) {
                                            $part_row = mysqli_fetch_assoc($result);
                                            $sql = 'SELECT * FROM gage_tbl WHERE gage = "'.$part_row['gage'].'"';
                                            if ($result= $conn -> query($sql)) {
                                                $odDos = mysqli_fetch_assoc($result);
                                            }

                                            $dim = $part_row['dim'] + 2*($odDos['thickness']);
                                        }
                                    }else{
                                        $dim = $odDos['dim'];
                                    }

                                }?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($order['job']); ?></td>
                                        <td><?php echo htmlspecialchars($dim); ?></td>
                                        <td><?php echo htmlspecialchars(getOp($order['job'])); ?></td>
                                        <td><?php echo htmlspecialchars(strval($millTwoScrRate).'%'); ?></td>
                                    </tr> 
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <?php
                //write query for all orders
                $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_03"  AND has_finished = 0';

                //make query & get result
                if ($result= $conn -> query($sql)) {
                }
                

                $millTrec = array();
                $millTrec = mysqli_fetch_assoc($result);

                
      
            ?>

            <div class="tableContainerOTT" id= "millTT" >
            <div class ="millTitle" >
                        <h2><b><?php echo (!empty($millTrec) ?"<a id='millLink' href='displayProg.php?company=".getCustomer($millTrec['cust_id'])."&quantity=".$millTrec['quantity']."&job=".$millTrec['job']."'>" . 'Mill 3' . "</a> " : "Mill 3"); ?></b></h2>
                </div>
                <div class="millTable">
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
                            <?php foreach($millThree as $order): 
                                // getting od from part_tbl
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                                $odTrec = array();
                                $dim = 0;
                                //make query & get result
                                if ($result= $conn -> query($sql)) {

                                    $odTrec = mysqli_fetch_assoc($result);
                                    
                                    if(mysqli_num_rows($result) == 0){
                                        $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';
                                        $part_row = array();
                                        if ($result= $conn -> query($sql)) {
                                            $part_row = mysqli_fetch_assoc($result);
                                            $sql = 'SELECT * FROM gage_tbl WHERE gage = "'.$part_row['gage'].'"';
                                            if ($result= $conn -> query($sql)) {
                                                $odTrec = mysqli_fetch_assoc($result);
                                            }

                                            $dim = $part_row['dim'] + 2*($odTrec['thickness']);
                                        }
                                    }else{
                                        $dim = $odTrec['dim'];
                                    }

                                }?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($order['job']); ?></td>
                                        <td><?php echo htmlspecialchars($dim); ?></td>
                                        <td><?php echo htmlspecialchars(getOp($order['job'])); ?></td>
                                        <td><?php echo htmlspecialchars(strval($millThreeScrRate).'%'); ?></td>
                                    </tr> 
                                    
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <?php
         //write query for all orders
        $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_04"  AND has_finished = 0';

        //make query & get result
        if ($result= $conn -> query($sql)) {
        }
        

        $millQuad = array();
        $millQuad = mysqli_fetch_assoc($result);
  
    ?>

    <div class="allTablesFF">
        <div class="tableContainerFF">
        <div class ="millTitle">
                    <h2><b><?php echo (!empty($millQuad) ? "<a id='millLink' href='displayProg.php?company=".getCustomer($millQuad['cust_id'])."&quantity=".$millQuad['quantity']."&job=".$millQuad['job']."'>" . 'Mill 4' . "</a> " : "Mill 4"); ?></b></h2>
            </div>
            <div class="millTable">
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
                        <?php foreach($millFour as $order):
                            // getting od from part_tbl
                            $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                            $odQuad = array();
                            $dim = 0;
                            //make query & get result
                            if ($result= $conn -> query($sql)) {

                                $odQuad = mysqli_fetch_assoc($result);
                                
                                if(mysqli_num_rows($result) == 0){
                                    $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';
                                    $part_row = array();
                                    if ($result= $conn -> query($sql)) {
                                        $part_row = mysqli_fetch_assoc($result);
                                        $sql = 'SELECT * FROM gage_tbl WHERE gage = "'.$part_row['gage'].'"';
                                        if ($result= $conn -> query($sql)) {
                                            $odQuad = mysqli_fetch_assoc($result);
                                        }

                                        $dim = $part_row['dim'] + 2*($odQuad['thickness']);
                                    }
                                }else{
                                    $dim = $odQuad['dim'];
                                }

                            }?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($order['job']); ?></td>
                                        <td><?php echo htmlspecialchars($dim); ?></td>
                                        <td><?php echo htmlspecialchars(getOp($order['job'])); ?></td>
                                        <td><?php echo htmlspecialchars(strval($millFourScrRate).'%'); ?></td>
                                    </tr> 
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>

        <?php
            //write query for all orders
            $sql = 'SELECT * FROM orders_tbl WHERE device = "mill_05"  AND has_finished = 0';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            }
            

            $millCin = array();
            $millCin = mysqli_fetch_assoc($result);

        
        ?>

        <div class="tableContainerFF">
        <div class ="millTitle">
                    <h2><b><?php echo (!empty($millCin) ? "<a id='millLink' href='displayProg.php?company=".getCustomer($millCin['cust_id'])."&quantity=".$millCin['quantity']."&job=".$millCin['job']."'>" . 'Mill 5' . "</a> " : "Mill 5"); ?></b></h2>
            </div>
            <div class="millTable">
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
                        <?php foreach($millFive as $order): 
                            // getting od from part_tbl
                                $sql = "SELECT * FROM part_tbl WHERE part = '".$order['part']."' AND is_od = 1";
                                $odCin = array();
                                $dim = 0;
                                //make query & get result
                                if ($result= $conn -> query($sql)) {

                                    $odCin = mysqli_fetch_assoc($result);
                                    
                                    if(mysqli_num_rows($result) == 0){
                                        $sql = 'SELECT * FROM part_tbl WHERE part = "'.$order['part'].'"';
                                        $part_row = array();
                                        if ($result= $conn -> query($sql)) {
                                            $part_row = mysqli_fetch_assoc($result);
                                            $sql = 'SELECT * FROM gage_tbl WHERE gage = "'.$part_row['gage'].'"';
                                            if ($result= $conn -> query($sql)) {
                                                $odCin = mysqli_fetch_assoc($result);
                                            }

                                            $dim = $part_row['dim'] + 2*($odCin['thickness']);
                                        }
                                    }else{
                                        $dim = $odCin['dim'];
                                    }

                                }
                                

                                
                                ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($order['job']); ?></td>
                                        <td><?php echo htmlspecialchars($dim); ?></td>
                                        <td><?php echo htmlspecialchars(getOp($order['job'])); ?></td>
                                        <td><?php echo htmlspecialchars(strval($millFiveScrRate).'%'); ?></td>
                                    </tr> 
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
  </body>
</html>

<?php
    // takes in an employee id and returns their last name
    function getEmployee($id){

        include '../Connections/connectionTPM.php';

        $sql = "SELECT * FROM employee WHERE ID = '$id'";

        if ($result= $conn -> query($sql)) {

        }

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

        return getEmployee($lastTube['mill_operator']);
    }
?>