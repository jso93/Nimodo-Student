<?php 
	class DocenteAulaDao{
		function __construct($connect){
			$this->connect = $connect;
		}
		
		function docentesConAula(){
			$stmt = $this->connect->prepare("CALL docenteConAulaRead()"); 
			$stmt ->execute();
			try{
				$data = $stmt->fetchAll();
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
	$docenteAulaDao = new DocenteAulaDao($connect);
	$docenteAulaDao->docentesConAula();
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($docenteAulaDao);
?>
