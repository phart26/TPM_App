<?php
    include '../Connections/connectionTPM.php';

    if(isset($_GET['token']) && isset($_GET['station'])){

       $sql = "UPDATE mill_tbl SET token = '".$_GET['token']."' WHERE station = '".$_GET['station']."'";

        if ($result= $conn -> query($sql)) {

            echo "database updated";

        } 
    }

    if(isset($_GET['token']) && (!isset($_GET['station']))){

        $sql = "SELECT * FROM mill_tbl WHERE token = '".$_GET['token']."'";

        if ($result= $conn -> query($sql)) {

        } 
        $station = mysqli_fetch_assoc($result);

        echo $station['station'];
    }


?>