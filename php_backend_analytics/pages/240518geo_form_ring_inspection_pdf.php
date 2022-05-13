<?php
    $numRings = sizeof($rings);
    $numPages = ceil($numRings/6);
    $from = 0;
    $to = 6;

    while($numPages > 0){
?>
<div id="pagebreak" class="pagebreak">
        
        <div class="titleImg">
                <h2 class="title">
                    <strong>TPM GeoForm Ring Inspection</strong>
                </h2>
                <div class="image"> <img src="/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/logo_tpm.jpeg"></div>
        </div>
        
        <table class="header margin-b-20">
            <tr>
                <td style="width : 50%" class="pad-b-10">TPM PO: <?= $orderACT['po'] ?></td>
                <td style="width : 50%" class="pad-b-10">TPM Batch: G-<?= $job ?></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">PO Quantity: <?= $orderACT['quantity'] ?></td>
                <td class="pad-b-10">Drawing Number: <?= $partSpec['drawing_number'] ?></td>
            </tr>
            
        </table>
       
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Ring</strong>
                    </td>
                    <td>
                        <strong>ID</strong>
                    </td>
                    <td>
                        <strong>OD</strong>
                    </td>
                    <td>
                        <strong>Length</strong>
                    </td>
                    <td>
                        <strong>Finish</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = $from ; $i < $to; $i++): ?>
                <tr>
                    <td><?= $rings[$i]['ring_id'] ?></td>
                    <td><?= $rings[$i]['ID'] ?></td>
                    <td><?= $rings[$i]['OD'] ?></td>
                    <td><?= $rings[$i]['length_check'] ?></td>
                    <td><?= $rings[$i]['finish'] ?></td>
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
            Inspection Notes: 
        </p>
        
        <p class="margin-b-10">
            <?= $orderACT['insp_notes'] ?>
        </p>
        
        
</div>
<?php 
   $numPages--;
   $from = $to;
   $to += 6;
    }

?>
