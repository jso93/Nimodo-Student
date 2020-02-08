<?php 
	class EvaluacionAdaptativaConfigDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function getPreguntas($periodo,$iddocente_aula,$competencia){
			$stmt = $this->connect->prepare("CALL evaluacionAdaptativaPreguntaRead(?, ?, ?)"); 
			$stmt->execute(array($periodo, $iddocente_aula,$competencia));
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
	//RECUPERAMOS DATOS
	$periodo = $_POST['periodo'];
	$iddocente_aula = $_POST['iddocente_aula'];
	$competencia = $_POST['competencia'];
	//CREAMOS OBJETO
	$evaluacionAdaptativaConfigDao = new EvaluacionAdaptativaConfigDao($connect);
	$evaluacionAdaptativaConfigDao->getPreguntas($periodo,$iddocente_aula,$competencia);
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($periodo,$iddocente_aula,$competencia,$evaluacionAdaptativaConfigDao);
?>