<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
		$listid = $_GET['listid'];		
		$avatar = $_GET['avatar'];
		$name = $_GET['name'];
		$phone = $_GET['phone'];
		$des = $_GET['des'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		
		
							
		$sql = "INSERT INTO `localtion`(`id`,`listid`, `avatar`, `name`,`phone`,`des`, `lat`, `lng`) VALUES (Null,'$listid','$avatar','$name','$phone','$des','$lat','$lng')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>