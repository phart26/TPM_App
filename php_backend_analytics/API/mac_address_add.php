<?php
// require_once("app/includes/db.php");

$hostname = 'localhost';
$db_name = 'demo_tpm';
$db_username = 'root';
$db_password = 'anuj';
$db = new mysqli($hostname, $db_username, $db_password, $db_name);


if(isset($_GET['device']) && isset($_GET['MAC_address'])){

    $device = $_GET['device'];
    $MAC_address = $_GET['MAC_address'];

    $query = "select * from mac_add_tbl where device ='".$device."'";
    $result = mysqli_query($db , $query);
    $rowcount=mysqli_num_rows($result);
    $data=array();
    if($rowcount == 0){
        $str = "INSERT INTO `mac_add_tbl`(`device`, `MAC_address`) VALUES ('".$device."','".$MAC_address."')";
        $result_work = mysqli_query($db , $str);
    
        if($result_work)
        {
            $data=array(
                'result' => 1,
                'message' => 'Saved Successfully!'
            );
            echo json_encode($data);
            //echo "Saved Successfully!";
        }else{
            $data=array(
                'result' => 0,
                'message' => 'Error In Saved Data!'
            );
            echo json_encode($data);
        }
    }else{
            $str = "UPDATE `mac_add_tbl` SET `MAC_address`='".$MAC_address."' WHERE device='".$device."'";
            $result_work = mysqli_query($db , $str);
        
            if($result_work)
            {
                $data=array(
                    'result' => 2,
                    'message' => 'Update Successfully!'
                );
                echo json_encode($data);
                //echo "Update Successfully!";
            }else{
                $data=array(
                    'result' => 0,
                    'message' => 'Error In Update Data!'
                );
                echo json_encode($data);
            }
    }
   
}else{
   
        $str = "SELECT * FROM `mac_add_tbl` where device LIKE '%mill_%' OR device = 'niagara' OR device = 'rouselle'";
        $result_work = mysqli_query($db , $str);
        
        $data=array();

        while($row = mysqli_fetch_assoc($result_work)) {
        //    echo "Name: " . $row["name"]. "<br>";
            $list =array(
                'device' => $row['device'],
                'MAC_address' => $row['MAC_address'],
            );
            array_push($data,$list);
         }
        echo json_encode($data);
    
}
?>