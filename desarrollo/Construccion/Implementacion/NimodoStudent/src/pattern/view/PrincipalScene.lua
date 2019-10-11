local composer = require 'composer'
local scene = composer.newScene()
--MODULOS EXTERNOS
local principalSceneController = require 'src.pattern.controller.PrincipalSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )
	scene.backgroundMenuPrincipal = display.newImage('src/images/backgroundMenuPrincipal.jpg',display.contentCenterX,display.contentCenterY )
	scene.backgroundMenuPrincipal.width = display.contentWidth+100
    scene.backgroundMenuPrincipal.height = display.contentHeight

    scene.txtDocente = display.newText("Docente: "..scene.docente.nombres, 60,display.contentCenterY-140, "src/fonts/Alessia.otf", 15 )
	scene.txtDocente:setTextColor( 0,0,0 )

    scene.txtAula = display.newText(scene.estudiante.grado..' '..'"'..scene.estudiante.seccion..'"', display.contentWidth-60,display.contentCenterY-140, "src/fonts/Alessia.otf", 15 )
	scene.txtAula:setTextColor( 0,0,0 )

    scene.txtEstudiante = display.newText( "Hola "..scene.estudiante.nombres..', Bienvenido!', display.contentCenterX,display.contentCenterY-100, "src/fonts/Alessia.otf", 30 )
	scene.txtEstudiante:setTextColor( 0,0,0 )

    scene.btnEvaluacion = display.newImage('src/images/evaluacion.png',display.contentCenterX+150,display.contentCenterY-10 )
	scene.btnEvaluacion.width = 50
    scene.btnEvaluacion.height = 50

	scene.txtSms = display.newText( "Pulsa la nota para empezar", scene.btnEvaluacion.x-120, scene.btnEvaluacion.y-20, "src/fonts/Alessia.otf", 15 )
	scene.txtSms:setTextColor( 0,0,0 )

	scene.group:insert(scene.backgroundMenuPrincipal)
	scene.group:insert(scene.txtDocente)
	scene.group:insert(scene.txtAula)
	scene.group:insert(scene.txtEstudiante)
	scene.group:insert(scene.btnEvaluacion)
	scene.group:insert(scene.txtSms)

	--initController
	principalSceneController.new(scene)
	principalSceneController.initController()
end

function scene:create( event )
	scene.group = self.view 
	scene.composer = composer
	scene.estudiante = event.params.estudiante 
	scene.docente = event.params.docente 
    print( 'create PrincipalScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show PrincipalScene' )
	composer.removeScene( 'src.pattern.view.LoginScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide PrincipalScene' )
	end
end

function scene:destroy( event )
    print( 'destroy PrincipalScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene