local M = {}
--VARIABLES
M.headers,M.params = {},{}
M.listaFechas,listaEstudiante,M.listaCalificaciones = {},{},{}
M.url = "http://i-soft.net/"--remote
M.url = "http://192.168.137.1/"--local
M.json=require 'json'
M.cantFechasEt,M.cantFechasCal = 0,0
--FUNCIONES
function M.new(_controller)
	M.controller = _controller 
	M.headers["Content-Type"] = "application/x-www-form-urlencoded"
	M.headers["Accept-Language"] = "en-US"
end
--CONSULTA FECHAS----------------
function M.getFechas(_dni,_periodo,_area)
	if _dni~= nil and _periodo~= nil and _area~= nil then
		print( _dni.._periodo.periodo.._area.area )
		M.periodo = _periodo
		M._function = 'getFechas'
		M.body  = '_function='..M._function..'&dni='.._dni..'&periodo='.._periodo.periodo..'&area='.._area.area
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EvaluacionTradicionalDao.php", "POST", M.getFechasRequest, M.params)
	end
end

function M.getFechasRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		print( 'entraaaa' )
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaFechas = M.data
		end
		M.controller.datosFechasEvaluacionTradicionalReceive(M.listaFechas)--enviamos datos al controlador
		M.listaFechas = {}--reseteamos fechas
	end	
end

--CONSULTA EVALUACIONES TRADICIONALES POR ESTUDIANTE
function M.getEvaluacionTradicionalEstudiante(_dni,_periodo,_area,_fecha)
	if _dni~= nil and _periodo~= nil and _area~= nil and _fecha~=nil then
		M._function = 'getEvaluacionTradicionalEstudiante'
		M.body  = '_function='..M._function..'&dni='.._dni..'&periodo='.._periodo.periodo..'&area='.._area.area..'&fecha='.._fecha
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EvaluacionTradicionalDao.php", "POST", M.getEvaluacionTradicionalEstudianteRequest, M.params)
	end
end

--FUNCIONES DE EVENTOS
function M.getEvaluacionTradicionalEstudianteRequest( event )
		if event.isError then
			native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
		else
			M.data = M.json.decode( event.response )
			if M.data ~= nil then
				M.listaEstudiante = M.data
			end
			M.controller.getEvaluacionTradicionalEstudianteReceive(M.listaEstudiante)--enviamos datos al controlador
			M.listaEstudiante = {}--reseteamos datos de evaluaciones de estudiante
			M.cantFechasEt = M.cantFechasEt + 1
			if M.cantFechasEt == #M.controller.listaFecha and M.cantFechasCal == #M.controller.listaFecha then
				M.controller.evaluacionesTradicionalesRead('ET')--podemos leer todos los datos despues de que todos los request hayan finalizado
				M.cantFechasEt,M.cantFechasCal = 0,0
			end
		end
end

--CONSULTA DE CALIFICACIONES DE LAS EVALUACIONES TRADICIONALES POR ESTUDIANTE
function M.getEvaluacionTradicionalCalificacionEstudiante(_dni,_periodo,_area,_fecha)
	if _dni~= nil and _periodo~= nil and _area~= nil and _fecha~=nil then
		M._function = 'evaluacionTradicionalCalificacionEstudianteRead'
		M.body  = '_function='..M._function..'&dni='.._dni..'&periodo='.._periodo.periodo..'&area='.._area.area..'&fecha='.._fecha
		M.params.headers = M.headers
		M.params.body = M.body	
		network.request( M.url.."Nimodo/NimodoStudent/pdo/dao/EvaluacionTradicionalDao.php", "POST", M.getEvaluacionTradicionalCalificacionEstudianteRequest, M.params)
	end
end

--FUNCIONES DE EVENTOS
function M.getEvaluacionTradicionalCalificacionEstudianteRequest( event )
	if event.isError then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		M.data = M.json.decode( event.response )
		if M.data ~= nil then
			M.listaCalificaciones = M.data
		end
		M.controller.getEvaluacionTradicionalCalificacionEstudianteReceive(M.listaCalificaciones)--enviamos datos al controlador
		M.listaCalificaciones = {}--reseteamos datos de las calificaciones de estudiante
		M.cantFechasCal = M.cantFechasCal + 1
		if M.cantFechasEt == #M.controller.listaFecha and M.cantFechasCal == #M.controller.listaFecha then 
			M.controller.evaluacionesTradicionalesRead()--podemos leer todos los datos despues de que todos los request hayan finalizado
			M.cantFechasEt,M.cantFechasCal = 0,0
		end
	end
end

return M