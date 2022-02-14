
<div id="pagebreak" class="pagebreak">        
        <div class="titleImg">
                <h1 class="title">
                    <strong>TPM - Worksheet</strong>
                </h1>
                <div class="image" style="float: right;"> <img src="logo_tpm.jpeg"></div>
        </div>
        <p class="margin-b-10">&nbsp;</p>
        <p class="margin-b-10">&nbsp;</p>
        <h3 style="text-align :center;font-size: 16px">
            <strong>(Boxing Instructions and markings for Ring Installers)</strong>
        </h3>
        
        <p class="margin-b-10">&nbsp;</p>
       
        <table class="margin-b-20" style="border-collapse: separate;
    border-spacing: 0 1em;font-size: 16px">
            <tr >
                <td style="width : 20%;" class="pad-b-10">Customer:  </td>
                <td style="width : 30%; text-decoration: underline;" class="pad-b-10"><?= getCustomer($orderACT['cust_id']) ?></td>
                <td style="width : 25%;" class="pad-b-10"></td>
                <td style="width : 25%;" class="pad-b-10"></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">TPM job number:  </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $job ?></td>
                <td class="pad-b-10" colspan="2">Date Completed: <?= $orderACT['finished'] ?></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Part Description: </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $partSpec['description'] ?></td>
                <td></td>
                <td></td>
            </tr>
            
            <tr>
                <td class="pad-b-10">Part number: </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $orderACT['part'] ?></td>
                <td class="pad-b-10">PO number: </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $orderACT['po'] ?></td>
            </tr>
            
            <!-- <tr>
                <td class="pad-b-10">Heat number (tube): </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $heatNum['heat_number'] ?></td>
                <td class="pad-b-10">Heat number (rings): </td>
                <td class="pad-b-10" style="text-decoration: underline;"><?= $heatNum['heat_number'] ?></td>
            </tr> -->
            
            <tr>
                <td>Total Qty on Order: </td>
                <td style="text-decoration: underline;"><?= $orderACT['quantity'] ?></td>
                <td>Container Type: </td>
                <td style="text-decoration: underline;"><?= $contType['cont_type'] ?></td>
            </tr>
            
            <tr>
                <td></td>
                <td></td>
                <td>Shipping Method: </td>
                <td style="text-decoration: underline;"><?= $shipMeth['ship_method'] ?></td>
            </tr>
            
            <tr>
                <td>GWT:</td>
                <td>_____________</td>
                <td>Qty in each box/Pallet </td>
                <td>__________</td>
            </tr>
            
            <!--<?php //for ($i = 1; $i <= 3; $i ++) : ?>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td>__________</td>
            </tr>
            <?php //endfor; ?> -->
            
            <tr>
                <td class="pad-t-10" style="font-size: 20px; font-weight: bolder;">Ship Date: </td>
                <td class="pad-t-10" style="font-size: 18px;text-decoration: underline;"><?= $orderACT['ship_date'] ?></td>
                <td class="pad-t-10">Item No: </td>
                <td class="pad-t-10" style="text-decoration: underline;">


                    <?php 
                    $tempnum = $orderACT['item'];
 
                    if($tempnum < 10)
                    {
                        $newnum = "000";
                    } else if($tempnum < 100) {
                        $newnum = "00";
                    } else if($tempnum < 1000) {
                        $newnum = "0";
                    }else { $newnum = ""; }
 



            echo $newnum.$orderACT['item'] ?></td>
            </tr>

            
            
        </table>
       
        <!-- <p class="margin-b-20">&nbsp;</p> -->
        
        <p style="font-size: 18px;">Inspector: _________________________________________</p>
        <p style="font-size: 18px;margin-left: 90px;">
            (Signature)
        </p>
        
</div>