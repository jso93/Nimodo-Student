local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.listaAlternativa = {}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local
M.listaPregunta = nil
M.json=require 'json'
--FUNCIONES
function M.new (_controller)
	M.controller = _controller 
end

function M.ReadAlternativa(_listaPregunta)
	M.listaPregunta = _listaPregunta
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
	M.body  = ''
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/AlternativaDao.php", "POST", M.readAlternativaRequest, M.params)
end

 function M.readAlternativaRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			local aux = 0
			for i=1,#M.listaPregunta do
				for j=1,#M.data do
					if M.listaPregunta[i].idpregunta == M.data[j].idpregunta  then
						aux = aux + 1
						M.listaAlternativa[aux] = M.data[j]
					end
				end
			end
		end
		M.controller.readAlternativaReceive(M.listaAlternativa)--enviamos datos al controlador
		M.listaAlternativa = {}--reseteamos alternativa
	end
end

return M