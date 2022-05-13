<?php    
    $header_tilte = "Material Search";
    include '../Connections/connectionTPM.php';
    include 'header.php';
?>
<?php
    $order = array();
    if(isset($_GET['Search']) || isset($_GET['pdf'])){
        

        if($_GET['job'] != ""){

            //grabbing allocated coils
            $sql = 'SELECT * FROM coil_tbl WHERE job = "'.$_GET["job"].'"';
            $allocatedCoils = $db->query($sql)->fetchAll();

            // grabbing used coils
            $sql = 'SELECT * FROM used_coil WHERE job = "'.$_GET["job"].'" ORDER BY date_used';
            $usedCoils = $db->query($sql)->fetchAll();

            // grabbing allocated mesh
            $sql = 'SELECT * FROM mesh_tbl WHERE job = "'.$_GET["job"].'"';
            $allocatedMesh = $db->query($sql)->fetchAll();
            
            // grabbing used mesh
            $sql = 'SELECT * FROM used_mesh WHERE job = "'.$_GET["job"].'"';
            $usedMesh = $db->query($sql)->fetchAll();

            //grab heat number for allocated coils from work number
            $allocCoilHeat = array();
            foreach($allocatedCoils as $coil){
                $sql = 'SELECT * FROM steel_tbl WHERE work = "'.$coil['work'].'"';

                $heat = $db->query($sql)->fetchArray();

                array_push($allocCoilHeat, $heat);
            }

            //grab heat number for used coils from work number
            $usedCoilHeat = array();
            foreach($usedCoils as $coil){
                $sql = 'SELECT * FROM steel_tbl WHERE work = "'.$coil['work'].'"';                

                $heat = $db->query($sql)->fetchArray();

                array_push($usedCoilHeat, $heat);
            }

            //find tube number for used coils
            $usedCoilTubes = array();
            foreach($usedCoils as $coil){

                //Get the first used tube
                // $sql = "SELECT id, COUNT(*) as CNT FROM tubes_tbl WHERE job = '".$_GET['job']."' AND coil = '".$coil["coil_no"]."' AND coil_change = 1 GROUP BY job,coil limit 1";
                $sql = "SELECT id, COUNT(*) as CNT FROM tubes_tbl WHERE job = '".$_GET['job']."' AND coil = '".$coil["coil_no"]."' GROUP BY job,coil limit 1";
                //make query & get result
                $result= $conn -> query($sql);
                $firstTube = mysqli_fetch_array($result);

                //Get the last used tube
                $lastTube = "";
                if(!empty($firstTube['CNT']) && $firstTube['CNT'] > 1){
                    // $sql = "SELECT id FROM tubes_tbl WHERE job = '".$_GET['job']."' AND coil = '".$coil["coil_no"]."' AND coil_change = 1 ORDER BY id DESC limit 1";                    
                    $sql = "SELECT id FROM tubes_tbl WHERE job = '".$_GET['job']."' AND coil = '".$coil["coil_no"]."' ORDER BY id DESC limit 1";                    
                    $result= $conn -> query($sql);
                    $lastTube = mysqli_fetch_array($result);
                }

                array_push($usedCoilTubes, ['first_tube' => !empty( $firstTube['id'] ) ? $firstTube['id'] : null, 
                                            'count'      => !empty( $firstTube['CNT'] ) ? $firstTube['CNT'] : 0, 
                                            'last_tube'  => !empty( $lastTube['id'] ) ? $lastTube['id'] : null]);
            }


            //find tube number of used mesh
            $usedMeshTubes = array();
            foreach($usedMesh as $mesh){
                $sql = "SELECT * FROM tubes_tbl WHERE job = '".$_GET["job"]."' AND (( fil_mesh_change_top = 1 AND filter_mesh_top = '".$mesh['mesh_no']."') OR ( fil_mesh_change_bot = 1 AND filter_mesh_bot = '".$mesh['mesh_no']."') OR ( drain_change_top = 1 AND drain_mesh_top = '".$mesh['mesh_no']."') OR ( drain_change_bot = 1 AND drain_mesh_bot = '".$mesh['mesh_no']."'))";

                $tube = $db->query($sql)->fetchArray();

                array_push($usedMeshTubes, $tube);
            }
        }
        
    }
	
?>
    <div class="container-fluid px-4">
        <div class ="title">
            <h2><b>Material Search</b></h2>
        </div>
        <form action="materialSearch.php" method="GET" class="center pt-0 mt-0">
            <label for="job" style="font-size:45px;">Job #</label>
            <input class="form-control col-md-4 col-xs-12 m-auto text-center" type="text" name="job" placeholder="1234">
            <input type="submit" class="btn btn-primary btn-md mt-2" name="Search" value="Search">
        </form>        

        <div class="title">
            <h2 class="pt-0 mt-0"><b><?php echo (isset($_GET['job']) ? 'Job: '.$_GET['job'] : ""); ?></b></h2>
        </div>        

        
        <!-- Allocated coils >> -->
        <div class="card mb-4">
            <div class="text-center card-header">
                <h4 class="text-center"><b>Allocated Coils</b> (<?= !empty($allocatedCoils) ? count($allocatedCoils) : 0; ?>)</h4> 
            </div>
            <div class="card-body">
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
                            <?php  
                            if(!empty($allocatedCoils)):
                                for($i = 0; $i < count($allocatedCoils); $i++):?>
                                    <tr>
                                        <td style ="vertical-align: middle;"><?php echo ($allocatedCoils[$i]['coil_no']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo ($allocCoilHeat[$i]['heat']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['work']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['date_received']); ?></td>
                                        <td style ="vertical-align: middle;"><?php echo htmlspecialchars($allocatedCoils[$i]['weight']); ?></td>   
                                    </tr>
                                <?php endfor;?>
                            <?php                             
                            endif;
                            ?>
                    </tbody>
                </table>
            </div>            
        </div>
        
        <!-- Used coils >> -->
        <div class="card mt-4">
            <div class="card-header text-center">
                <h4><b>Used Coils</b> (<?= !empty($usedCoils) ? count($usedCoils) : 0; ?>) </h4>
            </div>
            <div class="card-body">        
                <table id= "usedCoils" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td style ="vertical-align: middle;" >Coil ID</td>
                            <td style ="vertical-align: middle;">First ~ Last Tube ID</td>
                            <td style ="vertical-align: middle;">Toal Number of Tube</td>
                            <td style ="vertical-align: middle;" >Heat Number</td>
                            <td style ="vertical-align: middle;">Work Number</td>
                            <td style ="vertical-align: middle;">Date Used</td>
                            <td style ="vertical-align: middle;">Weight</td>
                        </tr>
                    </thead>
                    <tbody>
                            <?php 
                            if(!empty($usedCoils)){
                                for($i = 0; $i < count($usedCoils); $i++){
                            ?>
                                <tr>
                                    <td style ="vertical-align: middle;"><?php echo ($usedCoils[$i]['coil_no']); ?></td>

                                    <?php $firstTB = !empty($usedCoilTubes[$i]['first_tube']) ? explode('-', $usedCoilTubes[$i]['first_tube'])[1] : "";?>
                                    
                                    <?php if($usedCoilTubes[$i]['count'] <= 1):?>
                                        <td style ="vertical-align: middle;"><?= $firstTB ?></td>
                                    <?php else:?>
                                        <?php $lastTB = !empty($usedCoilTubes[$i]['last_tube']) ? explode('-', $usedCoilTubes[$i]['last_tube'])[1] : ""; ?>
                                        <td style ="vertical-align: middle;"><?php echo $firstTB ?> ~ <?= $lastTB ?></td>
                                    <?php endif;?>

                                    <td style ="vertical-align: middle;"><?php echo $usedCoilTubes[$i]['count'] ?></td>
                                    <td style ="vertical-align: middle;"><?php echo ($usedCoilHeat[$i]['heat']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['work']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['date_used']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedCoils[$i]['weight']); ?></td>   
                                </tr>
                            <?php 
                                }
                            }
                            ?>
                    </tbody>
                </table>
            </div>
        </div>        

        <!-- Tubes coils >> -->
        <?php 
        $tubeData = [];
        if(!empty($_GET['job'])){
            $sql = "SELECT * FROM v_tubes_tbl WHERE job = ".$_GET['job'];
            $tubeData = $db->query($sql)->fetchAll();

            $sql = "SELECT COUNT(*) as CNT FROM v_tubes_tbl WHERE job = ".$_GET['job']." AND mill_check = 1 AND cutoff_check = 1 AND insp_check = 1";
            $ins_done_cnt = $db->query($sql)->fetchArray();
            
            $sql = "SELECT COUNT(*) as CNT FROM v_tubes_tbl WHERE job = ".$_GET['job']." AND mill_check = 1 AND cutoff_check = 1 AND insp_check = 0";
            $ins_not_done_cnt = $db->query($sql)->fetchArray();            
        }
        ?>
        <div class="card mt-4">
            <div class="card-header text-center">
                <h4 class="text-center pb-0 mb-0"><b>Tube Lists</b> (<?= !empty($tubeData) ? count($tubeData) : 0; ?>)</h4>
                <strong><i class="fa fa-check text-success"></i> - Checked , <i class="fa fa-ban"></i> - Not Checked</strong><br>
                <strong class="text-success">Checked Inspection: <?= $ins_done_cnt['CNT'] ? $ins_done_cnt['CNT'] : 0 ?> </strong><br>
                <strong class="text-danger"> Not checked Inspection: <?= $ins_not_done_cnt['CNT'] ? $ins_not_done_cnt['CNT'] : 0 ?> </strong>
            </div>
            <div class="card-body">        
                <table id="tubesCoils" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td style ="vertical-align: middle;" >Tube ID</td>
                            <td style ="vertical-align: middle;">Coil ID</td>
                            <td style ="vertical-align: middle;">Mill Checked</td>
                            <td style ="vertical-align: middle;" >CutOff Checked</td>
                            <td style ="vertical-align: middle;">Inspect Checked</td>
                            <td style ="vertical-align: middle;">Mill Time</td>
                            <td style ="vertical-align: middle;">CutOff Time</td>
                            <td style ="vertical-align: middle;">Inspect Time</td>
                            <td style ="vertical-align: middle;">Mill Operator</td>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach($tubeData as $key => $tube):?>                        
                        <tr>
                            <td><?= $tube['id']?></td>
                            <td><?= $tube['coil']?></td>                            
                            <td><?= $tube['mill_check'] ? '<i class="fa fa-check text-success"></i>' : '<i class="fa fa-ban"></i>'; ?></td>
                            <td><?= $tube['cutoff_check'] ? '<i class="fa fa-check text-success"></i>' : '<i class="fa fa-ban"></i>'; ?></td>                            
                            <td><?= $tube['insp_check'] ? '<i class="fa fa-check text-success"></i>' : '<i class="fa fa-ban"></i>'; ?></td>                            
                            <td><?= $tube['mill_check'] ? date('Y-m-d H:i', strtotime($tube['mill_time']) ) : ''; ?></td>                            
                            <td><?= $tube['cutoff_check'] ?  date('Y-m-d H:i', strtotime($tube['cutoff_time'])) : '' ?></td>                            
                            <td><?= $tube['final_insp'] ? $tube['final_insp_time'] : ''; ?></td>                            
                            <td><?= $tube['mill_operator_name']; ?></td>                            
                        </tr>
                        <?php endforeach;?>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- << -->
        <div class="card mt-4">
            <div class="card-header text-center">
                <h4><b>Allocated Mesh</b> (<?= !empty($allocatedMesh) ? count($allocatedMesh) : 0; ?>)</h4>
            </div>
            <div class="card-body">
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
                            <?php 
                            if(!empty($allocatedMesh)):
                                foreach($allocatedMesh as $mesh):
                            ?>
                                <tr>
                                    <td style ="vertical-align: middle;"><?php echo ($mesh['mesh_no']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['heat']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['mesh']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['type']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($mesh['date_received']); ?></td>   
                                </tr>
                            <?php 
                                endforeach;
                            endif;
                            ?>
                    </tbody>
                </table>
            </div>
        </div>
        

        <!-- >> -->
        <div class="card mt-4">
            <div class="card-header text-center">
                <h4><b>Used Mesh</b> (<?= !empty($usedMesh) ? count($usedMesh) : 0; ?>)</h4>
            </div>
            <div class="card-body">
                <table id="usedMesh" class="table table-striped table-bordered">
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
                            <?php 
                            if(!empty($usedMesh)):
                                for($i = 0; $i < count($usedMesh); $i++):
                            ?>
                                <tr>
                                    <td style ="vertical-align: middle;"><?php echo ($usedMesh[$i]['mesh_no']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['heat']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['mesh']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['type']); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars(substr($usedMeshTubes[$i]['id'], strpos($usedMeshTubes[$i]['id'], '-') + 1)); ?></td>
                                    <td style ="vertical-align: middle;"><?php echo htmlspecialchars($usedMesh[$i]['date_used']); ?></td>   
                                </tr>
                            <?php endfor;
                            endif;
                            ?>
                    </tbody>
                </table>
            </div>
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

    <script type="text/javascript">
    $(function () {        
        $('#tubesCoils').DataTable( {
            rowReorder: {
                // selector: 'td:nth-child(2)'
            },
            responsive: true
        } );

        $('#usedCoils').DataTable( {
            rowReorder: {},
            order: [[5, "asc"]],
            responsive: true
        } );
        
        $('#usedMesh').DataTable( {
            rowReorder: {},            
            responsive: true
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