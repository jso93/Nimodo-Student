local composer = require 'composer'
local scene = composer.newScene()
--MODULOS EXTERNOS
local resultadoSceneController = require 'src.pattern.controller.ResultadoSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )

	print( 'RESPUESTAS CORRECTAS:***********************' )
	for i=1,#scene.listaPreguntaRespuestaCorrecta do
		print('PREGUNTA: '..scene.listaPreguntaRespuestaCorrecta[i].descripcion..' IDPREGUNTA: '..scene.listaPreguntaRespuestaCorrecta[i].idpregunta)
	end
	print( 'RESPUESTAS INCORRECTAS:*********************' )
	for i=1,#scene.listaPreguntaRespuestaIncorrecta do
		print('PREGUNTA: '..scene.listaPreguntaRespuestaIncorrecta[i].descripcion..' IDPREGUNTA: '..scene.listaPreguntaRespuestaIncorrecta[i].idpregunta)
	end
	print( 'ALTERNATIVAS SELECCIONADAS:*********************' )
	for i=1,#scene.listaPreguntaAlternativa do
		print('IDALTERNATIVA: '..scene.listaPreguntaAlternativa[i].idalternativa..'ALTERNATIVA: '..scene.listaPreguntaAlternativa[i].descripcion..' IDPREGUNTA: '..scene.listaPreguntaAlternativa[i].idpregunta)
	end
	print( 'CONOCIMIENTO A POSTERIORI:*********************' )
	for i=1,#scene.listaPreguntaconocimientoAPosteriori do
		print('CONOCIMIENTO A POSTERIORI: '..scene.listaPreguntaconocimientoAPosteriori[i].conocimientoAPosteriori..' IDPREGUNTA: '..scene.listaPreguntaconocimientoAPosteriori[i].idpregunta)
	end
	print( 'DATOS TOTALES PREGUNTAS:*********************' )
	scene.cantCorrectas,scene.cantIncorrectas = 0,0
	for i=1,#scene.listaPreguntaResult do
		print('IDPREGUNTA: '..scene.listaPreguntaResult[i].idpregunta..' IDALTERNATIVA: '..scene.listaPreguntaResult[i].idalternativa..' CONOCIMIENTOAPOSTERIORI: '..scene.listaPreguntaResult[i].conocimientoAPosteriori..' TIEMPO:'..scene.listaPreguntaResult[i].tiempo)
		if scene.listaPreguntaResult[i].respuesta == 'correcta' then scene.cantCorrectas = scene.cantCorrectas + 1 end
		if scene.listaPreguntaResult[i].respuesta == 'incorrecta' then scene.cantIncorrectas = scene.cantIncorrectas + 1 end
	end
	print( 'CANTIDAD PREGUNTAS CORRECTAS:'..scene.cantCorrectas )
	print( 'CANTIDAD PREGUNTAS INCORRECTAS:'..scene.cantIncorrectas )
	print( 'CONOCIMIENTO A POSTERIORI FINAL*********************' )
	print(scene.conocimientoApriori )
	print( 'ESTUDIANTE:'..scene.estudiante.nombres )
	print( 'ID competencia:'..scene.competencia.idcompetencia )
	print( 'ID periodo:'..scene.periodo.idperiodo )
	print( 'ID area:'..scene.area.idarea )
	print( 'ID estuiante_matricula:'..scene.estudiante.idestudiante_matricula )
	print( 'ID docente_aula:'..scene.docente.iddocente_aula )
	print( 'ID docente_aula:'..scene.docente.iddocente_aula )
	--_idperiodo,_idarea,_idestudiante_matricula,_iddocente_aula
	
    scene.background = display.newImage('src/images/background.png',display.contentCenterX,display.contentCenterY)
    scene.background.width = display.contentWidth+100
    scene.background.height = display.contentHeight

    scene.btnEvaluacion = display.newImage('src/images/evaluacion.png',display.contentCenterX,display.contentCenterY-40)
    scene.btnEvaluacion.width = 100
    scene.btnEvaluacion.height = 100

    scene.btnCorrecto = display.newImage('src/images/correcto.png',display.contentCenterX-70,display.contentCenterY+20)
    scene.btnCorrecto.width = 40
    scene.btnCorrecto.height = 40

    scene.btnInCorrecto = display.newImage('src/images/incorrecto.png',display.contentCenterX+70,display.contentCenterY+20)
    scene.btnInCorrecto.width = 40
    scene.btnInCorrecto.height = 40

	scene.txtEstudiante = display.newText(scene.estudiante.nombres..', estos son tus resultados',display.contentCenterX,30, "src/fonts/Alessia.otf", 30 )
	scene.txtEstudiante:setTextColor( 1,1,1 )

    scene.txtPreguntasCorrectas = display.newText(scene.cantCorrectas,scene.btnCorrecto.x,scene.btnCorrecto.y+60, "src/fonts/Alessia.otf", 30 )
	scene.txtPreguntasCorrectas:setTextColor( 1,1,1 )

	scene.txtPreguntasInCorrectas = display.newText(scene.cantIncorrectas,scene.btnInCorrecto.x,scene.btnInCorrecto.y+60, "src/fonts/Alessia.otf", 30 )
	scene.txtPreguntasInCorrectas:setTextColor( 1,1,1 )

    scene.group:insert(scene.background)
    scene.group:insert(scene.btnEvaluacion)
    scene.group:insert(scene.btnCorrecto)
    scene.group:insert(scene.btnInCorrecto)
    scene.group:insert(scene.txtEstudiante)
    scene.group:insert(scene.txtPreguntasCorrectas)
    scene.group:insert(scene.txtPreguntasInCorrectas)
	--CONTROLLER
	resultadoSceneController.new(scene)
	resultadoSceneController.initController()
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
    scene.tiempo = event.params.tiempo
    scene.contador = event.params.contador
    scene.conocimientoApriori = event.params.conocimientoApriori
    scene.listaEstilo = event.params.listaEstilo
    scene.estilo = event.params.estilo
    print( 'create resultadoScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show resultadoScene' )
	composer.removeScene( 'src.pattern.view.PreguntaVisualScene')
	composer.removeScene( 'src.pattern.view.PreguntaAuditivaScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide resultadoScene' )
	end
end

function scene:destroy( event )
    print( 'destroy resultadoScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene