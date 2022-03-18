<?php
    $host= '172.26.0.161';
    $user = 'Ed Blackburne';
    $password = 'Acfd5xy4!';
    $ftpConn = ftp_connect($host);
    $login = ftp_login($ftpConn,$user,$password);
    // check connection
    if ((!$ftpConn) || (!$login)) {
     echo 'FTP connection has failed! Attempted to connect to '. $host. ' for user '.$user.'.';
    }else{
     echo 'FTP connection was a success.';
     $directory = ftp_nlist($ftpConn,'');
     echo ''.print_r($directory,true).'';
    }
    ftp_close($ftpConn);
?>