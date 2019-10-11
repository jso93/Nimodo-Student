local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.listaPregunta = {}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local
M.json=require 'json'

function M.new(_controller)
	M.controller = _controller
end

function M.getPreguntas(_periodo,_idDocenteAula,_competencia)
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = 'periodo='.._periodo..'&iddocente_aula='.._idDocenteAula..'&competencia='.._competencia
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EvaluacionAdaptativaConfigDao.php", "POST", M.getPreguntasRequest, M.params)
end

function M.getPreguntasRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaPregunta = M.data
		end
		M.controller.getPreguntasReceive(M.listaPregunta)--enviamos datos al controlador
		M.listaPregunta = {}--reseteamos listaPregunta
	end
end
return M