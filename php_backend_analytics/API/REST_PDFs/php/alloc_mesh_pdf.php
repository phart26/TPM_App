<div id="pagebreak" class="pagebreak">
        
        <p class="margin-b-10">&nbsp;</p>
        
        <table class="margin-b-10">
            <tr>
                <td style="width : 50%;" class="pad-b-10">
                    <h3>
                        Mesh Allocation for job : <?= $header['job'] ?> 
                    </h3>
                </td>
                <td class="pad-b-10">
                    PO number: <?= $header['po_number'] ?> <br/>
                    item: <?= $header['line_item'] ?> 
                </td>
            </tr>
        </table>
        
        <?php $i = 0; 
        foreach($group_records as $arr) : 
            $i++; 
        
            $tr_cls = $i == 1 ? "" : "grey";
        ?>
        <table class="summary-table">
            <thead>
                <tr class="<?= $tr_cls ?>">
                    <td style="width : 25%">
                        <p class="pad-b-5" style="font-size: 14px;">
                            <?= $arr[0]["mesh"] ?> &nbsp;
                        </p>
                        Mesh Coil Number
                    </td>
                    <td style="width : 25%">
                        <p class="pad-b-5">&nbsp;</p>
                        Length
                    </td>
                    <td style="width : 25%">
                        <p class="pad-b-5">&nbsp;</p>
                        Heat#
                    </td>
                    <td style="width : 25%">
                        <p class="pad-b-5">&nbsp;</p>
                        TPM PO
                    </td>
                </tr>
            </thead>
            
            <tbody>
                <?php foreach($arr as $record) : ?>
                    <tr>
                        <td><?= $record["mesh_no"] ?></td>
                        <td><?= $record["length"] ?></td>
                        <td><?= $record["heat"] ?></td>
                        <td><?= $header['po_number'] ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        <?php endforeach; ?>

        <footer>
           <!--  <p class="margin-b-10">
                Data represented on this report is TPM controlled information and can be modified by only authorized Information Technology personnel.
            </p> -->
            
            <p>
                    <?= $footer['mesh_alloc']; ?><br>
                    <?= $footer['mesh_alloc-2']; ?><br>
                    <?= $footer['mesh_alloc-3']; ?><br>
                    <?= $footer['mesh_alloc-4']; ?>                
                </p>
        </footer>
       
</div>