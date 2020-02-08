local M = {}
--local main = require 'main'
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.url = config.ip--local 192.168.137.1  192.168.1.28 
M.json=require 'json'
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
end
function M.validarLogin( _user, _password)
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = 'user='.._user..'&password='.._password
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/LoginDao.php", "POST", M.validarLoginRequest, M.params)
end

function M.validarLoginRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet'..event.response, {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			for i=1,#M.data do
				if M.data[i].rol == 'Ingeniero' or M.data[i].rol == 'Director' or M.data[i].rol == 'Docente' then 
					native.showAlert('Nimodo', 'Usted no es estudiante, porfavor ingrese desde la aplicación de escritorio!', {'ok'}, function(event)end)		
					break
				else
					M.estudiante = M.data[i]
				end
			end	
		end
		M.controller.validarLoginReceive(M.estudiante)--enviamos datos al controlador
		M.estudiante = {}--reseteamos estudiante
	end
end
----------------------------------------------------------------------------------------------------------------------------------
function M.estudianteMatricula(_dniEstudiante)
	M.dniEstudiante = _dniEstudiante--RECIBIMOS DNI DEL ESTUDIANTE
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EstudianteMatriculaDao.php", "POST", M.estudianteMatriculaRequest, M.params)
end

function M.estudianteMatriculaRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			for i=1,#M.data do
				if M.data[i].dni == M.dniEstudiante then 
					M.estudiante = M.data[i]
				end
			end
		end
		M.controller.estudianteMatriculaReceive(M.estudiante)--enviamos datos al controlador
		M.estudiante = {}--reseteamos estudiante
	end
end
-----------------------------------------------------------------------------------------------------------------------------------
function M.docenteAula(_grado, _seccion) 
	M.grado,M.seccion = _grado,_seccion--RECIBIMOS GRADO Y SECCION
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/DocenteAulaDao.php", "POST", M.docenteAulaRequest, M.params)
end

 function M.docenteAulaRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			for i=1,#M.data do
				if M.data[i].grado == M.grado and M.data[i].seccion == M.seccion then
					M.docente = M.data[i]
				end
			end
			M.controller.docenteAulaReceive(M.docente)--enviamos datos al controlador
			M.docente = {}--reseteamos docente
		end
	end
end
--CONSULTA AREAS----------------
function M.matrizAreaRead(_idDocenteAula)
	M._function = 'matrizAreaRead'
	M.body  = '_function='..M._function..'&idDocenteAula='.._idDocenteAula
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizAreaReadRequest, M.params)
end

function M.matrizAreaReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaAreas = M.data
		end
		M.controller.matrizAreaReadReceive(M.listaAreas)--enviamos datos al controlador
		M.listaAreas = {}--reseteamos areas
	end
end
--CONSULTA PERIODOS
function M.periodoRead( )
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/PeriodoDao.php", "POST", M.periodoReadRequest, M.params)
end

function M.periodoReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaPeriodo = M.data
		end
		M.controller.periodoReadReceive(M.listaPeriodo)--enviamos datos al controlador
		M.listaPeriodo = {}--reseteamos listaPeriodo
	end
end
return M