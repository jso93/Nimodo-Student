<?php 
	class LoginDao{
		function __construct($connect){
			$this->connect = $connect;
		}

		function validarLogin($user,$password){
			$stmt = $this->connect->prepare("CALL validarLogin(?, ?)"); 
			$stmt->execute(array($user, $password));
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
	//RECUPERAMOS DATOS
	$user = $_POST['user'];
	$password = $_POST['password'];
	//CREAMOS OBJETO
	$loginDao = new LoginDao($connect);
	$loginDao->validarLogin($user,$password);
	//DESTRUIMOS VARIABLES DE MEMORIA
	unset($user,$password,$loginDao);
?>
