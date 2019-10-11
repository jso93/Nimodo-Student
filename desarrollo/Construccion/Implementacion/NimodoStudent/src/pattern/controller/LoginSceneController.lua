local M = {}
--MODULOS EXTERNOS
M.loginDao = require 'src.pattern.dao.LoginDao'
M.estudianteMatriculaDao = require 'src.pattern.dao.EstudianteMatriculaDao'
M.docenteAulaDao = require 'src.pattern.dao.DocenteAulaDao'
--VARIABLES
M.estudiante,M.docente = {},{}
--FUNCIONES
function M.new(_scene)
	M.scene = _scene 
	M.scene.tmp1 = timer.performWithDelay( 500,M.animacion,0 )
end

function M.initController()
	M.scene.btnLogin:addEventListener( 'touch', M.btnLoginOnClick )	
end

--FUNCIONES DE EVENTOS
function M.btnLoginOnClick( event )
	if event.phase == 'ended' then
		if M.scene.txtUser.text~='' and M.scene.txtPassword.text~='' then 
			M.loginDao.new(M)
			M.loginDao.validarLogin(M.scene.txtUser.text,M.scene.txtPassword.text)--validamos login
		else
			native.showAlert('Nimodo', 'Campos vacíos', {'OK'}, function()end)	
		end  
	end	
end

--VALIDAMOS LOGIN
function M.validarLoginReceive(_estudiante)
	if _estudiante.dni~=nil then 
		M.estudianteMatriculaDao.new(M)
		M.estudianteMatriculaDao.estudianteMatricula(_estudiante.dni)--verificamos si esta matriculado el estudiante
	else
		native.showAlert('Nimodo', 'El usuario no existe, o contraseña incorrecta!', {'OK'}, function()end)	
	end
end

--VERIFICAMOS MATRICULA DEL ESTUDIANTE
function M.estudianteMatriculaReceive(_estudiante)
	if _estudiante.idaula~=nil then 
		M.estudiante = _estudiante
		M.docenteAulaDao.new(M)
		M.docenteAulaDao.docenteAula(M.estudiante.grado,M.estudiante.seccion)--verificamos si existe docente asignado al aula
	else
		native.showAlert('Nimodo', 'No estas matriculado!', {'OK'}, function()end)	
	end
end

--VERIFICAMOS ASIGNACION DEL DOCENTE A UNA AULA
 function M.docenteAulaReceive(_docente)
	if _docente.iddocente_aula~=nil then 
		M.docente = _docente--DATOS DEL DOCENTE
		local _params = {--enviamos como parametros datos del estudiante matriculado y del docente asignado a una aula
		    estudiante = M.estudiante,
		    docente = M.docente
		}
		--ELIMINAMOS TEMPORIZADOR
		timer.pause( M.scene.tmp1 )
		timer.cancel( M.scene.tmp1 )
		M.scene.tmp1 = nil 
		--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
		package.loaded['src.pattern.dao.LoginDao'] = nil
		package.loaded['src.pattern.dao.EstudianteMatriculaDao'] = nil
		package.loaded['src.pattern.dao.DocenteAulaDao'] = nil
		package.loaded['src.pattern.controller.LoginSceneController'] = nil--THIS CONTROLLER
		--PASAMOS A LA SIGUIENTE ESCENA
		M.scene.composer.gotoScene( "src.pattern.view.PrincipalScene", { effect="fromRight", time=500, params=_params } )
	else
		native.showAlert('Nimodo', 'No hay docente asignado al aula!', {'OK'}, function()end)	
	end		
end

--ANIMACION BUTTON
function M.animacion( )
	if M.estado then 
		transition.to( M.scene.btnLogin,{time = 500,xScale = 1.5,yScale = 1.5} )
		M.estado = false
	else
		transition.to( M.scene.btnLogin,{time = 500,xScale = 1,yScale = 1} )
		M.estado = true
	end
end

return M

