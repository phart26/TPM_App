<?php
    $numTubes = sizeof($tubes);
    $from = 0;
    $to;
    if($numTubes < 17){
        $to = $numTubes;
    }else{
        $to = 17;
    }
    $numPages = ceil($numTubes/$to);
    

    while($numPages > 0){
?>
<div id="pagebreak" class="pagebreak">
        <div class="titleImg">
                <h2 class="title">
                    <strong>TPM Welding-Station Check Sheet</strong>
                </h2>
                <div class="image"> <img src="logo_tpm.jpeg"></div>
        </div>
        
        <table class="header">
            <tr>
                <td style="width : 25%">Job#: <?= $job ?></td>
                <td style="width : 20%">PO#: <?= $orderACT['po'] ?></td>
                <td style="width : 25%">Cutoff: <?= $partSpec['cutoff_length'] ?></td>
                <td class="pad-b-10">Line Item: <?= $orderACT['item'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td class="pad-l-15">+<?= $partSpec['cutoff_length_plus'] ?></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td class="pad-b-10 pad-l-15">-<?= $partSpec['cutoff_length_minus'] ?></td>
                <td class="pad-b-10"></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Total Order: <?= $orderACT['quantity'] ?></td>
                <td class="pad-b-10">OD: <?= $partSpec['dim'] ?></td>
                <td class="pad-b-10">Spec Mill: <?= $orderACT['weld_spec_mill'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td class="pad-l-15">+<?= $partSpec['dim_plus'] ?></td>
            </tr>

            <tr>
                <td></td>
                <td class="pad-b-10 pad-l-15">-<?= $partSpec['dim_minus'] ?></td>
                <td class="pad-b-10"></td>
            </tr>

            <tr>
                <td class="pad-b-10">Date Started: <?= $orderACT['start_time'] ?></td>                
                <td class="pad-b-10"></td>
            </tr>
            
            <tr>
                <td colspan="3" class="pad-b-10">Dates Tubes Made : <?= date('Y-m-d', strtotime($tubes[$from]['mill_time']))?> to <?= date('Y-m-d', strtotime($tubes[$to-1]['mill_time']))?></td>
            </tr>
            
        </table>
       
        <p class="pad-b-10">&nbsp;</p>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Tube</strong>
                    </td>
                    <td>
                        <strong>OD Check</strong>
                    </td>
                    <td>
                        <strong>OD Check</strong>
                    </td>
                    <td>
                        <strong>Coil Change</strong>
                    </td>
                    <td>
                        <strong>Filter Mesh 1 Change</strong>
                    </td>
                    <td>
                        <strong>Filter Mesh 2 Change</strong>
                    </td>
                    <td>
                        <strong>Drainage Mesh 1 Change</strong>
                    </td>
                    <td>
                        <strong>Drainage Mesh 2 Change</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = $from ; $i < $to; $i++): ?>
                <tr>
                    <td><?= $tubes[$i]['id'] ?></td>
                    <td><?= $tubes[$i]['od_check1'] ?></td>
                    <td><?= $tubes[$i]['od_check2'] ?></td>
                    <td><?php echo ($tubes[$i]['coil_change'] > 0 ?$tubes[$i]['coil']:""); ?></td>
                    <td><?php echo ($tubes[$i]['fil_mesh_change_top'] > 0 ?$tubes[$i]['filter_mesh_top']:""); ?></td>
                    <td><?php echo ($tubes[$i]['fil_mesh_change_bot'] > 0 ?$tubes[$i]['filter_mesh_bot']:""); ?></td>
                    <td><?php echo ($tubes[$i]['drain_change_top'] > 0 ?$tubes[$i]['drain_mesh_top']:""); ?></td>
                    <td><?php echo ($tubes[$i]['drain_change_bot'] > 0 ?$tubes[$i]['drain_mesh_bot']:""); ?></td>
                </tr>
                <?php endfor; ?>
            </tbody>
        </table>
        
</div>
<?php 
   $numPages--;
   $from = $to;
   $to += 25;
    }
?>