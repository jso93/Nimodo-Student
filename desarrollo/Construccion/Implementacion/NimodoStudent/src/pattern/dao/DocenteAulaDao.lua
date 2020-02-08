local M = {}
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.docente = {}
M.url = "http://i-soft.net/"--remote
M.url = config.ip
M.json=require 'json'
M.grado,M.seccion = nil,nil
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

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
return M