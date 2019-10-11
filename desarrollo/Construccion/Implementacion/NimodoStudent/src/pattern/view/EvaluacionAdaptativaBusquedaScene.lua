local composer = require 'composer'
local widget = require 'widget'
local scene = composer.newScene()
--MODULOS EXTERNOS
local evaluacionAdaptativaBusquedaSceneController = require 'src.pattern.controller.EvaluacionAdaptativaBusquedaSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )
	scene.backGround = display.newImage('src/images/backGroundEvaluacionAdaptativaBusqueda.png',display.contentCenterX ,display.contentCenterY )
    scene.backGround.width = display.contentWidth+100
    scene.backGround.height = display.contentHeight
    scene.backGround.alpha = .3

    scene.searchExam = display.newImage('src/images/searchExam.png',display.contentCenterX-100 ,display.contentCenterY )
    scene.searchExam.width = 100
    scene.searchExam.height = 100

	scene.tableViewEvaluacionAdaptativa = widget.newTableView( 
		{
	        left = 200,
	        top = 200,
	        height = display.contentHeight/2,
	        width = display.contentWidth/2,
	        onRowRender = evaluacionAdaptativaBusquedaSceneController.onRowRender,
	        onRowTouch = evaluacionAdaptativaBusquedaSceneController.onRowTouch,
	        listener = scrollListener
		}
	)
	scene.tableViewEvaluacionAdaptativa.x,scene.tableViewEvaluacionAdaptativa.y = display.contentCenterX+100,display.contentCenterY

    scene.group:insert(scene.backGround)
    scene.group:insert(scene.searchExam)
    scene.group:insert(scene.tableViewEvaluacionAdaptativa)
	--CONTROLLER
	evaluacionAdaptativaBusquedaSceneController.new(scene)
	evaluacionAdaptativaBusquedaSceneController.initController()

end

function scene:create( event )
	scene.group = self.view 
	scene.composer = composer
	scene.estudiante = event.params.estudiante
	scene.docente = event.params.docente
    print( 'create EvaluacionAdaptativaBusquedaScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show EvaluacionAdaptativaBusquedaScene' )
	composer.removeScene( 'src.pattern.view.PrincipalScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide EvaluacionAdaptativaBusquedaScene' )
	end
end

function scene:destroy( event )
    print( 'destroy EvaluacionAdaptativaBusquedaScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene