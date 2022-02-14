<?php

$source = '/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/source.txt';

// Store the path of destination file
$destination = '/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/paperwork/d1.txt';

//
//
// directory
if( !copy($source, $destination) ) {
	echo "File can't be copied! \n";
}
else {
	echo "File has been copied! \n";
}

file_put_contents("/opt/bitnami/apache2/htdocs/TPM-master/TPM_Forms/pages/paperwork/d1.txt","Testing file content");
?>

