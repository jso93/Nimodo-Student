local M = {}
--FUNCIONES
function M.new(_scene)
	M.scene = _scene 
	M.scene.tmp1 = timer.performWithDelay( 500,M.animacion,0 )
end

function M.initController()
	M.scene.btnEvaluacion:addEventListener( 'touch', M.btnEvaluacionOnClick )	
end

--FUNCIONES DE EVENTOS
function M.btnEvaluacionOnClick( event )
	if event.phase == 'ended' then
		local _params = {--enviamos como parametros datos del estudiante matriculado y del docente asignado a una aula
		    estudiante = M.scene.estudiante,
		    docente = M.scene.docente
		}
		--ELIMINAMOS TEMPORIZADOR
		timer.pause( M.scene.tmp1 )
		timer.cancel( M.scene.tmp1 )
		M.scene.tmp1 = nil 
		--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
		package.loaded['src.pattern.controller.PrincipalSceneController'] = nil--THIS CONTROLLER
		--PASAMOS A LA SIGUIENTE ESCENA
		M.scene.composer.gotoScene( "src.pattern.view.EvaluacionAdaptativaBusquedaScene", { effect="fromRight", time=500, params=_params } ) 
	end	
end 

--ANIMACION
function M.animacion( )
	if M.estado then 
		transition.to( M.scene.btnEvaluacion,{time = 500,alpha = .5,xScale = 1.5,yScale = 1.5} )
		M.estado = false
	else
		transition.to( M.scene.btnEvaluacion,{time = 500,alpha = 1,xScale = 1,yScale = 1} )
		M.estado = true
	end
end

return M