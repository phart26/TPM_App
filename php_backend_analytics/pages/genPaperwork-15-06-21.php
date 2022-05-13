#!/bin/bash
<?php
    include '/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/Connections/connectionTPM.php';

    use Dompdf\Dompdf;
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require 'PHPMailer/src/Exception.php';
    require 'PHPMailer/src/PHPMailer.php';
    require 'PHPMailer/src/SMTP.php';
?>

<?php
    

    $sql = 'SELECT * FROM orders_tbl WHERE gen_pdf = 1';

    //make query & get result
    if ($result= $conn -> query($sql)) {
            
    }

    $order = mysqli_fetch_array($result);

        $job = $order['job'];
        
        if($job != ''){

            // set generate pdf back to 0 in db
            $sql = "UPDATE orders_tbl SET gen_pdf = 0 WHERE job = '$job' ";
                
            if ($result= $conn -> query($sql)) {
                    
            }

            ob_start();

                    
            include 'DBForReports.php';

            require_once 'overviewSheet_pdf.php';
            require_once 'first_part_drift_confirmation_pdf.php';
            require_once 'welding_pdf.php';
            require_once '240518cutoff_station_check_sheet_pdf.php';
            require_once '240518inspection_rpt_pdf.php';

            if($tubes[0]['end1_read1'] != 0){
                require_once '240518ring_station_check_list_pdf.php';
            }

            if(!empty($rings)){
                require_once '240518geo_form_ring_inspection_pdf.php';
            }

            if($tubes[0]['ringA'] != ""){
                require_once 'geo_form_ring_weld_pdf.php';
            }

            if($tubes[0]['ring_num1'] != ""){
                require_once 'final_inspection_geo_form_pdf.php';
            }

            // require_once 'worksheet_pdf.php';
            require_once 'dompdf/autoload.inc.php';
            
            $fileName = strval($job)."_forms.pdf";


            $html = ob_get_clean();


            // instantiate and use the dompdf class
            $dompdf = new Dompdf();
            $dompdf->set_option('isHtml5ParserEnabled', true);
            $dompdf->loadHtml($html);

            // (Optional) Setup the paper size and orientation
            $dompdf->setPaper('A4', 'landscape');

            // Render the HTML as PDF
            $dompdf->render();

            // Output the generated PDF to Browser
            $output = $dompdf->output();


            file_put_contents('/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/paperwork/'.$job.'_forms.pdf', $output);
                    
            //define link and route
            $route = "http://198.71.55.128/page/paperwork/".$job."_forms.pdf";
            $link = $job.'_forms.pdf';

            // generating email for pdf
            $mail = new PHPMailer(true);

            try {
                //Server settings
                $mail->isSMTP();                                            //Send using SMTP
                $mail->Host       = 'smtp-relay.sendinblue.com';                     //Set the SMTP server to send through
                $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
                $mail->Username   = 'tpmltd.paperwork@gmail.com';                     //SMTP username
                $mail->Password   = 'GRgWQXfq0zrpBaZh';                               //SMTP password
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
                $mail->Port       = 465;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

                //Recipients
                $mail->setFrom('tpmltd.paperwork@gmail.com', 'TPM Paperwork');
                $mail->addAddress('kayla@tpmltd.com', 'Kayla Mills');     //Add a recipient
                $mail->addAddress('jennifer@tpmltd.com', 'Jennifer Anastasio');     //Add a recipient
                // $mail->addAddress('prestonhart13@gmail.com', 'Preston Hart');
                //Attachments
                // $mail->addStringAttachment($output, $fileName);         //Add attachments

                //Content
                $mail->isHTML(true);                                  //Set email format to HTML
                $mail->Subject = 'Paperwork for job: '.$job;
                $mail->Body    = '<a href ="'.$route.'">'.$link.'</a>'; //defining link in body of email

                $mail->send();
                echo 'Message has been sent';


            } catch (Exception $e) {
                echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
            }
        }

?>

<?php

    function getCustomer($cust_id){
        include '/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/Connections/connectionTPM.php';
        $sqls = "SELECT * FROM cust_tbl WHERE cust_id = '".$cust_id."'";

        //make query & get result
        if ($results= $conn -> query($sqls)) {
                                
        }
                                
        //fetch resulting rows as an array
        $orderACTS = mysqli_fetch_assoc($results);

        return $orderACTS['customer'];
    }
?>