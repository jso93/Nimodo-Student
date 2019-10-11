local M = {}
M.evaluacionAdaptativaConfigDao = require 'src.pattern.dao.EvaluacionAdaptativaConfigDao'
M.alternativaDao = require 'src.pattern.dao.AlternativaDao'
M.estiloDao = require 'src.pattern.dao.EstiloDao'
M.nivelDao = require 'src.pattern.dao.NivelDao'
M.matrizDao = require 'src.pattern.dao.MatrizDao'
M.listaPregunta = {}
M.contador = 0
M.listaPreguntaRespuestaCorrecta,M.listaPreguntaRespuestaIncorrecta,M.listaPreguntaAlternativa,M.listaPreguntaconocimientoAPosteriori,M.listaPreguntaResult = {},{},{},{},{}

function M.new(_scene)
	M.scene = _scene 
	M.scene.tmp1 = timer.performWithDelay( 500,M.animacion,0 )
end

function M.initController()
	M.scene.btnPregunta:addEventListener( 'touch',M.btnPreguntaOnclick)
end

--EVENTO ONCLICK
function M.btnPreguntaOnclick(event)
	if event.phase == 'began' then 
		transition.to( M.scene.btnPregunta,{time = 200,alpha = .5} )		
	end
	if event.phase == 'ended' then 
		transition.to( M.scene.btnPregunta,{time = 200,alpha = 1} )
		M.nivelDao.new(M)
		M.nivelDao.readNivel()--leemos nivel
		M.matrizDao.new(M)
		M.matrizDao.matrizCompetenciaTiempoRead(M.scene.competencia.idcompetencia,M.scene.docente.iddocente_aula)--verificamos el tiempo configurado para las evaluaciones
		M.buscarPreguntas()
	end
	
end
--FUNCION PARA BUSCAR PREGUNTAS
function M.buscarPreguntas()
	M.evaluacionAdaptativaConfigDao.new(M)
	M.evaluacionAdaptativaConfigDao.getPreguntas(M.scene.periodo.periodo,M.scene.docente.iddocente_aula,M.scene.competencia.competencia)
end
--REQUEST------------------------------
function M.matrizReadReceive(_listaMatriz)
	if #_listaMatriz>0 then
		M.listaMatriz = _listaMatriz
	end
end
function M.matrizCapacidadCompetenciaReadReceive( _listaCapacidad )
	if #_listaCapacidad>0 then
		M.listaIndicador = {}
		M.listaCapacidad = _listaCapacidad
		for i=1,#_listaCapacidad do
			M.matrizDao.matrizIndicadorCapacidadRead(M.scene.area.area,M.scene.competencia.competencia,_listaCapacidad[i].capacidad,M.scene.docente.iddocente_aula)
		end
	end
end
function M.matrizIndicadorCapacidadReadReceive( _listaIndicador )
	if #_listaIndicador>0 then
		for i=1,#_listaIndicador do
			M.listaIndicador[#M.listaIndicador + 1] = _listaIndicador[i]
		end
	end
end

function M.matrizCompetenciaTiempoReadReceive(_tiempo)
	if #_tiempo>0 then
		for i=1,#_tiempo do
			M.tiempo = _tiempo[i].tiempo
		end
	end 
end

function M.getPreguntasReceive(_listaPregunta )
	if #_listaPregunta>0 then 
		M.listaPregunta = _listaPregunta
		M.estiloDao.new(M)
		M.estiloDao.ReadEstilo()--buscamos estilos de aprendizaje
	else
		native.showAlert('Nimodo', 'No hay preguntas disponibles', {'OK'}, function()end)	
	end
end
function M.readNivelReceive(_listaNivel)
	if #_listaNivel>0 then 
		M.listaNivel = _listaNivel
	end
end
function M.readEstiloReceive(_listaEstilo)
	if #_listaEstilo>0 then 
		M.listaEstilo = _listaEstilo
		--M.previousTAI(M.scene.conocimientoApriori)--funcion previo a la evaluacion adaptativa
		M.alternativaDao.new(M)
		M.alternativaDao.ReadAlternativa(M.listaPregunta)
	end
end
function M.readAlternativaReceive(_listaAlternativa)
	M.cantAlt = 0
	M.alternativa = {}
	if #_listaAlternativa>0 then 
		M.listaAlternativa = _listaAlternativa
		M.matrizDao.matrizRead()
		M.matrizDao.matrizCapacidadCompetenciaRead(M.scene.area.area,M.scene.competencia.competencia,M.scene.docente.iddocente_aula)
	end
end
function M.listaPreguntasIndicador()
	M.listaPreguntaIndicador,M.preguntaIndicador = {},{}
	if M.listaMatriz~=nil then
		for i=1,#M.listaMatriz do
			for j=1,#M.listaIndicador do
				if M.listaMatriz[i].iddesempenio == M.listaIndicador[j].iddesempenio then 
					for k=1,#M.listaPregunta do
						if M.listaMatriz[i].idmatriz == M.listaPregunta[k].idmatriz then 
							M.preguntaIndicador[#M.preguntaIndicador + 1] = M.listaPregunta[k]
						end
					end
				end
			end
			M.listaPreguntaIndicador[#M.listaPreguntaIndicador + 1] = M.preguntaIndicador
			M.preguntaIndicador = {}
		end
		print( 'GRUPOS E PREGUNTS POR INDICADOR*********************' )
		M.indexInicial = nil 
		M.estado = true
		M.grupoIndex = {}
		for i=1,#M.listaPreguntaIndicador do
			if #M.listaPreguntaIndicador[i]>0 then 
				print( 'grupo'..i )
				M.grupoIndex[#M.grupoIndex + 1] = i
				if M.estado then M.indexInicial = i M.estado = false end--inicador inicial
			end
		end
		M.previousTAI()	
	end
end

-------------------------
--FUNCION PARA DETERMINAR CUAL ES LA PRIMERA PREGUNTA QUE SE DEBE LANZAR
function M.previousTAI()
	--M.scene.conocimientoApriori= 0.55
	M.scene.conocimientoAprioriInicial= M.scene.conocimientoApriori
	print( 'apriori estudiante: '..M.scene.conocimientoApriori )
	print( 'PREGUNTAS CANDIDATAS' )
	--for j=1,#M.listaPreguntaIndicador[M.indexInicial] do
	--	print('\tPREGUNTA:'..M.listaPreguntaIndicador[M.indexInicial][j].descripcion..' DESCUIDO:'..M.listaPreguntaIndicador[M.indexInicial][j].descuido..' idpregunta:'..M.listaPreguntaIndicador[M.indexInicial][j].idpregunta..' idmatriz:'..M.listaPreguntaIndicador[M.indexInicial][j].idmatriz)
	--end	
	--verificamos en que nivel de logro se encuentra la primera vez el estudiante
	local x = M.scene.conocimientoApriori*20
	if x>=1 and x<=11 then M.nivel = 'En Inicio'end
	if x>11 and x<=16 then M.nivel = 'En Proceso'end
	if x>16 and x<=20 then M.nivel = 'Satisfactorio'end
	if M.listaNivel~=nil then
		for j=1,#M.listaNivel do
			for i=1,#M.listaPreguntaIndicador[M.indexInicial] do
				if M.listaNivel[j].nivel == M.nivel then 
					if M.listaNivel[j].idnivel == M.listaPreguntaIndicador[M.indexInicial][i].idnivel then 
						print( 'NIVEL:'..M.listaNivel[j].nivel )
						print( 'LANZAR PREGUNTA:'..M.listaPreguntaIndicador[M.indexInicial][i].descripcion )
						M.aux = i
						break
					end
				end
			end
		end	
	end
	if M.aux~=nil then
		--consultamos alternativas de la pregunta a lanzar
		for i=1,#M.listaAlternativa do
			if M.listaPreguntaIndicador[M.indexInicial][M.aux].idpregunta == M.listaAlternativa[i].idpregunta then 
				M.alternativa[#M.alternativa + 1] = M.listaAlternativa[i]
			end
		end
		--verificamos e que estilo es la pregunta a lanzar
		for i=1,#M.listaEstilo do
			if M.listaPreguntaIndicador[M.indexInicial][M.aux].idestilo == M.listaEstilo[i].idestilo then 
				print('Estilo:'..M.listaEstilo[i].estilo)
				M.estilo = M.listaEstilo[i]
				if M.estilo.estilo == 'Visual' then 
					M.recursoName = M.listaPreguntaIndicador[M.indexInicial][M.aux].idpregunta..".png"
					M.url = "http://192.168.137.1/Nimodo/NimodoStudent/pdo/images/"
				end
				if M.estilo.estilo == 'Auditiva' then 
					M.recursoName = M.listaPreguntaIndicador[M.indexInicial][M.aux].idpregunta..".ogg"
					M.url = "http://192.168.137.1/Nimodo/NimodoStudent/pdo/audio/"
				end
				network.download(M.url..M.recursoName,"GET",M.downloadRecursoPregunta,M.recursoName,system.TemporaryDirectory )
			end
		end
	else
		native.showAlert('Nimodo', 'No hay preguntas disponibles para el nivel: '.. M.nivel, {'OK'}, function()end)
	end

end
--------CARGAMOS IMAGEN DE LA PREGUNTA
function M.downloadRecursoPregunta( event )
	if ( event.isError ) then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else
		local _params = {
	    estudiante = M.scene.estudiante,
	    docente = M.scene.docente,
	    area = M.scene.area,
	    competencia = M.scene.competencia,
	    periodo = M.scene.periodo,
	    listaPreguntaRespuestaCorrecta = M.listaPreguntaRespuestaCorrecta,
	    listaPreguntaRespuestaIncorrecta = M.listaPreguntaRespuestaIncorrecta,
	    listaPreguntaAlternativa = M.listaPreguntaAlternativa,
	    listaPreguntaconocimientoAPosteriori = M.listaPreguntaconocimientoAPosteriori,
	    listaPreguntaResult = M.listaPreguntaResult,
	    listaPregunta = M.listaPreguntaIndicador,--LISTA DE TODAS LAS PREGUNTAS DE LA COMPETENCIA
	    listaPreguntaIndicador = M.listaPreguntaIndicador[M.indexInicial],--LISTA DE TODAS LAS PREGUNTAS DEL INDICADOR ESPECIFICADO
	    pregunta = M.listaPreguntaIndicador[M.indexInicial][M.aux],--PREGUNTA A LANZAR
	    filename = event.response.filename,
	    baseDirectory = event.response.baseDirectory,
	    alternativa = M.alternativa,
	    listaAlternativa = M.listaAlternativa,
	    tiempo = M.tiempo,
	    contador = M.contador,--primer vez es cero
	    conocimientoApriori = M.scene.conocimientoApriori,
	    conocimientoAprioriInicial =M.scene.conocimientoAprioriInicial,
	    listaEstilo = M.listaEstilo,
	    listaNivel = M.listaNivel,
	    estilo = M.estilo.estilo,
	    indexInicial = M.indexInicial,
	    grupoIndex = M.grupoIndex
		}
		--ELIMINAMOS TEMPORIZADOR
		if M.scene.tmp1~=nil then 
			timer.pause( M.scene.tmp1 )
			timer.cancel( M.scene.tmp1 )
			M.scene.tmp1 = nil 
		end
		--reseteamos datos
		M.cantAlt = 0
		M.listaPregunta,M.alternativa,M.listaEstilo = {},{},{}
		--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
		package.loaded['src.pattern.dao.EvaluacionAdaptativaConfigDao'] = nil
		package.loaded['src.pattern.dao.AlternativaDao'] = nil
		package.loaded['src.pattern.dao.EstiloDao'] = nil
		package.loaded['src.pattern.dao.NivelDao'] = nil
		package.loaded['src.pattern.dao.MatrizDao'] = nil
		package.loaded['src.pattern.controller.EvaluacionAdaptativaSceneController'] = nil--THIS CONTROLLER
		--DIRECCIONAMOS A LA SCENA CORRESPONDIENTE
		if M.estilo.estilo == 'Visual' then 
			M.scene.composer.gotoScene( "src.pattern.view.PreguntaVisualScene", { effect="fromRight", time=500, params=_params } )
		end
		if M.estilo.estilo == 'Auditiva' then 
			M.scene.composer.gotoScene( "src.pattern.view.PreguntaAuditivaScene", { effect="fromRight", time=500, params=_params } )
		end
	end
end

--FUNCION PARA REDONEDAR NUMEROS A LA CANTIDAD DE DECIMALES QUE SE DESEE
function M.round( num, numDecimalPlaces )--redondeamos numero
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

--ANIMACION BUTTON
function M.animacion()
	if M.estado then 
		transition.to( M.scene.btnPregunta,{time = 500,xScale = 1.5,yScale = 1.5} )
		M.estado = false
	else
		transition.to( M.scene.btnPregunta,{time = 500,xScale = 1,yScale = 1} )
		M.estado = true
	end
end

return M