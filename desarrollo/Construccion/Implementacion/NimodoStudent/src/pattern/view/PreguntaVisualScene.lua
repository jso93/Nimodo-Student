local composer = require 'composer'
local scene = composer.newScene()
--MODULOS EXTERNOS
local preguntaSceneController = require 'src.pattern.controller.PreguntaSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )
	scene.backGround = display.newImage('src/images/backGroundPregunta1.png',display.contentCenterX ,display.contentCenterY+12 )
    scene.backGround.width = display.contentWidth+120
    scene.backGround.height = display.contentHeight+150
    scene.group:insert(scene.backGround)

    scene.txtTiempo = display.newImage('src/images/timer.png',display.contentWidth-63,20 )
    scene.txtTiempo.width = 25 
    scene.txtTiempo.height = 25
    scene.txtTiempo.label = display.newText('', display.contentWidth-20,20, "src/fonts/Alessia.otf", 17 )
    scene.txtTiempo.label:setTextColor( 0,0,0 )

    scene.calificar = display.newImage('src/images/calificar.png',display.contentWidth*2, display.contentCenterY )
    scene.calificar.width = 150
    scene.calificar.height = 50 
    scene.calificar.label = display.newText('CALIFICAR', scene.calificar.x,scene.calificar.y, "src/fonts/Alessia.otf", 17 )
    scene.txtTiempo.label:setTextColor( 0,0,0 )

    scene.correcto = display.newImage('src/images/correcto.png',display.contentCenterX ,display.contentHeight-25 )
    scene.correcto.width = 25
    scene.correcto.height = 25 
    scene.correcto.isVisible = false

    scene.incorrecto = display.newImage('src/images/incorrecto.png',display.contentCenterX ,display.contentHeight-25 )
    scene.incorrecto.width = 25
    scene.incorrecto.height = 25 
    scene.incorrecto.isVisible = false

	local options2 = 
	{
	    text =scene.pregunta.descripcion,
	    x = display.contentCenterX+20, 
	    y = 50,
	    width = display.contentWidth*.9,
	    font = "src/fonts/Alessia.otf",
	    fontSize = 12,
	    align = "left"  -- Alignment parameter
	}
	scene.txtPregunta = display.newText( options2 )
	scene.txtPregunta.anchorY = 0
	scene.txtPregunta:setTextColor( 0,0,0 )
    print('hello')
    print(scene.filename)
    if scene.filename~=nil then 
        scene.preguntaImagen = display.newImage(scene.filename, scene.baseDirectory,display.contentCenterX,display.contentCenterY+20 )
        scene.preguntaImagen.width = 300
        scene.preguntaImagen.height = 120
    else
        print('pregunta sin imagen')
    end

    scene.alternativa1 = display.newImage('src/images/alternativa.png',display.contentCenterX-150 ,display.contentHeight-25 )
    scene.alternativa1.width = 120
    scene.alternativa1.height = 70
    scene.alternativa1.id = 1
    scene.alternativa1.label = display.newText(scene.alternativa[1].descripcion, scene.alternativa1.x,scene.alternativa1.y-10,"src/fonts/Alessia.otf", 12 )
	scene.alternativa1.label:setTextColor( 0,0,0 )

    scene.alternativa2 = display.newImage('src/images/alternativa.png',display.contentCenterX ,display.contentHeight-25 )
    scene.alternativa2.width = 120
    scene.alternativa2.height = 70
    scene.alternativa2.id = 2
    scene.alternativa2.label = display.newText(scene.alternativa[2].descripcion, scene.alternativa2.x,scene.alternativa2.y-10,"src/fonts/Alessia.otf", 12 )
	scene.alternativa2.label:setTextColor( 0,0,0 )

    scene.alternativa3 = display.newImage('src/images/alternativa.png',display.contentCenterX+150 ,display.contentHeight-25 )
    scene.alternativa3.width = 120
    scene.alternativa3.height = 70
    scene.alternativa3.id = 3
    scene.alternativa3.label = display.newText(scene.alternativa[3].descripcion, scene.alternativa3.x,scene.alternativa3.y-10,"src/fonts/Alessia.otf", 12 )
	scene.alternativa3.label:setTextColor( 0,0,0 )

    scene.group:insert(scene.txtTiempo)
    scene.group:insert(scene.txtTiempo.label)
    scene.group:insert(scene.txtPregunta)
    if scene.filename~=nil then scene.group:insert(scene.preguntaImagen) else print('pregunta sin imagen') end
    scene.group:insert(scene.calificar)
    scene.group:insert(scene.calificar.label)
    scene.group:insert(scene.correcto)
    scene.group:insert(scene.incorrecto)
    scene.group:insert(scene.alternativa1)
    scene.group:insert(scene.alternativa1.label)
    scene.group:insert(scene.alternativa2)
    scene.group:insert(scene.alternativa2.label)
    scene.group:insert(scene.alternativa3)
    scene.group:insert(scene.alternativa3.label)
	--CONTROLLER
	preguntaSceneController.new(scene)
	preguntaSceneController.initController()
end

function scene:create( event )
	scene.group = self.view 
	scene.composer = composer
    scene.estudiante = event.params.estudiante
    scene.docente = event.params.docente
    scene.area = event.params.area 
    scene.competencia = event.params.competencia
    scene.periodo = event.params.periodo
    scene.listaPreguntaRespuestaCorrecta = event.params.listaPreguntaRespuestaCorrecta
    scene.listaPreguntaRespuestaIncorrecta = event.params.listaPreguntaRespuestaIncorrecta
    scene.listaPreguntaAlternativa = event.params.listaPreguntaAlternativa
    scene.listaPreguntaconocimientoAPosteriori = event.params.listaPreguntaconocimientoAPosteriori
    scene.listaPreguntaResult = event.params.listaPreguntaResult
    scene.listaPregunta = event.params.listaPregunta
    scene.listaPreguntaIndicador =  event.params.listaPreguntaIndicador--LISTA DE TODAS LAS PREGUNTAS DEL INDICADOR ESPECIFICADO
	scene.pregunta = event.params.pregunta
	scene.filename = event.params.filename
	scene.baseDirectory = event.params.baseDirectory
    scene.alternativa = event.params.alternativa
	scene.listaAlternativa = event.params.listaAlternativa
    scene.tiempo = event.params.tiempo
    scene.contador = event.params.contador
    scene.conocimientoApriori = event.params.conocimientoApriori
    scene.conocimientoAprioriInicial =event.params.conocimientoAprioriInicial
    scene.listaEstilo = event.params.listaEstilo
    scene.listaNivel = event.params.listaNivel
    scene.estilo = event.params.estilo
    scene.indexInicial =  event.params.indexInicial
    scene.grupoIndex = event.params.grupoIndex
    print( 'create preguntaVisualScene' )
    scene:crearMenu()    
end

function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show preguntaVisualScene' )
    composer.removeScene( 'src.pattern.view.EvaluacionAdaptativaScene')
	composer.removeScene( 'src.pattern.view.LoadScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide preguntaVisualScene' )
	end
end

function scene:destroy( event )
    print( 'destroy preguntaVisualScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene