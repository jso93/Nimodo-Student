local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local 192.168.137.1  192.168.1.28 
M.json=require 'json'
M.estudiante = {}
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
end

function M.validarLogin(_user, _password)
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
return M