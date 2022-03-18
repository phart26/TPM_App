
<!-- Resets number of welded and inspected tubes for the day back to zero-->

<?php
    include '../Connections/connection.php';
?>

<?php
    $sql= 'UPDATE tube_stations SET Welding_Tod = 0, Inspection_Tod = 0';
    if ($result= $conn -> query($sql)) {
	
	}
?>