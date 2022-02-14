    <div id="pagebreak" class="pagebreak">
        <h2>
            <strong>TPM Direct-Pack Inspection</strong>
        </h2>
        
        <table>
            <tr>
                <td style="width : 30%;">Job#: <?= $job ?></td>
                <td style="width : 30%;">PO#: <?= $orderACT['po'] ?></td>
                <td style="width : 30%;">Length: <?= $partSpec['finished_length'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td>Line Item: <?= $orderACT['item'] ?></td>
                <td class="pad-l-15"> <?= $partSpec['length_plus'] ?> </td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td class="pad-l-15 pad-b-10"> <?= $partSpec['length_minus'] ?> </td>
            </tr>
            
            <tr>
                <td class="pad-b-20">Total Order: <?= $orderACT['quantity'] ?></td>
                <td class="pad-b-20">Part Description: <?= $partSpec['description'] ?></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Date Started: <?= $orderACT['start_time'] ?></td>
                <td class="pad-b-10">Id Drift: <?= $partSpec['drift'] ?></td>
                <td class="pad-b-10">Inspector for tubes: <?= $insp['name'] ?></td>
            </tr>
            
            <tr>
                <td><strong>Ship Date : <?= $orderACT['ship_date'] ?></strong></td>
                <td><strong>Drift inspected (+ or -.002):</strong></td>
                <td><?= $orderACT['drift_result']?></td>
            </tr>
            
            <tr>
                <td></td>
                <td>Dimensions:<?= $orderACT['drift_dim']?></td>
                <td></td>
            </tr>

            <tr>
                <td></td>
                <td class="pad-b-10">By:<?= $drift['name']?></td>
                <td></td>
            </tr>            
        </table>
        
        <p class="margin-b-15">
            Date Tubes inspected <?= date('Y-m-d', strtotime($tubes[0]['insp_time']))?> to <?= date('Y-m-d', strtotime($tubes[sizeof($tubes)-1]['insp_time']))?>
        </p>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td>
                        <strong>Parts</strong>
                    </td>
                    <td>
                        <strong>Tube Length</strong>
                    </td>
                    <td>
                        <strong>Shunt Tube Length</strong>
                    </td>
                    <td>
                        <strong>STP</strong>
                    </td>
                    <td>
                        <strong>ID Drift</strong>
                    </td>
                    <td>
                        <strong>End Gage</strong>
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php for($i = 1; $i <= 20; $i++): ?>
                <tr>
                </tr>
                <?php endfor; ?>
            </tbody>
        </table>
        
        <p class="margin-b-10">&nbsp;</p>
        <p class="margin-b-10">For tubes listed on this form</p>
        <p class="margin-b-10">Welder's name : ________________________________</p>
        <p class="margin-b-10">Inspected by : _________________________________</p>
        <p class="margin-b-10">For tubes listed on this form</p>
        <p class="margin-b-10">These tubes have been inspected and meet drawing specifications.</p>
        <p class="margin-b-10">All parts will be made from drawing for part number listed above.</p>
        <p class="margin-b-10">All parts will be checked with drawing for part number listed above.</p>
        
    </div>