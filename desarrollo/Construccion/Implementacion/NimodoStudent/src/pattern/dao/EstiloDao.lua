local M = {}
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.estilo = {}
M.url = "http://i-soft.net/"--remote
M.url = config.ip
M.json=require 'json'
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

function M.ReadEstilo()
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EstiloDao.php", "POST", M.readEstiloRequest, M.params)
end

 function M.readEstiloRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.estilo = M.data
		end
		M.controller.readEstiloReceive(M.estilo)--enviamos datos al controlador
		M.estilo = {}--reseteamos estilo
	end
end

return M