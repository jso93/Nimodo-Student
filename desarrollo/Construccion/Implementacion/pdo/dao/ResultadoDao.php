<?php 
	class ResultadoDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function Create($idevaluacion_adaptativa,$idalternativa,$conocimiento_aposteriori,$tiempo){
			$stmt = $this->connect->prepare("CALL resultadoCreate(?,?,?,?)");
			$res = $stmt->execute(array($idevaluacion_adaptativa,$idalternativa,$conocimiento_aposteriori,$tiempo));
			try {
				if($res){
					echo 'registro_exitoso!';
				}else{
					echo 'registro_fallado!';
				}
		        //DESTRUIMOS VARIABLES DE MEMORIA
				unset($stmt,$this->connect,$id);
		   	}
			catch(PDOException $e){
				echo 'error';
			}
		}
	}
	//INIT PHP
	require '../config/db.php';
	//RECUPERAMOS
	$idevaluacion_adaptativa =$_POST['idevaluacion_adaptativa'];
	$idalternativa =$_POST['idalternativa'];
	$conocimiento_aposteriori =$_POST['conocimiento_aposteriori'];
	$tiempo =$_POST['tiempo'];
	//CREAMOS OBJETO
	$evaluacionAdaptativaDao = new ResultadoDao($connect);
	$evaluacionAdaptativaDao->Create($idevaluacion_adaptativa,$idalternativa,$conocimiento_aposteriori,$tiempo);
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($idevaluacion_adaptativa,$idalternativa,$conocimiento_aposteriori,$tiempo,$evaluacionAdaptativaDao);
?>