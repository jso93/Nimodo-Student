local M = {}
M.socket = require 'socket'
M.udp = M.socket.udp()
M.evaluacionAdaptativaDao = require 'src.pattern.dao.EvaluacionAdaptativaDao'
M.resultadoDao = require 'src.pattern.dao.ResultadoDao'
function M.new(_scene)
	M.scene = _scene 
	M.scene.tmp1 = timer.performWithDelay( 500,M.animacion,0 )
end

function M.initController()
	M.createEvaluacionAdaptativa()
end
function M.createEvaluacionAdaptativa( )
	M.evaluacionAdaptativaDao.new(M)
	M.evaluacionAdaptativaDao.CreateEvaluacionAdaptativa(M.scene.competencia.idcompetencia,M.scene.periodo.idperiodo,M.scene.area.idarea,M.scene.estudiante.idestudiante_matricula,M.scene.docente.iddocente_aula)
end
--REQUEST
function M.CreateEvaluacionAdaptativaReceive(_idevaluacion_adaptativa)
	if _idevaluacion_adaptativa~='error' then 
		M.resultadoDao.new(M)
		--REGISTRAR RESULTADO CON EL IDEVALUACIONAPTATIVA GENERAO
		for i=1,#M.scene.listaPreguntaResult do
			print('IDPREGUNTA: '..M.scene.listaPreguntaResult[i].idpregunta..' IDALTERNATIVA: '..M.scene.listaPreguntaResult[i].idalternativa..' CONOCIMIENTOAPOSTERIORI: '..M.scene.listaPreguntaResult[i].conocimientoAPosteriori..' TIEMPO:'..M.scene.listaPreguntaResult[i].tiempo)
			M.resultadoDao.CreateResultado(_idevaluacion_adaptativa,M.scene.listaPreguntaResult[i].idalternativa,M.scene.listaPreguntaResult[i].conocimientoAPosteriori,M.scene.listaPreguntaResult[i].tiempo)
		end
		M.sendMessageNotification()
	else
		native.showAlert('Mensaje', 'Ya tienes una evaluacion adaptativa!', {'OK'}, function()end)	
	end
end
function M.sendMessageNotification()
	M.udp = M.socket.udp()
	M.udp:settimeout(0)
	M.udp:setpeername("192.168.137.1", 6789)
	M.udp:send(M.scene.estudiante.nombres)
end
--ANIMACION BUTTON
function M.animacion( )
	if M.estado then 
		transition.to( M.scene.btnCorrecto,{time = 500,xScale = 1.5,yScale = 1.5} )
		transition.to( M.scene.btnInCorrecto,{time = 500,xScale = 1.5,yScale = 1.5} )
		M.estado = false
	else
		transition.to( M.scene.btnCorrecto,{time = 500,xScale = 1,yScale = 1} )
		transition.to( M.scene.btnInCorrecto,{time = 500,xScale = 1,yScale = 1} )
		M.estado = true
	end
end

return M