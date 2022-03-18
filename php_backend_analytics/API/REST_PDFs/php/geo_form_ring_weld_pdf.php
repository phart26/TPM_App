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
            <h2>
                <strong>TPM Weld Sheet-GeoForm</strong>
                <div class="image"> <img src="/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/logo_tpm.jpeg"></div>
            </h2>
        </div>
        
        
        <table>
            <tr>
                <td style="width : 22%">Job#: <?= $job ?></td>
                <td style="width : 22%">PO#: <?= $orderACT['po'] ?></td>
                <td style="width : 22%">Total Order: <?= $orderACT['quantity'] ?></td>
                <td style="width : 22%"></td>
            </tr>
            
            <tr>
                <td>Length: <?= $partSpec['finished_length'] ?></td>
                <td class="pad-t-10">Weld Spec Repair: <?= $orderACT['weld_spec_repair'] ?></td>
            </tr>
            
            <tr>
                <td class="pad-l-15">+ <?= $partSpec['length_plus'] ?> </td>
            </tr>
            
            <tr>
                <td class="pad-l-15 pad-b-10">- <?= $partSpec['length_minus'] ?> </td>
                <td>Total Order: <?= $orderACT['quantity'] ?></td>
            </tr>
            
            <tr>
                <td style="pad-t-10">Filler Rod: <?= $weldSpecRep['filler_rod']?></td>
                <td style="pad-t-10">Min. Travel Speed: <?= $weldSpecRep['repair_speed']?></td>
                <td></td>
            </tr>

            <tr>
            <td style="pad-t-10">Repair Amps: <?= $weldSpecRep['repair_amps']?></td>
                <td style="pad-t-10">Repair Volts: <?= $weldSpecRep['repair_volts']?></td>
                <td></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Date Started: <?= $orderACT['began'] ?></td>
                <td></td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td></td>
            </tr>

            <tr>
                <td></td>
                <td></td>
                <td></td>
            </tr>            
        </table>
        
        <p class="margin-b-15">
            Date rings welded:  <?= date('Y-m-d', strtotime($tubes[$from]['geo_ring_weld_time']))?> to <?= date('Y-m-d', strtotime($tubes[$to-1]['geo_ring_weld_time']))?>
        </p>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Tube</strong>
                    </td>
                    <td>
                        <strong>Ring A</strong>
                    </td>
                    <td>
                        <strong>Ring B</strong>
                    </td>
                     <td>
                        <strong>Filler Rod Heat</strong>
                    </td>
                    <td>
                        <strong>Filler Rod Manufacturer</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = $from ; $i < $to ; $i++): ?>
                <tr>
                    <td><?= $tubes[$i]['id'] ?></td>
                    <td><?= $tubes[$i]['ringA'] ?></td>
                    <td><?= $tubes[$i]['ringB'] ?></td>
                    <td><?= $tubes[$i]['heat_num_weld'] ?></td>
                    <td><?= $tubes[$i]['manufac_weld'] ?></td>
                    
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
        
</div>

<?php 
   $numPages--;
   $from = $to;
   $to += 11;
    }

?>