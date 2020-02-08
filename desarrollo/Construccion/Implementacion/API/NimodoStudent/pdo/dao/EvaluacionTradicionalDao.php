<?php 
	class EvaluacionTradicionalDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function getFechas($dni,$periodo,$area){
			$stmt = $this->connect->prepare("CALL evaluacionTradicionalFechaRead(?,?,?)"); 
			$stmt->execute(array($dni, $periodo, $area));
			try{
				$data = $stmt->fetchAll();;
			if($data){
				echo json_encode($data);		
			}	
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){}	
		}

		function getEvaluacionTradicionalEstudiante($dni,$periodo,$area,$fecha){
			$stmt = $this->connect->prepare("CALL evaluacionTradicionalEstudianteRead(?,?,?,?)"); 
			$stmt->execute(array($dni, $periodo, $area, $fecha));
			try{
				$data = $stmt->fetchAll();;
			if($data){
				echo json_encode($data);		
			}	
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){}	
		}

		function evaluacionTradicionalCalificacionEstudianteRead($dni,$periodo,$area,$fecha){
			$stmt = $this->connect->prepare("CALL evaluacionTradicionalCalificacionEstudianteRead(?,?,?,?)"); 
			$stmt->execute(array($dni, $periodo, $area, $fecha));
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
	$evaluacionTradicionalDao = new EvaluacionTradicionalDao($connect);
	//RECUPERAMOS DATOS
	$function = $_POST['_function'];
	if($function == 'getFechas'){
		$dni = $_POST['dni'];
		$periodo = $_POST['periodo'];
		$area = $_POST['area'];
		$evaluacionTradicionalDao->getFechas($dni,$periodo,$area);
		//DESTRUIMOS VARIABLES DE MEMORIA
		unset($dni,$periodo,$area,$evaluacionTradicionalDao);
	}
	
	if($function == 'getEvaluacionTradicionalEstudiante'){
		$dni = $_POST['dni'];
		$periodo = $_POST['periodo'];
		$area = $_POST['area'];
		$fecha = $_POST['fecha'];
		$evaluacionTradicionalDao->getEvaluacionTradicionalEstudiante($dni,$periodo,$area,$fecha);
		//DESTRUIMOS VARIABLES DE MEMORIA
		unset($dni,$periodo,$area,$fecha,$evaluacionTradicionalDao);
	}
	
	if($function == 'evaluacionTradicionalCalificacionEstudianteRead'){
		$dni = $_POST['dni'];
		$periodo = $_POST['periodo'];
		$area = $_POST['area'];
		$fecha = $_POST['fecha'];
		$evaluacionTradicionalDao->evaluacionTradicionalCalificacionEstudianteRead($dni,$periodo,$area,$fecha);
		//DESTRUIMOS VARIABLES DE MEMORIA
		unset($dni,$periodo,$area,$fecha,$evaluacionTradicionalDao);
	}
?>