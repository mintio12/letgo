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
				
		$winnum = $_GET['winnum'];

		$result = mysqli_query($link, "SELECT * FROM qwin");
		$num=mysqli_num_rows($result);


		if ($result) {

			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;


			}	// while
			echo $num;
			// echo json_encode($output);

		} //if

	} else echo "Welcome Supachai";	// if2
   
}	// if1


	mysqli_close($link);
?>