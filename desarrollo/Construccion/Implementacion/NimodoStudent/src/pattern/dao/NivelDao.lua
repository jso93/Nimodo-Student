local M = {}
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.nivel = {}
M.url = "http://i-soft.net/"--remote
M.url = config.ip
M.json=require 'json'
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

function M.readNivel()
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/NivelDao.php", "POST", M.readNivelRequest, M.params)
end

 function M.readNivelRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.nivel = M.data
		end
		M.controller.readNivelReceive(M.nivel)--enviamos datos al controlador
		M.nivel = {}--reseteamos nivel
	end
end

return M