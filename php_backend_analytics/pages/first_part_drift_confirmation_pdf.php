<div id="pagebreak" class="pagebreak">
        
        <div>
            <img src="/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/logo_tpm.jpeg" style="float: left;" alt="TPM Logo" />
            <h1 style="float: right; width: 50%;text-align: right;">FIRST PART CONFIRMATION</h1>
            <div style="clear: both;"></div>
            <h3 style="text-align: center;">THIS IS REQUIRED AT SET-UP AND DAILY START UP.</h3>
        </div>

        <hr>
        <div style="padding-top: 0%">
            <h3>DATE : <?= $tubes[0]['mill_time']?></h3>
            <h3 style="padding-top: 2%;">JOB NUMBER : <?= $job ?></h3>
            <h3 style="padding-top: 2%;">MILL NUMBER : <?= $orderACT['device'] == '' ? '______________________' : $orderACT['device']; ?></h3>
            <h3 style="padding-top: 2%;">MATERIAL THICKNESS CHECK : <?= $thick['thickness'] == '' ? '______________________' : $thick['thickness']; ?> Inch (<?= $partSpec['gage'] ?> Gage )  </h3>
            <h3 >DIMPLE/SLOT DEPTH CHECK : <?= $partSpec['depth_of_dimple'] == '' ? '______________________' : $partSpec['depth_of_dimple']; ?>
                
                <span class="pad-l-10"><?= $partSpec['depth_of_dimple_plus'] ?> </span>
                    <span class="pad-l-10"><?= $partSpec['depth_of_dimple_minus'] ?></span>
            </h3>

            <h3 style="padding-top: 2%;">BLANK END RING : <?= $partSpec['blank_end'] == '' ? '______________________' : $partSpec['blank_end']; ?> 
            <span class="pad-l-10"><?= $partSpec['blank_end_plus'] ?> </span>
                    <span class="pad-l-10"><?= $partSpec['blank_end_minus'] ?></span>  </h3>

            <h3 style="padding-top: 2%;">BLANK AREA : END 1- <?= $tubes[0]['end1_avg']?>     END 2- <?= $tubes[0]['end2_avg']?></h3>

            <h3 style="padding-top: 2%;">BEND TEST-PASS OR FAIL: <?= "Pass" ?></h3>

            <h3 style="padding-top: 2%;">REQUIRED DRIFT SIZE : <?= $partSpec['drift'] == '' ? '_______________________' : $partSpec['drift'];  ?></h3>
            <h3 style="padding-top: 2%;">DRIFT PASS OR FAIL : <?= $partSpec['drift'] == '' ? " " : "Pass" ?></h3>
       
            <div style="float: left;">
                <h3>MILL OPERATOR : <?= $millOp['name']?></h3>
            </div>
            <div style="clear: both;"></div>
        </div>
             
</div>
