local M = {}
local config = require 'src.pattern.config.config'
--VARIABLES
M.headers,M.params = {},{}
M.json=require 'json'
M.listaMatriz,M.listaAreas,M.listaCompetencias,M.listaCapacidades,M.listaIndicadores,M.listaBimestres = {},{},{},{},{},{}
M.url = "http://i-soft.net/"--remote
M.url = config.ip
M.tiempo = nil
M.cantComp,M.cantBim = 0,0
M.contCap = 0
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
end
--CONSULTA MATRIZ----------------
function M.matrizRead()
	M._function = 'matrizRead'
	M.body  = '_function='..M._function
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizReadRequest, M.params)
end

function M.matrizReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaMatriz = M.data
		end
		M.controller.matrizReadReceive(M.listaMatriz)--enviamos datos al controlador
		M.listaMatriz = {}--reseteamos matriz
	end
end
--CONSULTA AREAS----------------
function M.matrizAreaRead(_idDocenteAula)
	M._function = 'matrizAreaRead'
	M.body  = '_function='..M._function..'&idDocenteAula='.._idDocenteAula
	M.params.headers = M.headers
	M.params.body = M.body	
	network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizAreaReadRequest, M.params)
end

function M.matrizAreaReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaAreas = M.data
		end
		M.controller.matrizAreaReadReceive(M.listaAreas)--enviamos datos al controlador
		M.listaAreas = {}--reseteamos areas
	end
end

--CONSULTA COMPETENCIAS POR AREA
function M.matrizCompetenciaAreaRead(_area,_idDocenteAula)
	if _area~=nil and _idDocenteAula~=nil then
		M._function = 'matrizCompetenciaAreaRead'
		M.body  = '_function='..M._function..'&area='.._area..'&idDocenteAula='.._idDocenteAula
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizCompetenciaAreaReadRequest, M.params)	
	end
end

function M.matrizCompetenciaAreaReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaCompetencias = M.data		
		end
		M.controller.matrizCompetenciaAreaReadReceive(M.listaCompetencias)--enviamos datos al controlador
		M.listaCompetencias = {}--reseteamos lista de competencias
		
	end
end

--CONSULTA CAPACIDADES POR COMPETENCIA 
function M.matrizCapacidadCompetenciaRead(_area,_competencia,_idDocenteAula)
	if _area~=nil and _competencia~=nil and _idDocenteAula~=nil then
		M._function = 'matrizCapacidadCompetenciaRead'
		M.body  = '_function='..M._function..'&area='.._area..'&competencia='.._competencia..'&idDocenteAula='.._idDocenteAula
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizCapacidadCompetenciaReadRequest, M.params)	
	end
end

function M.matrizCapacidadCompetenciaReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaCapacidades = M.data	
		end
		M.controller.matrizCapacidadCompetenciaReadReceive(M.listaCapacidades)--enviamos datos al controlador
		M.listaCapacidades = {}--reseteamos lista de capacidades
		
	end
end
--CONSULTA INDICADORES POR CAPACIDAD 
function M.matrizIndicadorCapacidadRead(_area,_competencia,_capacidad,_idDocenteAula)
	if _area~=nil and _competencia~=nil and _capacidad~=nil and _idDocenteAula~=nil then
		M._function = 'matrizIndicadorCapacidadRead'
		M.body  = '_function='..M._function..'&area='.._area..'&competencia='.._competencia..'&capacidad='.._capacidad..'&idDocenteAula='.._idDocenteAula
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizIndicadorCapacidadReadRequest, M.params)	
	end
end

function M.matrizIndicadorCapacidadReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaIndicadores = M.data		
		end
		M.controller.matrizIndicadorCapacidadReadReceive(M.listaIndicadores)--enviamos datos al controlador
		M.listaIndicadores = {}--reseteamos lista de indicadores
		M.contCap = M.contCap + 1
		if #M.controller.listaCapacidad == M.contCap then 
			M.controller.listaPreguntasIndicador()--leemos todas las preguntas del primer indicador
			M.contCap = 0
		end
	end
end
--CONSULTA BIMESTRES
function M.matrizCompetenciaBimestreRead(_idCompetencia,_idDocenteAula)
	if _idCompetencia~=nil and _idDocenteAula~=nil then 
		M._function = 'matrizCompetenciaBimestreRead'
		M.body  = '_function='..M._function..'&idCompetencia='.._idCompetencia..'&idDocenteAula='.._idDocenteAula
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizCompetenciaBimestreReadRequest, M.params)	
		M.cantComp = M.cantComp + 1
	end
end

function M.matrizCompetenciaBimestreReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaBimestres = M.data		
		end
		M.controller.matrizCompetenciaBimestreReadReceive(M.listaBimestres)--enviamos datos al controlador
		M.listaBimestres = {}--reseteamos lista de competencias
		M.cantBim = M.cantBim + 1
		if M.cantComp == M.cantBim then
			M.controller.matrizRead()--podemos leer todos los datos despues de que todos los request hayan finalizado
			M.cantComp,M.cantBim = 0,0--reseteamos contadores
		end
	end
end

--CONSULTA TIEMPO
function M.matrizCompetenciaTiempoRead(_idCompetencia,_idDocenteAula)
	if _idCompetencia~=nil and _idDocenteAula~=nil then 
		M._function = 'matrizCompetenciaTiempoRead'
		M.body  = '_function='..M._function..'&idCompetencia='.._idCompetencia..'&idDocenteAula='.._idDocenteAula
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/MatrizDao.php", "POST", M.matrizCompetenciaTiempoReadRequest, M.params)	
		M.cantComp = M.cantComp + 1
	end
end

function M.matrizCompetenciaTiempoReadRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.tiempo = M.data		
		end
		M.controller.matrizCompetenciaTiempoReadReceive(M.tiempo)--enviamos datos al controlador
		M.tiempo = nil--reseteamos tiempo
	end
end

return M
