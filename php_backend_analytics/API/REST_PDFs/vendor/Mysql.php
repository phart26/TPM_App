<?php

class Mysql
{
    public static $queryLog = true;
    public static $conn, $db, $logs;
    
    public function __construct()
    {
        $host = "localhost";
        $user = "root";
        $password = "anuj";
        $database = "final";
        
        self::$db = $database;
        // var_dump($host, $user, $password, $database);
        // die();
        self::$conn = mysqli_connect($host, $user, $password, $database);
        
        if (mysqli_connect_errno()) 
        {
            die("Failed to connect : " . mysqli_connect_error());
        }

        if (!self::$conn)
        {
            die("Failed to connect database");
        }
    }
    
    public function query($q)
    {
        self::$logs[] = $q;
        
        $result = mysqli_query(self::$conn, $q);
        
        if ( $result === false) 
        {
            die("mysqli_query error : " . mysqli_error(self::$conn));
        }
        
        return $result;
    }
    
    public function select($q)
    {
        $result = $this->query($q);
        
        $records = array();
        
        while($row = mysqli_fetch_assoc($result))
        {
            $records[] = $row;
        }
        
        return $records;
    }
    
    public function transactionBegin()
    {
        $this->query("SET AUTOCOMMIT=0");
        $this->query("START TRANSACTION");
    }
    
    public function transactionCommit()
    {
        $this->query("COMMIT");
    }
    
    public function transactionRollback()
    {
        $this->query("ROLLBACK");
    }
}
