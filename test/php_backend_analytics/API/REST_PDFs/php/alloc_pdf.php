<div id="pagebreak" class="pagebreak">
        
        <p class="margin-b-10">&nbsp;</p>
        
        <table class="margin-b-10">
            <tr>
                <td style="width : 50%;" class="pad-b-10">
                    <h3>
                        Coil Allocation for job : <?= $header['job'] ?> 
                    </h3>
                </td>
                <td class="pad-b-10">
                    PO number: <?= $header['po_number'] ?> <br/>
                    item: <?= $header['line_item'] ?> 
                </td>
            </tr>
        </table>
        
        <table class="summary-table">
            <thead>
                <tr>
                    <td style="width : 25%">Coil Number</td>
                    <td style="width : 25%">Weight</td>
                    <td style="width : 25%">Heat#</td>
                    <td style="width : 25%">Work Number</td>
                </tr>
            </thead>
            
            <tbody>
                <?php foreach($records as $record) : ?>
                <tr>
                    <td><?= $record["coil_no"] ?></td>
                    <td><?= $record["weight"] ?></td>
                    <td><?= $record["heat"] ?></td>
                    <td><?= $header['po_number'] ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <footer>
           <!--  <p class="margin-b-10">
                Data represented on this report is TPM controlled information and can be modified by only authorized Information Technology personnel.
            </p> -->
            
            <p>
                    <?= $footer['coil_alloc']; ?><br>
                    <?= $footer['coil_alloc-2']; ?><br>
                    <?= $footer['coil_alloc-3']; ?><br>
                    <?= $footer['coil_alloc-4']; ?>
                </p>
        </footer>
       
</div>