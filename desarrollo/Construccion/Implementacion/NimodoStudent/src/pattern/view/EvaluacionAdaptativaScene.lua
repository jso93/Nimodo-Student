local composer = require 'composer'
local scene = composer.newScene()
--MODULOS EXTERNOS
local evaluacionAdaptativaSceneController = require 'src.pattern.controller.EvaluacionAdaptativaSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )
	scene.background = display.newImage('src/images/backGroundEvaluacionAdaptativa.png',display.contentCenterX,display.contentCenterY-40)
    scene.background.width = display.contentWidth*.5
    scene.background.height = display.contentHeight*.4
    scene.background.alpha = .3

	scene.txtEstudiante = display.newText(scene.estudiante.nombres,display.contentCenterX,30, "src/fonts/Alessia.otf", 30 )
	scene.txtEstudiante:setTextColor( 1,1,1 )

    scene.txtMensaje = display.newText('Pulsa para empezar la evaluación, suerte!',display.contentCenterX,display.contentHeight-30, "src/fonts/Alessia.otf", 20 )
	scene.txtMensaje:setTextColor( 1,1,1 )

	scene.btnPregunta = display.newImage('src/images/pregunta.png',display.contentCenterX,display.contentCenterY+80)
    scene.btnPregunta.width = 80
    scene.btnPregunta.height = 80

    scene.group:insert(scene.background)
    scene.group:insert(scene.txtEstudiante)
    scene.group:insert(scene.txtMensaje)
    scene.group:insert(scene.btnPregunta)
    
	--CONTROLLER
	evaluacionAdaptativaSceneController.new(scene)
	evaluacionAdaptativaSceneController.initController()

end

function scene:create( event )
	scene.group = self.view 
	scene.composer = composer
	scene.estudiante = event.params.estudiante
    scene.docente = event.params.docente
    scene.area = event.params.area
    scene.competencia = event.params.competencia
    scene.periodo = event.params.periodo
    scene.conocimientoApriori = event.params.conocimientoApriori
    print( 'create EvaluacionAdaptativaScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show EvaluacionAdaptativaScene' )
	composer.removeScene( 'src.pattern.view.EvaluacionAdaptativaBusquedaScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide EvaluacionAdaptativaScene' )
	end
end

function scene:destroy( event )
    print( 'destroy EvaluacionAdaptativaScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene

