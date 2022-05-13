
<?php
    $numTubes = sizeof($tubes);
    $from = 0;
    $to;
    if($numTubes < 13){
        $to = $numTubes;
    }else{
        $to = 13;
    }
    $numPages = ceil($numTubes/$to);

    while($numPages > 0){
?>
<div id="pagebreak" class="pagebreak">
        <div class="titleImg">
            <h2>
                <strong>TPM Final Inspection-GeoForm</strong>
                <div class="image"> <img src="/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/logo_tpm.jpeg"></div>
            </h2>
        </div>
        
        
        <table>
            <tr>
                <td style="width : 30%;">Job#: <?= $job ?></td>
                <td style="width : 30%;">PO#: <?= $orderACT['po'] ?></td>
                <td style="width : 30%;">Length: <?= $partSpec['finished_length'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td class="pad-l-15">+ <?= $partSpec['length_plus'] ?> </td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td class="pad-l-15 pad-b-10">- <?= $partSpec['length_minus'] ?> </td>
            </tr>
            
            <tr>
                <td>Total Order: <?= $orderACT['quantity'] ?></td>
                <td>OD: <?= $partSpec['dim'] ?></td>
                <td>Date Tubes inspected:  <?= date('Y-m-d', strtotime($tubes[$from]['final_insp_time']))?> to <?= date('Y-m-d', strtotime($tubes[$to-1]['final_insp_time']))?></td>
            </tr>
            
            <tr>
                <td></td>
                <td class="pad-l-15">+<?= $partSpec['dim_plus'] ?></td>
                <td></td>
            </tr>

            <tr>
                <td class="pad-b-10"></td>
                <td class="pad-b-10 pad-l-15">-<?= $partSpec['dim_minus'] ?></td>
                <td class="pad-b-10"></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Date Started: <?= $orderACT['began'] ?></td>
                <td class="pad-b-10">ID Drift: <?= $partSpec['drift'] ?></td>
            </tr>
            
            <tr>
                <td><strong>Ship Date : <?= $orderACT['ship_date'] ?></strong></td>
                <td><strong>Drift inspected (+ or -.002):</strong></td>
                <td>Dimensions: <?= $orderACT['drift_dim']?></td>
            </tr>

            <tr>
                <td></td>
                <td class="pad-b-10">By: <?= $drift['name']?> </td>
                <td></td>
            </tr>            
        </table>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Tube</strong>
                    </td>
                    <td>
                        <strong>ID Drift</strong>
                    </td>
                    <td>
                        <strong>Length Check</strong>
                    </td>
                     <td>
                        <strong>Ring No. 1</strong>
                    </td>
                    <td>
                        <strong>Ring No. 2</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = $from ; $i < $to ; $i++): ?>
                <tr>
                    <td><?= $tubes[$i]['id'] ?></td>
                    <td><?= $tubes[$i]['id_drift2'] ?></td>
                    <td><?= $tubes[$i]['final_length_check'] ?></td>
                    <td><?= $tubes[$i]['ring_num1'] ?></td>
                    <td><?= $tubes[$i]['ring_num2'] ?></td>
                    
                </tr>
                <?php endfor; ?>
            </tbody>
        </table>
        
        <p>
            <strong>Key</strong>
            <span class="margin-l-5">P = Passed</span>
            <span class="margin-l-5">N = None</span>
            <span class="margin-l-5">WL = Within Limits</span>
        </p>
        
        <p class="margin-b-10">&nbsp;</p>
        <p class="margin-b-10">
            Inspection Notes:  <?= $partSpec['insp_notes'] == '' ? '______________________' : $partSpec['insp_notes']; ?>
        </p>
        
</div>

<?php 
   $numPages--;
   $from = $to;
   $to += 13;
    }

?>