<?php 
	class PeriodoDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function Read(){
			$stmt = $this->connect->prepare("CALL periodoRead()"); 
			$stmt->execute();
			try{
				$data = $stmt->fetchAll();;
			if($data){
				echo json_encode($data);		
			}	
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){}	
		}
	}
	//INIT PHP
	require '../config/db.php';
	//CREAMOS OBJETO
	$periodoDao = new PeriodoDao($connect);
	$periodoDao->Read();
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($periodoDao);
?>