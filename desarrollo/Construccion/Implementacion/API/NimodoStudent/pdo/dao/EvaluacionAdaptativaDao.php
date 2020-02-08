<?php 
	class EvaluacionAdaptativaDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function Create($idcompetencia,$idperiodo,$idarea,$idestudiante_matricula,$iddocente_aula){
			$stmt = $this->connect->prepare("CALL evaluacionAdaptativaCreate(?,?,?,?,?,@id)");
			try {
  				$stmt->execute(array($idcompetencia,$idperiodo,$idarea,$idestudiante_matricula,$iddocente_aula));
				$id =  $this->connect->query("SELECT @id AS id")->fetch(PDO::FETCH_ASSOC);
		        if ($id) {
		            echo $id['id'];//retornamos ultimo id insertado
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
	//RECUPERMOS
	$idcompetencia =$_POST['idcompetencia'];
	$idperiodo =$_POST['idperiodo'];
	$idarea =$_POST['idarea'];
	$idestudiante_matricula =$_POST['idestudiante_matricula'];
	$iddocente_aula =$_POST['iddocente_aula'];
	//CREAMOS OBJETO
	$evaluacionAdaptativaDao = new EvaluacionAdaptativaDao($connect);
	$evaluacionAdaptativaDao->Create($idcompetencia,$idperiodo,$idarea,$idestudiante_matricula,$iddocente_aula);
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($idcompetencia,$idperiodo,$idarea,$idestudiante_matricula,$iddocente_aula,$evaluacionAdaptativaDao);
?>