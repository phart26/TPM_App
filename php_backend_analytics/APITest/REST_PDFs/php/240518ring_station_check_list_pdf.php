<?php
    $numTubes = sizeof($tubes);
    $numPages = ceil($numTubes/6);
    $from = 0;
    $to = 6;

    while($numPages > 0){
?>
<div id="pagebreak" class="pagebreak">
        
<div class="titleImg">
            <h2>
                <strong>TPM Excluder Ring Check Sheet</strong>
                <div class="image"> <img src="logo_tpm.jpeg"></div>
            </h2>
        </div>
        
        <table class="header">
            <tr>
                <td style="width : 30%">Job#: <?= $job ?></td>
                <td style="width : 30%">PO#: <?= $orderACT['po'] ?></td>
                <td style="width : 30%">Average Ring ID: <?= $partSpec['ring_min'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td>To : <?= $partSpec['ring_max'] ?></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Total Order: <?= $orderACT['quantity'] ?></td>
                <td class="pad-b-10">Part Description: <?= $partSpec['description'] ?></td>
                <td>Line Item: <?= $orderACT['item'] ?></td>
            </tr>
            
            <tr>
                <td>Date Started: <?= $orderACT['start_time'] ?></td> 
            </tr>
            
            <tr>
            </tr>
            
        </table>
       
        <p class="pad-b-20">
            Date Tubes inspected<?= date('Y-m-d', strtotime($tubes[$from]['insp_time']))?> to <?= date('Y-m-d', strtotime($tubes[$to-1]['insp_time']))?>
        </p>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Tube</strong>
                    </td>
                    <td>
                        <strong>End 1 Reading</strong>
                    </td>
                    <td>
                        <strong>End 1 Reading</strong>
                    </td>
                    <td>
                        <strong>End 1 Average</strong>
                    </td>
                    <td>
                        <strong>End 2 Reading</strong>
                    </td>
                    <td>
                        <strong>End 2 Reading</strong>
                    </td>
                    <td>
                        <strong>End 2 Average</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = $from ; $i < $to; $i++): ?>
                <tr>
                    <td><?= $tubes[$i]['id'] ?></td>
                    <td><?= $tubes[$i]['end1_read1'] ?></td>
                    <td><?= $tubes[$i]['end1_read2'] ?></td>
                    <td><?= $tubes[$i]['end1_avg'] ?></td>
                    <td><?= $tubes[$i]['end2_read1'] ?></td>
                    <td><?= $tubes[$i]['end2_read2'] ?></td>
                    <td><?= $tubes[$i]['end2_avg'] ?></td>
                </tr>
                <?php endfor; ?>
            </tbody>
        </table>
        
        <p class="pad-b-20">&nbsp;</p>
        
        <p>
            <strong>All Ends Must Be Checked with Calipers</strong>
            <ul style="margin-left: 30px;">
                <li>
                    The tube will be checked in two places on each end of the tube, and the average of the two measurements must be within the average listed above.
                </li>
            </ul>
        </p>
        
        <p>
            <strong>Setup</strong>
            <ul style="margin-left: 30px;">
                <li>Set ring ID average to the lower range of the average tolerance. </li>
            </ul>
        </p>
        
</div>
<?php 
   $numPages--;
   $from = $to;
   $to += 6;
    }

?>