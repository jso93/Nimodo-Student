local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local
M.idevaluacion_adaptativa = nil
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

function M.CreateEvaluacionAdaptativa(_idcompetencia,_idperiodo,_idarea,_idestudiante_matricula,_iddocente_aula)
	print(_idcompetencia..' '.._idperiodo..' '.._idarea..' '.._idestudiante_matricula..' '.._iddocente_aula)
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = 'idcompetencia='.._idcompetencia..'&idperiodo='.._idperiodo..'&idarea='.._idarea..'&idestudiante_matricula='.._idestudiante_matricula..'&iddocente_aula='.._iddocente_aula
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EvaluacionAdaptativaDao.php", "POST", M.CreateEvaluacionAdaptativaRequest, M.params)
end

 function M.CreateEvaluacionAdaptativaRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = event.response 
		if M.data ~= nil then
			M.idevaluacion_adaptativa = M.data
		end
		M.controller.CreateEvaluacionAdaptativaReceive(M.idevaluacion_adaptativa)--enviamos datos al controlador
		M.idevaluacion_adaptativa = nil--restblecemos id
	end
end

return M