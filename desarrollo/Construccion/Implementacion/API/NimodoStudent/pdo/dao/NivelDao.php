<?php 
	class NivelDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function Read(){
			$stmt = $this->connect->prepare("CALL nivelRead()"); 
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
	$nivelDao = new NivelDao($connect);
	$nivelDao->Read();
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($nivelDao);
?>