local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.estudiante = {}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local 
M.json=require 'json'
M.dniEstudiante = nil
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
end

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
return M