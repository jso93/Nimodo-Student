local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local
M.json=require 'json'
M.listaPeriodo = {}
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
end

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