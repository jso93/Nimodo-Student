local composer = require 'composer'
local scene = composer.newScene()
-------FUNCIONES--------------
function scene:crearMenu( )
	scene._params = {
	    estudiante = scene.estudiante,
	    docente = scene.docente,
    	area = scene.area, 
        competencia = scene.competencia,
    	periodo = scene.periodo,
		listaPreguntaRespuestaCorrecta = scene.listaPreguntaRespuestaCorrecta,
	    listaPreguntaRespuestaIncorrecta = scene.listaPreguntaRespuestaIncorrecta,
	    listaPreguntaAlternativa = scene.listaPreguntaAlternativa,
    	listaPreguntaconocimientoAPosteriori = scene.listaPreguntaconocimientoAPosteriori,
    	listaPreguntaResult = scene.listaPreguntaResult,
	    listaPregunta = scene.listaPregunta,
        listaPreguntaIndicador =  scene.listaPreguntaIndicador,--LISTA DE TODAS LAS PREGUNTAS DEL INDICADOR ESPECIFICADO
	    pregunta = scene.pregunta,
	    filename = scene.filename,
	    baseDirectory = scene.baseDirectory,
	    alternativa = scene.alternativa,
	    listaAlternativa = scene.listaAlternativa,
	    tiempo = scene.tiempo,
	    contador = scene.contador,--segundos de la bd
	    conocimientoApriori = scene.conocimientoApriori,
    	conocimientoAprioriInicial = scene.conocimientoAprioriInicial,
	    listaEstilo = scene.listaEstilo,
        listaNivel = scene.listaNivel,
	    estilo = scene.estilo,
	    indexInicial =  scene.indexInicial,
    	grupoIndex = scene.grupoIndex
		}
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
    print( 'create loadScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
	    print( 'show loadScene' )
		composer.removeScene( 'src.pattern.view.PreguntaVisualScene')
		composer.removeScene( 'src.pattern.view.PreguntaAuditivaScene')
		--DIRECCIONAMOS A LA SCENA CORRESPONDIENTE
		if scene.estilo == 'Visual' then 
			composer.gotoScene( "src.pattern.view.PreguntaVisualScene", { effect="fromRight", time=500, params=scene._params } )
		end
		if scene.estilo == 'Auditiva' then 
			composer.gotoScene( "src.pattern.view.PreguntaAuditivaScene", { effect="fromRight", time=500, params=scene._params } )
		end
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide loadScene' )
	end
end

function scene:destroy( event )
    print( 'destroy loadScene' )
    
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene