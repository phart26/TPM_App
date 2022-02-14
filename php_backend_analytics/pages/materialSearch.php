<?php
    include '../Connections/connectionTPM.php';
?>

<?php
    $order = array();
    if(isset($_GET['Search']) || isset($_GET['pdf'])){
        

        if($_GET['job']!= ""){

            //grabbing allocated coils
            $sql100 = 'SELECT * FROM coil_tbl WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result100= $conn -> query($sql100)) {
            
            }
            $allocatedCoils = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result100)){
                $allocatedCoils[] = $order;
            }




            // grabbing used coils
            $sql = 'SELECT * FROM used_coil WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            $usedCoils = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $usedCoils[] = $order;
            }



            // grabbing allocated mesh
            $sql = 'SELECT * FROM mesh_tbl WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            $allocatedMesh = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $allocatedMesh[] = $order;
            }




            // grabbing used mesh
            $sql = 'SELECT * FROM used_mesh WHERE job = "'.$_GET["job"].'"';

            //make query & get result
            if ($result= $conn -> query($sql)) {
            
            }
            $usedMesh = array();
            //fetch resulting rows as an array
            while($order = mysqli_fetch_array($result)){
                $usedMesh[] = $order;
            }




            //grab heat number for allocated coils from work number
            $allocCoilHeat = array();
            foreach($allocatedCoils as $coil){
                $sql = 'SELECT * FROM steel_tbl WHERE work = "'.$coil['work'].'"';

                //make query & get result
                if ($result= $conn -> query($sql)) {
                
                }
                $heat = mysqli_fetch_array($result);
                array_push($allocCoilHeat, $heat);

            }

            //grab heat number for used coils from work number
            $usedCoilHeat = array();
            foreach($usedCoils as $coil){
                $sql = 'SELECT * FROM steel_tbl WHERE work = "'.$coil['work'].'"';

                //make query & get result
                if ($result= $conn -> query($sql)) {
                
                }
                $heat = mysqli_fetch_array($result);

                array_push($usedCoilHeat, $heat);


            }



            //find tube number for used coils
            $usedCoilTubes = array();
            foreach($usedCoils as $coil){
                $sql = "SELECT * FROM tubes_tbl WHERE job = '".$_GET['job']."' AND coil = '".$coil["coil_no"]."' AND coil_change = 1";

                //make query & get result
                if ($result= $conn -> query($sql)) {
                
                }
                $tube = mysqli_fetch_array($result);

                array_push($usedCoilTubes, $tube);
            }


            //find tube number of used mesh
            $usedMeshTubes = array();
            foreach($usedMesh as $mesh){
                $sql = "SELECT * FROM tubes_tbl WHERE job = '".$_GET["job"]."' AND (( fil_mesh_change_top = 1 AND filter_mesh_top = '".$mesh['mesh_no']."') OR ( fil_mesh_change_bot = 1 AND filter_mesh_bot = '".$mesh['mesh_no']."') OR ( drain_change_top = 1 AND drain_mesh_top = '".$mesh['mesh_no']."') OR ( drain_change_bot = 1 AND drain_mesh_bot = '".$mesh['mesh_no']."'))";

                //make query & get result
                if ($result= $conn -> query($sql)) {
                
                }
                $tube = mysqli_fetch_array($result);

                array_push($usedMeshTubes, $tube);
            }
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

        <title>Material Search</title>
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
                <h2 id="OOTitle"><b>Material Search</b></h2>
        </div>
        <form action="materialSearch.php" method="GET" class="center">
            <label for="job" style="font-size:45px;">Job #</label>
            <input type="text" class="form-control center" style="font-size:30px; width: 30%; margin-left: 35%;" name="job" placeholder="1234">
            <input type="submit" class="btn btn-primary btn-md " name="Search" value="Search">
        </form>
        

        <div class ="title">
                <h2 id="OOTitle"><b><?php echo (isset($_GET['job']) ? 'Job: '.$_GET['job'] : ""); ?></b></h2>
        </div>
        

        <div class ="title">
                <h3 id="OOTitle"><b>Allocated Coils</b></h2>
        </div>

        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Coil</td>
                        <td style ="vertical-align: middle;" >Heat Number</td>
                        <td style ="vertical-align: middle;">Work Number</td>
                        <td style ="vertical-align: middle;">Date Allocated</td>
                        <td style ="vertical-align: middle;">Weight</td>
                    </tr>
                </thead>
                <tbody>
                        <?php  for($i = 0; $i < count($allocatedCoils); $i++):?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo ($allocatedCoils[$i]['coil_no']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo ($allocCoilHeat[$i]['heat']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['work']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['date_received']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['weight']); ?></td>   
                            </tr>
                        <?php endfor;?>
                </tbody>
            </table>
        </div>

        <div class ="title">
                <h3 id="OOTitle"><b>Used Coils</b></h2>
        </div>
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Coil ID</td>
                        <td style ="vertical-align: middle;" >Heat Number</td>
                        <td style ="vertical-align: middle;">Work Number</td>
                        <td style ="vertical-align: middle;">Start Tube</td>
                        <td style ="vertical-align: middle;">Date Used</td>
                        <td style ="vertical-align: middle;">Weight</td>
                    </tr>
                </thead>
                <tbody>
                        <?php for($i = 0; $i < count($usedCoils); $i++):?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo ($usedCoils[$i]['coil_no']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo ($usedCoilHeat[$i]['heat']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['work']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(substr($usedCoilTubes[$i]['id'], strpos($usedCoilTubes[$i]['id'], '-') + 1)); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['date_used']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['weight']); ?></td>   
                            </tr>
                        <?php endfor;?>
                </tbody>
            </table>
        </div>

        <div class ="title">
                <h3 id="OOTitle"><b>Allocated Mesh</b></h2>
        </div>

        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Mesh ID</td>
                        <td style ="vertical-align: middle;">Heat Number</td>  
                        <td style ="vertical-align: middle;">Mesh</td>
                        <td style ="vertical-align: middle;">Type</td>
                        <td style ="vertical-align: middle;">Date Allocated</td>
                    </tr>
                </thead>
                <tbody>
                        <?php foreach($allocatedMesh as $mesh):?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo ($mesh['mesh_no']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['heat']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['mesh']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['type']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['date_received']); ?></td>   
                            </tr>
                        <?php endforeach;?>
                </tbody>
            </table>
        </div>


        <div class ="title">
                <h3 id="OOTitle"><b>Used Mesh</b></h2>
        </div>
        <div class="outTable">
            <table id= "outgoingOrders" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <td style ="vertical-align: middle;" >Mesh Id</td>
                        <td style ="vertical-align: middle;">Heat Number</td>  
                        <td style ="vertical-align: middle;">Mesh</td>
                        <td style ="vertical-align: middle;">Type</td>
                        <td style ="vertical-align: middle;">Start Tube</td>
                        <td style ="vertical-align: middle;">Date Used</td>
                    </tr>
                </thead>
                <tbody>
                        <?php for($i = 0; $i < count($usedMesh); $i++):?>
                            <tr>
                                <td style ="vertical-align: middle;"><?php echo ($usedMesh[$i]['mesh_no']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['heat']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['mesh']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['type']); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars(substr($usedMeshTubes[$i]['id'], strpos($usedMeshTubes[$i]['id'], '-') + 1)); ?></td>
                                <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['date_used']); ?></td>   
                            </tr>
                        <?php endfor;?>
                </tbody>
            </table>
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