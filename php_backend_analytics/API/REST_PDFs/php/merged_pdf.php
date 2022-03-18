<?php
$pagess= $_GET["pages"];
$pages = explode(",", $pagess);

ob_start();

if(isset($_GET['from']))
    $from = $_GET['from'];
else
    $from = 1;

if(isset($_GET['to']))
    $too = $_GET['to'];
else
    $too = 20;

$total = $too - $from;
$no_of_pages = ceil($total/25);
$pages_count = array();
for ($i = 1; $i <= $no_of_pages; $i++)
{
    array_push($pages_count, $i);
}
?>

<html>
    <head>
        <title>TPM Tube Mill Log</title>
        <style>
            *{
                padding : 0;
            }
            
            @page 
            {
                margin : 40px 60px 100px 60px
            }
            
            body
            {
                font-size: 12px;
                font-family: 'Helvetica'
            }
            
            footer 
            { 
                position: fixed; 
                bottom: -80px; 
                left: 0px; 
                right: 0px;
                height: 80px;
                width: 100%;
                font-size: 11px;
                color : #9E9E9E;
            }
            
            table
            {
                width : 100%;
            }
            
            .margin-l-5{ margin-left: 5px }
            .margin-l-10{ margin-left: 10px }
            .margin-l-15{ margin-left: 15px }
            .margin-l-20{ margin-left: 20px }
            
            .margin-b-5{ margin-bottom: 5px }
            .margin-b-10{ margin-bottom: 10px }
            .margin-b-15{ margin-bottom: 15px }
            .margin-b-20{ margin-bottom: 20px }
            
            .pad-10{padding : 10px;}
            .pad-5{padding : 5px;}
            
            .pad-l-5{ padding-left: 5px }
            .pad-l-10{ padding-left: 10px }
            .pad-l-15{ padding-left: 15px }
            .pad-l-20{ padding-left: 20px }
            
            .pad-b-5{ padding-bottom: 5px }
            .pad-b-10{ padding-bottom: 10px }
            .pad-b-15{ padding-bottom: 15px }
            .pad-b-20{ padding-bottom: 20px }

            .pad-t-5{ padding-top: 5px }
            .pad-t-10{ padding-top: 10px }
            .pad-t-15{ padding-top: 15px }
            .pad-t-20{ padding-top: 20px }
            
            
            .border {border : 1px solid #000}
            
            .box
            {
                border : 1px solid #000;
                padding : 3px 0 3px 10px;                
            }
            .summary-table 
            {
                border-collapse: collapse;
            }
            
            .summary-table td
            {
                padding-left : 5px;
            }
            
            .summary-table tbody td 
            {
                border-top: 1px solid #000;
                border-bottom: 1px solid #000;
            }
            
            .summary-table tbody tr td:first-child
            {
                border-left: 1px solid #000;
            }
            
            .summary-table tbody tr td:last-child
            {
                border-right: 1px solid #000;
            }
            .pagebreak{
            	page-break-before: always;
            }

            .pagebreak:first-child{
            	page-break-before: avoid;
            }
        </style>
    </head>
    
    <body>      
        
<?php


	# code...
	
	if (in_array("tube_mill_log", $pages)) {

	// if($pages[$i]== 'tube_mill_log'){

		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/tube_mill_log_pdf.php';

	}
	if (in_array("tube_mill_setup", $pages)) {
	// if ($pages[$i] == 'tube_mill_setup') {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/tube_mill_setup_pdf.php';

		# code...
	}
	if (in_array("first_part_drift_confirmation", $pages)) {
	// if ($pages[$i] == 'tube_mill_setup') {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/first_part_drift_confirmation_pdf.php';

		# code...
	}
	if (in_array("welding_station_check_list", $pages)) {
	// if ($pages[$i] == 'welding_station_check_list') {

		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/welding_station_check_list_pdf.php';
		# code...
	}
	if (in_array("worksheet", $pages)) {
	// if ($pages[$i] == 'worksheet') {

		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;
		$header['tube_heat_number'] = '';
		$header['ring_heat_number'] = '';

		$q = "SELECT 
		       steel_tbl.heat
		    FROM   
		        steel_tbl 
		        INNER JOIN (orders_tbl 
		                   INNER JOIN coil_tbl 
		                           ON orders_tbl.job = coil_tbl.job) 
		               ON steel_tbl.work = coil_tbl.work 
		    WHERE
		        orders_tbl.job = '$job'";

		$temp = $mysql->select($q);

		if ($temp)
		{
		    $header['tube_heat_number'] = $temp[0]['heat'];
		}



		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/worksheet_pdf.php';
		# code...
	}
	if (in_array("dp_inspection", $pages)) {
	// if ($pages[$i] == 'dp_inspection') {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);


		require_once BASE_PATH . 'php/dp_inspection_pdf.php';


		# code...
	}
	if (in_array("cutoff_station_check_sheet", $pages)) {

		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/cutoff_station_check_sheet_pdf.php';

	}
	if (in_array("inspection_rpt", $pages)) {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once dirname(__FILE__) . '/inspection_rpt_pdf.php';

	}

	if (in_array("final_inspection_geo_form", $pages)) {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once dirname(__FILE__) . '/final_inspection_geo_form_pdf.php';

	}
	
	
	if (in_array("ring_station_check_list", $pages)) {

		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/ring_station_check_list_pdf.php';

	}
	if (in_array("geo_form_ring_inspection", $pages)) {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/geo_form_ring_inspection_pdf.php';

	}
	if (in_array("geo_form_ring_concentric_inspection", $pages)) {
		require_once BASE_PATH . 'php/report_data.php';

		if (empty($records))
		{
		    die("No data found");
		}

		$header = $records;

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/geo_form_ring_concentric_inspection_pdf.php';

	}
	if (in_array("alloc", $pages)) {
		$job = $_GET['job'];

		$mysql = new Mysql();

		$q = "SELECT 
		       order_specs.job, 
		       order_specs.customer, 
		       order_specs.po as po_number, 
		       order_specs.item as line_item
		    FROM  
		        order_specs 
		    WHERE 
		        order_specs.job = '$job'; ";

		$header = $mysql->select($q);

		if (empty($header))
		{
		    die("No data found");
		}

		$header = $header[0];


		$query = "SELECT DISTINCT coil_tbl.coil_no,
		            coil_tbl.weight,
		            steel_tbl.material,
		            coil_tbl.work,
		            steel_tbl.gage,
		            steel_tbl.pattern,
		            steel_tbl.holes,
		            steel_tbl.centers,
		            steel_tbl.width,
		            steel_tbl.heat,
		            coil_tbl.date_received,
		            coil_tbl.allocated,
		            coil_tbl.job,
		            coil_tbl.Cycles
		FROM coil_tbl
		INNER JOIN steel_tbl ON coil_tbl.work = steel_tbl.work
		INNER JOIN part_tbl ON part_tbl.pattern = steel_tbl.pattern
		                   AND part_tbl.centers = steel_tbl.centers
		                   AND part_tbl.holes = steel_tbl.holes
		                   AND part_tbl.type = steel_tbl.material
		                   AND part_tbl.gage = steel_tbl.gage
		WHERE coil_tbl.job='$job' AND coil_tbl.allocated ='1'
		ORDER BY coil_tbl.job, coil_tbl.coil_no";

		$records = $mysql->select($query);


		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/alloc_pdf.php';

	}
	if (in_array("alloc_mesh", $pages)) {

		$job = $_GET['job'];

		$mysql = new Mysql();

		$q = "SELECT 
		       order_specs.job, 
		       order_specs.customer, 
		       order_specs.po as po_number, 
		       part_specs.part as part_no, 
		       part_specs.part as part,
		       order_specs.item as line_item, 
		       part_specs.layer_1_mesh
		FROM  
		    order_specs 
		    INNER JOIN part_specs  ON order_specs.part = part_specs.part    
		WHERE 
		    order_specs.job = '$job' ";

		$header = $mysql->select($q);

		if (empty($header))
		{
		    die("No data found");
		}

		$header = $header[0];

		$mesh = $header['layer_1_mesh'];
		        
		$query = "
		    SELECT     
		        orders_tbl.job, 
		        orders_tbl.po, 
		        orders_tbl.item, 
		        mesh_tbl.mesh_no, 
		        mesh_tbl.width, 
		        mesh_tbl.length, 
		        mesh_tbl.heat, 
		        mesh_tbl.mesh, 
		        mesh_tbl.type 
		FROM       
		    orders_tbl 
		    INNER JOIN mesh_tbl ON orders_tbl.job = mesh_tbl.tpm_job 
		WHERE     
		    orders_tbl.job = '$job'";

		$records = $mysql->select( $query);

		$group_records = array();

		foreach($records as $record)
		{
		    $group_records[$record['mesh']][] = $record;
		}

		$header["print_date"] = date(DATE_FORMAT);

		require_once BASE_PATH . 'php/alloc_mesh_pdf.php';

	}
?>

</body>
</html>
<?php


$html = ob_get_clean();
//echo htmlspecialchars($html); exit;
require_once BASE_PATH . 'vendor/dompdf/autoload.inc.php';

$dompdf = new Dompdf\Dompdf();
$dompdf->set_paper('A4', 'portrait');

$dompdf->loadHtml($html);
$dompdf->render();

$filename =  date('d_m_Y_H_i') . ".pdf";
$dompdf->stream($filename, array('Attachment'=>0));




