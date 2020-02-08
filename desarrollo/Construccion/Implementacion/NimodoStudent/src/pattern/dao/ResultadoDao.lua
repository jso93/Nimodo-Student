local M = {}
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.url = "http://i-soft.net/"--remote
M.url = config.ip
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

function M.CreateResultado(_idevaluacion_adaptativa,_idalternativa,_conocimiento_aposteriori,_tiempo)
	if _idevaluacion_adaptativa~=nil and _idalternativa~=nil and _conocimiento_aposteriori~=nil and _tiempo~=nil then
		M.headers["Content-Type"] = "application/x-www-form-urlencoded"
		M.headers["Accept-Language"] = "en-US"
		M.body  = 'idevaluacion_adaptativa='.._idevaluacion_adaptativa..'&idalternativa='.._idalternativa..'&conocimiento_aposteriori='.._conocimiento_aposteriori..'&tiempo='.._tiempo
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/ResultadoDao.php", "POST", M.createResultadoRequest, M.params)
	end
end

 function M.createResultadoRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = event.response
		if M.data ~= nil then
			print('RESULT:'..M.data)
		end
	end
end

return M