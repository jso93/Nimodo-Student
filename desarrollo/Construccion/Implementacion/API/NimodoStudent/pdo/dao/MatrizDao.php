<?php 
	class MatrizDao{
		function __construct($connect){
			$this->connect = $connect;
		}
		public function getMatrizRead(){
			$stmt = $this->connect->prepare("CALL matrizRead()"); 
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
		
		public function getMatrizAreaRead($idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizAreaRead(?)"); 
			$stmt ->execute(array($idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}	
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){}
		}

		public function getMatrizCompetenciaAreaRead($area,$idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizCompetenciaAreaDocenteRead(?,?)"); 
			$stmt ->execute(array($area,$idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){echo "error";}
		}

		public function getMatrizCapacidadCompetenciaRead($area,$competencia,$idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizCapacidadCompetenciaRead(?,?,?)"); 
			$stmt ->execute(array($area,$competencia,$idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){echo "error";}
		}

		public function getMatrizIndicadorCapacidadRead($area,$competencia,$capacidad,$idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizDesempeñoCapacidadRead(?,?,?,?)"); 
			$stmt ->execute(array($area,$competencia,$capacidad,$idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){echo "error";}
		}


		public function getMatrizCompetenciaBimestreRead($idCompetencia,$idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizCompetenciaBimestreRead(?,?)"); 
			$stmt ->execute(array($idCompetencia,$idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){echo "error";}
		}

		public function getMatrizCompetenciaTiempoRead($idCompetencia,$idDocenteAula){
			$stmt = $this->connect->prepare("CALL matrizCompetenciaTiempoRead(?,?)"); 
			$stmt ->execute(array($idCompetencia,$idDocenteAula));
			try{
				$data = $stmt->fetchAll();
			if($data){
				echo json_encode($data);		
			}
			//DESTRUIMOS VARIABLES DE MEMORIA
			unset($stmt,$this->connect,$data);
			}catch(PDOException $e){echo "error";}
		}
	}
	//INIT PHP
	require '../config/db.php';
	//CREAMOS OBJETO
	$MatrizDao = new MatrizDao($connect);
	//RECUPERAMOS DATOS
	$function = $_POST['_function'];
	if($function == 'matrizRead'){
    	$MatrizDao->getMatrizRead();
    	unset($MatrizDao);
	}
	if($function == 'matrizAreaRead'){
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizAreaRead($idDocenteAula);
    	unset($idDocenteAula,$MatrizDao);
	}
	if($function == 'matrizCompetenciaAreaRead'){
		$area = $_POST['area'];
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizCompetenciaAreaRead($area,$idDocenteAula);
    	unset($area,$idDocenteAula,$MatrizDao);
	}
	if($function == 'matrizCapacidadCompetenciaRead'){
		$area = $_POST['area'];
		$competencia = $_POST['competencia'];
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizCapacidadCompetenciaRead($area,$competencia,$idDocenteAula);
    	unset($area,$competencia,$idDocenteAula,$MatrizDao);
	}
	if($function == 'matrizIndicadorCapacidadRead'){
		$area = $_POST['area'];
		$competencia = $_POST['competencia'];
		$capacidad = $_POST['capacidad'];
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizIndicadorCapacidadRead($area,$competencia,$capacidad,$idDocenteAula);
    	unset($area,$competencia,$capacidad,$idDocenteAula,$MatrizDao);
	}
	if($function == 'matrizCompetenciaBimestreRead'){
		$idCompetencia = $_POST['idCompetencia'];
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizCompetenciaBimestreRead($idCompetencia,$idDocenteAula);
    	unset($idCompetencia,$idDocenteAula,$MatrizDao);
	}
	if($function == 'matrizCompetenciaTiempoRead'){
		$idCompetencia = $_POST['idCompetencia'];
		$idDocenteAula = $_POST['idDocenteAula'];
    	$MatrizDao->getMatrizCompetenciaTiempoRead($idCompetencia,$idDocenteAula);
    	unset($idCompetencia,$idDocenteAula,$MatrizDao);
	}
?>