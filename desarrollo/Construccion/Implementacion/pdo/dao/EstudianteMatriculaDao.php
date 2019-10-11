<?php 
	class EstudianteMatriculaDao{
		function __construct($connect){
			$this->connect = $connect;
		}
		
		function estudiantesConMatricula(){
			$stmt = $this->connect->prepare("CALL estudianteConMatriculaRead()"); 
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
	$estudianteMatriculaDao = new EstudianteMatriculaDao($connect);
	$estudianteMatriculaDao->estudiantesConMatricula();
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($estudianteMatriculaDao);
?>
