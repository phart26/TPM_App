<?php
    error_reporting(E_ALL | E_STRICT);
    ini_set('display_errors', 1);
    require_once 'dompdf/autoload.inc.php';
    use Dompdf\Dompdf;
    include '../Connections/connectionTPM.php';
?>
<?php
    $job = 7845;
    ob_start();
?>

<?php
        

        //require('timeStamp.php');
        require_once 'DBForReports.php';
        require_once '240518cutoff_station_check_sheet_pdf.php';
        // require_once '../API/REST_PDfs/php/final_inspection_geo_form_pdf.php';
        // require_once '../API/REST_PDfs/php/240518inspection_rpt_pdf.php';
        // require_once '../API/REST_PDfs/php/240518ring_station_check_list_pdf.php';
        // require_once '../API/REST_PDfs/php/welding_pdf.php';
        // require_once '../API/REST_PDfs/php/first_part_drift_confirmation_pdf.php';
        // require_once '../API/REST_PDfs/php/240518geo_form_ring_inspection_pdf.php';
        // require_once '../API/REST_PDfs/php/worksheet_pdf.php';
        

?>
<?php
        $fileName = strVal($job)."_forms.pdf";
        

        $html = ob_get_clean();
        

        // instantiate and use the dompdf class
        $dompdf = new Dompdf();
        $dompdf->set_option('isHtml5ParserEnabled', true);
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->loadHtml($html);

        

        // Render the HTML as PDF
        $dompdf->render();

        // Output the generated PDF to Browser
        $output = $dompdf->output();
        $f;
$l;
if(headers_sent($f,$l))
{
    echo $f,'<br/>',$l,'<br/>';
    die('now detect line');
}
        $dompdf -> stream($fileName);
?>