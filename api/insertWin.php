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
				
		$name = $_GET['name'];
		$phone = $_GET['phone'];
		$motornum = $_GET['motornum'];
		$avatar = $_GET['avatar'];
		$winnum = $_GET['winnum'];
		
							
		$sql = "INSERT INTO `windata`(`id`, `name`, `phone`, `motornum`, `avatar`, `winnum`) VALUES (Null,'$name','$phone','$motornum','$avatar','$winnum')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Supachai";
   
}
	mysqli_close($link);
?>