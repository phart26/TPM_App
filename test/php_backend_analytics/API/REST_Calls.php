<?php

    require_once 'mergeJSON.php';
    
    
    function processRequest($pages, $method, $job){
         
        //$path = $_GET['path'];
        
        switch ($method) {
        case 'PUT':  
            break;
        case 'POST':  
            break;
        case 'GET':
            /*if ($path->OrderId) {
                $response = getForm($path->formNum);
            } elseif($path->startRec) {
                $response = getForms($path->startRec, $paths->endRec);
            } else{*/
                
                $response = getAllForms($pages, $job);
            //}
            break;
        default:
            $response = notFound();  
            break;
        }

        return $response;
    }


    function getAllForms($pages, $job){
        

        $response['status_code_header'] = 'HTTP/1.1 200 OK';
        $response['body'] = merge($pages, $job); //JSON object from mergeJSON

        return $response;
    }

    function notFound(){
        echo 'not found';
    }


?>