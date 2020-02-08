local M = {}
local config = require 'src.pattern.config.config'
local lfs = require( "lfs" )
--variables
M.hora,M.minuto,M.segundo,M.tiempoPregunta = 0,0,0,0
M.audio = nil
function M.new(_scene)
	M.scene = _scene 
	M.contador = M.scene.contador
	M.scene.tmp1 = timer.performWithDelay( 1000,M.tiempo,0)
end

function M.initController()
	M.scene.alternativa1:addEventListener( 'touch', M.btnAlternativaOnClick )	
	M.scene.alternativa2:addEventListener( 'touch', M.btnAlternativaOnClick )	
	M.scene.alternativa3:addEventListener( 'touch', M.btnAlternativaOnClick )	
	M.scene.calificar:addEventListener( 'touch', M.btnCalificarOnClick )	
	if M.scene.estilo == 'Auditiva' then 
		M.scene.btnPlay:addEventListener( 'touch',M.audioOnclick)
		M.scene.btnPause:addEventListener( 'touch',M.audioOnclick)
		M.scene.btnStop:addEventListener( 'touch',M.audioOnclick)
		M.scene.btnPause.isVisible = false
		M.scene.btnStop.isVisible = false
		M.isPlay = true
	end
end

function M.audioOnclick(event)
	if event.phase == 'began' then 
		transition.to( event.target,{time = 200,xScale = 1.2, yScale = 1.2} )
	end
	if event.phase == 'ended' then 
		if event.target.alpha == 1 then 
			transition.to( event.target,{time = 200,xScale = 1, yScale = 1} )
			if event.target.id == 'play' then 
				M.scene.btnPlay.isVisible = false
				M.scene.btnPause.isVisible = true
				M.scene.btnStop.isVisible = true
				if M.isPlay then 
					M.audio = audio.loadSound(M.scene.filename,M.scene.baseDirectory )
					audio.play(M.audio)
    				audio.setVolume( 1.0 )	
    				M.isPlay = false    				
				end
				if M.isPaused then 
					audio.resume( M.audio )
					M.isPaused = false
				end
			end
			if event.target.id == 'pause' then 
				M.scene.btnPlay.isVisible = true
				M.scene.btnPause.isVisible = false
				M.scene.btnStop.isVisible = false
				audio.pause( M.audio )
				M.isPaused = true
			end
			if event.target.id == 'stop' then 
				M.scene.btnPlay.isVisible = true
				M.scene.btnPause.isVisible = false
				M.scene.btnStop.isVisible = false
				audio.stop()
				audio.dispose( M.audio )
				M.audio = nil
				M.isPlay = true
			end
		end
		
	end
end
--FUNCIONES DE EVENTOS
function M.btnAlternativaOnClick( event )
	if event.phase == 'ended' then
		M.alternativaSelecciona = event.target
		if event.target.id == 1 then 
			M.alternativaAuxiliar1 = M.scene.alternativa2
			M.alternativaAuxiliar2 = M.scene.alternativa3
		end
		if event.target.id == 2 then 
			M.alternativaAuxiliar1 = M.scene.alternativa1
			M.alternativaAuxiliar2 = M.scene.alternativa3
		end
		if event.target.id == 3 then 
			M.alternativaAuxiliar1 = M.scene.alternativa1
			M.alternativaAuxiliar2 = M.scene.alternativa2
		end
		if event.target.alpha ~= 1 then
			transition.to( event.target,{time = 200,alpha=1,xScale = 1, yScale = 1} )
			transition.to( event.target.label,{time = 200,alpha=1,xScale = 1, yScale = 1} )
			M.animacionX = display.contentWidth*2
		else
			transition.to( event.target,{time = 200,alpha=.5,xScale = .8, yScale = .8} )
			transition.to( event.target.label,{time = 200,alpha=.5,xScale = .8, yScale = .8} )	
			M.animacionX = display.contentWidth-50
		end
		transition.to( M.alternativaAuxiliar1,{time = 200,alpha =1,xScale = 1, yScale = 1} )
		transition.to( M.alternativaAuxiliar1.label,{time = 200,alpha =1,xScale = 1, yScale = 1} )
		transition.to( M.alternativaAuxiliar2,{time = 200,alpha = 1,xScale = 1, yScale = 1} )
		transition.to( M.alternativaAuxiliar2.label,{time = 200,alpha=1,xScale = 1, yScale = 1} )
		transition.to( M.scene.calificar,{time = 200,x=M.animacionX} )
		transition.to( M.scene.calificar.label,{time = 200,x=M.animacionX} )
	end	
end
function M.btnCalificarOnClick( event ) 
	if event.phase == 'ended' then 
		M.conocimientoApriori = M.scene.conocimientoApriori
		M.pregunta = M.scene.pregunta
		M.listaPregunta = M.scene.listaPregunta
		M.listaEstilo = M.scene.listaEstilo 
		M.listaAlternativa = M.scene.listaAlternativa 
		--OCULTAMOS ALTERNATIVAS Y BOTON CALIFICAR
		transition.to( M.scene.calificar,{time = 200,x= display.contentWidth*2} )
		transition.to( M.scene.calificar.label,{time = 200,x= display.contentWidth*2} )
		transition.to( M.scene.alternativa1,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		transition.to( M.scene.alternativa1.label,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		transition.to( M.scene.alternativa2,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		transition.to( M.scene.alternativa2.label,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		transition.to( M.scene.alternativa3,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		transition.to( M.scene.alternativa3.label,{time = 200,alpha =1,xScale = 1, yScale = 1,y=display.actualContentHeight*2 } )
		--VERIFICAMOS SI LA RESPUESTA ES CORRECTA O INCORRECTA
		if tonumber(M.scene.alternativa[M.alternativaSelecciona.id].success) == 1 then
			M.respuesta = 'correcta'
			print( M.respuesta)
			M.scene.listaPreguntaRespuestaCorrecta[#M.scene.listaPreguntaRespuestaCorrecta+1] = M.pregunta
		else
			M.respuesta = 'incorrecta'
			print( M.respuesta)
			M.scene.listaPreguntaRespuestaIncorrecta[#M.scene.listaPreguntaRespuestaIncorrecta+1] = M.pregunta
		end
		--almacenamos alternativa selecciona
		M.scene.listaPreguntaAlternativa[#M.scene.listaPreguntaAlternativa+1] = M.scene.alternativa[M.alternativaSelecciona.id]
		M.TAI()--calculamos el nuevo conocimiento(posteriori)
	end
end
--ALGORITMO TAI(TEST ADAPTATIVO INFORMATIZADO)
function M.TAI()
	local PAPCD = 1 - M.pregunta.descuido --Probabilidad de Acertar la Pregunta Conociendo el desempeño
	local PTAP = (M.conocimientoApriori * PAPCD) + (1 - M.conocimientoApriori)*M.pregunta.adivinanza --Probabilidad Total de Acertar la Pregunta
	local PFPCD = M.pregunta.descuido  --Probabilidad de fallar la pregunta conociendo el desempeño
	local PTFP = (M.conocimientoApriori * PFPCD ) + (1 - M.conocimientoApriori)*(1 - M.pregunta.adivinanza)--Probabilidad total de Fallar la Pregunta
	print( 'CONOCIMIENTO A PRIORI DEL DESEMPEÑO: '..M.conocimientoApriori )
	print( '******ATRIBUTOS DE LA PREGUNTA******' )
	print( 'PROBABILIDAD DE ACERTAR LA PREGUNTA CONOCIENDO EL DESEMPEÑO: '..PAPCD)
	print( 'PROBABILIDAD DE FALLAR LA PREGUNTA CONOCIENDO EL DESEMPEÑO(DESCUIDO): '..M.pregunta.descuido )
	print( 'PROBABILIDAD DE ACERTAR LA PREGUNTA SIN CONOCER EL DESEMPEÑO(ADIVINANZA): '..M.pregunta.adivinanza )
	print( 'PROBABILIDAD DE FALLAR LA PREGUNTA SIN CONOCER EL DESEMPEÑO: '..(1-M.pregunta.adivinanza) )
	if M.respuesta == 'correcta' then 
		M.conocimientoAPosteriori = (M.conocimientoApriori*PAPCD)/PTAP
	end
	if M.respuesta == 'incorrecta' then 
		M.conocimientoAPosteriori = (M.conocimientoApriori*PFPCD)/PTFP
	end
	M.conocimientoAPosteriori = M.round(M.conocimientoAPosteriori,4)
	print( 'CONOCIMIENTO A POSTERIORI DEL DESEMPEÑO: '..M.conocimientoAPosteriori )
	M.scene.listaPreguntaconocimientoAPosteriori[#M.scene.listaPreguntaconocimientoAPosteriori + 1] = {idpregunta=M.pregunta.idpregunta,conocimientoAPosteriori=M.conocimientoAPosteriori}
	M.scene.listaPreguntaResult[#M.scene.listaPreguntaResult + 1] = {respuesta=M.respuesta,idpregunta=M.pregunta.idpregunta,idalternativa = M.scene.alternativa[M.alternativaSelecciona.id].idalternativa,conocimientoAPosteriori=M.conocimientoAPosteriori,tiempo = M.tiempoPregunta }
	print( M.scene.listaPreguntaResult[#M.scene.listaPreguntaResult].idpregunta )
	M.preguntasRestantes()
end
--FUNCION PARA ALMACENAR PREGUNTAS Y ALTERNATIVAS RESTANTES
function M.preguntasRestantes()
	M.listaPreguntaBackup = {}
	M.index = nil
	for i=1,#M.scene.grupoIndex do
		if M.scene.indexInicial == M.scene.grupoIndex[i] then
			M.index = i
			for j=1,#M.scene.listaPreguntaIndicador do
				if M.pregunta.idpregunta~=M.scene.listaPreguntaIndicador[j].idpregunta then--todas las preguntas menos la que se acaba de lanzar 
					M.listaPreguntaBackup[#M.listaPreguntaBackup + 1] = M.scene.listaPreguntaIndicador[j]
				end
			end	
		end	
	end
	M.scene.listaPreguntaIndicador = M.listaPreguntaBackup
	M.preguntaAux = nil--pregunta que se va a lanzar
	for i=1,#M.scene.listaNivel do
		if M.pregunta.idnivel == M.scene.listaNivel[i].idnivel then
			if M.respuesta == 'correcta' then 
				if M.scene.listaNivel[i].nivel == 'En Inicio' then
					for j=1,#M.scene.listaPreguntaIndicador do
						if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i+1].idnivel then
							for k=1,#M.scene.listaEstilo do
								if M.scene.listaPreguntaIndicador[j].idestilo == M.scene.listaEstilo[k].idestilo then 
									if M.scene.estilo == M.scene.listaEstilo[k].estilo then 
										print('INICIO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
										M.preguntaAux = M.scene.listaPreguntaIndicador[j]
									end
								end
							end
						end
					end	
				end
				if M.scene.listaNivel[i].nivel == 'En Proceso' then
					for j=1,#M.scene.listaPreguntaIndicador do
						if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i+1].idnivel then
							for k=1,#M.scene.listaEstilo do
								if M.scene.listaPreguntaIndicador[j].idestilo == M.scene.listaEstilo[k].idestilo then 
									if M.scene.estilo == M.scene.listaEstilo[k].estilo then 
										print('PROCESO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
										M.preguntaAux = M.scene.listaPreguntaIndicador[j]
									end
								end
							end
						end
					end	
				end
				if M.scene.listaNivel[i].nivel == 'Satisfactorio' then
					print( 'maximo nivel' )
				end
			end
			if M.respuesta == 'incorrecta' then 
				if M.scene.listaNivel[i].nivel == 'En Inicio' then
					for j=1,#M.scene.listaPreguntaIndicador do
						if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i].idnivel then 
							print('INICIO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
							M.preguntaAux = M.scene.listaPreguntaIndicador[j]
						end
					end	
				end
				if M.scene.listaNivel[i].nivel == 'En Proceso' then
					local exist = false
					for j=1,#M.scene.listaPreguntaIndicador do
						if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i].idnivel then 
							print('PROCESO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
							M.preguntaAux = M.scene.listaPreguntaIndicador[j]
							exist = true
						end
					end	
					if exist==false then 
						for j=1,#M.scene.listaPreguntaIndicador do
							if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i-1].idnivel then 
								print('PROCESO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
								for k=1,#M.scene.listaEstilo do
									if M.scene.listaPreguntaIndicador[j].idestilo == M.scene.listaEstilo[k].idestilo then 
										print( M.scene.listaPreguntaIndicador[j].descripcion..M.scene.listaEstilo[k].estilo )
										if M.scene.listaEstilo[k].estilo == 'Visual' then 
											exist = true
										end
									end
								end
								if exist then 
									M.preguntaAux = M.scene.listaPreguntaIndicador[j]
									break
								end
							end
						end	
					end	
				end
				if M.scene.listaNivel[i].nivel == 'Satisfactorio' then
					local exist = false
					for j=1,#M.scene.listaPreguntaIndicador do
						if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i].idnivel then 
							print('SATISFACTORIO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
							M.preguntaAux = M.scene.listaPreguntaIndicador[j]
							exist = true
						end
					end	
					if exist==false then 
						for j=1,#M.scene.listaPreguntaIndicador do
							if M.scene.listaPreguntaIndicador[j].idnivel == M.scene.listaNivel[i-1].idnivel then 
								print('SATISFACTORIO Pregunta a lanzar:'..M.scene.listaPreguntaIndicador[j].descripcion)
								for k=1,#M.scene.listaEstilo do
									if M.scene.listaPreguntaIndicador[j].idestilo == M.scene.listaEstilo[k].idestilo then 
										print( M.scene.listaPreguntaIndicador[j].descripcion..M.scene.listaEstilo[k].estilo )
										if M.scene.listaEstilo[k].estilo == 'Visual' then 
											exist = true
										end
									end
								end
								if exist then 
									M.preguntaAux = M.scene.listaPreguntaIndicador[j]
									break
								end
							end
						end	
					end		
				end
			end
		end
	end
	if M.preguntaAux~=nil then 
		M.pregunta = M.preguntaAux--pregunta a lanzar
		M.nextPreguntaMostrar()--SIGUIENTE PREGUNTA  MOSTRAR
	else
		M.nextListaPreguntaIndicador()--VERIFICAMOS SI EXISTE ALGUN INDICADOR MAS PARA EVALUAR
	end
end
--LISTA DE PREGUNTAS PARA EL SIGUIENTE INDICADOR
function M.nextListaPreguntaIndicador( )
	if M.scene.grupoIndex[M.index + 1]~=nil then
		M.scene.indexInicial = M.scene.grupoIndex[M.index + 1]
		M.pregunta = nil
		M.scene.listaPreguntaIndicador = {}
		M.scene.listaPreguntaIndicador = M.scene.listaPregunta[M.scene.indexInicial]--LISTA DE PREGUNTAS siguiente indicador
		for i=1,#M.scene.listaPregunta do
			print(M.scene.listaPregunta)
			for j=1,#M.scene.listaPregunta[i] do
				print(M.scene.listaPregunta[i][j].descripcion..' cant: '..#M.scene.listaPreguntaIndicador)
			end
		end
		--verificamos en que nivel de logro se encuentra para el siguiente inicador el estudiante
		local x = M.scene.conocimientoAprioriInicial*20
		if x>=1 and x<=11 then M.nivel = 'En Inicio'end
		if x>11 and x<=16 then M.nivel = 'En Proceso'end
		if x>16 and x<=20 then M.nivel = 'Satisfactorio'end
		for i=1,#M.scene.listaNivel do
			if M.nivel == M.scene.listaNivel[i].nivel then M.aux = i break end
		end
		for i=1,#M.scene.listaPreguntaIndicador do
			if M.scene.listaNivel[M.aux].idnivel  == M.scene.listaPreguntaIndicador[i].idnivel then 
				for j=1,#M.scene.listaEstilo do
					print(M.scene.listaEstilo[j].estilo)
					if M.scene.estilo == M.scene.listaEstilo[j].estilo then 
						if M.respuesta == 'correcta' then 
							if M.scene.listaPreguntaIndicador[i].idestilo == M.scene.listaEstilo[j].idestilo then 
								print( 'NIVEL:'..M.scene.listaNivel[M.aux].nivel )
								print( 'LANZAR PREGUNTA:'..M.scene.listaPreguntaIndicador[i].descripcion )
								M.pregunta = M.scene.listaPreguntaIndicador[i]
							end
						end
						if M.respuesta == 'incorrecta' then 
							if M.scene.listaPreguntaIndicador[i].idestilo == M.scene.listaEstilo[j].idestilo then
								if M.scene.listaEstilo[j].estilo == 'Visual'  then
									print( 'NIVEL:'..M.scene.listaNivel[M.aux].nivel )
									print( 'LANZAR PREGUNTA:'..M.scene.listaPreguntaIndicador[i].descripcion )
									M.pregunta = M.scene.listaPreguntaIndicador[i]
									break
								end
							else
								print( 'NIVEL:'..M.scene.listaNivel[M.aux].nivel )
								print( 'LANZAR PREGUNTA:'..M.scene.listaPreguntaIndicador[i].descripcion )
								M.pregunta = M.scene.listaPreguntaIndicador[i]
							end	
						end
					end
				end
			end
		end
		if M.pregunta~=nil then 
			M.nextPreguntaMostrar()
		end
	else
		print( 'se termino de evaluar en todos los desempeños' )
		local function deleteRecurso( obj )
			audio.stop()
			audio.dispose(M.audioRespuesta)
			local doc_path = system.pathForFile( "", system.TemporaryDirectory )
			for file in lfs.dir( doc_path ) do
			    print( "Found file: " .. file )
			    os.remove(system.pathForFile( file, system.TemporaryDirectory))--eliminamos archivos del directorio temporal
			end
			M.finishEvaluacionAdaptativa()
		end
		if M.respuesta == 'correcta' then 
			M.audioRespuesta = audio.loadSound('src/audio/correcto.mp3')
			audio.play(M.audioRespuesta)
			M.scene.correcto.isVisible = true
			transition.to( M.scene.correcto,{time = 800,alpha =0,xScale = 3, yScale = 3,onComplete=deleteRecurso} )
		end
		if M.respuesta == 'incorrecta' then 
			M.audioRespuesta = audio.loadSound('src/audio/incorrecto.mp3')
			audio.play(M.audioRespuesta)
			M.scene.incorrecto.isVisible = true
			transition.to( M.scene.incorrecto,{time = 800,alpha =0,xScale = 3, yScale = 3,onComplete=deleteRecurso} )
		end
	end
end
--FUNCION PARA DETERMINAR CUAL ES LA SIGUIENTE PREGUNTA A LANZAR
function M.nextPreguntaMostrar()
	M.alternativa = {}
	for i=1,#M.listaAlternativa do
		if M.pregunta.idpregunta == M.listaAlternativa[i].idpregunta then 
			M.alternativa[#M.alternativa + 1] = M.listaAlternativa[i]--alternativas de la pregunta a lanzar
		end
	end
	--verificamos estilo de la pregunta a lanzar
	for i=1,#M.listaEstilo do
		if M.pregunta.idestilo == M.listaEstilo[i].idestilo then 
			print( 'EL ESTILO DE LA PREGUNTA ES: '..M.listaEstilo[i].estilo )
			M.estilo = M.listaEstilo[i].estilo
		end
	end
	if M.estilo == 'Visual' then 
		M.recursoName = M.pregunta.idpregunta..".png"--nombre del archivo a descargar
		M.recursoNameAux = tostring(os.time())..'.png'--nombre del archivo descargado
		M.url = config.ip
		M.url = M.url.."Nimodo/NimodoStudent/pdo/images/"
	end
	if M.estilo == 'Auditiva' then 
		M.recursoName = M.pregunta.idpregunta..".ogg"--nombre del archivo a descargar
		M.recursoNameAux = tostring(os.time())..'.ogg'--nombre del archivo descargado
		M.url = config.ip
		M.url = M.url.."Nimodo/NimodoStudent/pdo/audio/" 
		--IMAGEN
		M.recursoNameImage = M.pregunta.idpregunta..".png"--nombre del archivo a descargar
		M.recursoNameImageAux = tostring(os.time())..'.png'--nombre del archivo descargado
		M.urlImage = config.ip
		M.urlImage = M.urlImage.."Nimodo/NimodoStudent/pdo/images/"
	end

	local function downloadRecurso( obj )
		audio.stop()
		audio.dispose(M.audioRespuesta)
		local doc_path = system.pathForFile( "", system.TemporaryDirectory )
		for file in lfs.dir( doc_path ) do
		    os.remove(system.pathForFile( file, system.TemporaryDirectory))--eliminamos archivos del directorio temporal
		end
		if M.estilo == 'Auditiva' then
			print( 'DESCARGAR IMAGEN DE PREGUNTA AUDITIVA' )
			M.networkImage = network.download(M.urlImage..M.recursoNameImage,"GET",M.downloadRecursoImageReceive,M.recursoNameImageAux,system.TemporaryDirectory )
		end
		if M.estilo == 'Visual' then 
			M.filenameImage = nil
	    	--baseDirectory = nil,
			M.network = network.download(M.url..M.recursoName,"GET",M.downloadRecursoPreguntaReceive,M.recursoNameAux,system.TemporaryDirectory )
		end
	end
	if M.respuesta == 'correcta' then 
		M.audioRespuesta = audio.loadSound('src/audio/correcto.mp3')
		audio.play(M.audioRespuesta)
		M.scene.correcto.isVisible = true
		transition.to( M.scene.correcto,{time = 800,alpha =0,xScale = 3, yScale = 3,onComplete=downloadRecurso} )
	end
	if M.respuesta == 'incorrecta' then 
		M.audioRespuesta = audio.loadSound('src/audio/incorrecto.mp3')
		audio.play(M.audioRespuesta)
		M.scene.incorrecto.isVisible = true
		transition.to( M.scene.incorrecto,{time = 800,alpha =0,xScale = 3, yScale = 3,onComplete=downloadRecurso} )
	end
end
--------RESPUESTA DE LA DESCARGA DE RECURSO( IMAGEN O AUDIO DE LA PREGUNTA)
function M.downloadRecursoPreguntaReceive( event )
	if ( event.isError ) then
		native.showAlert('Nimodo', 'Verifique su conexion a internet', {'ok'}, function(event)end)
	else		
		local _params = {
	    estudiante = M.scene.estudiante,
    	docente = M.scene.docente,
    	area = M.scene.area, 
   		competencia = M.scene.competencia,
    	periodo = M.scene.periodo,
		listaPreguntaRespuestaCorrecta = M.scene.listaPreguntaRespuestaCorrecta,
	    listaPreguntaRespuestaIncorrecta = M.scene.listaPreguntaRespuestaIncorrecta,
	    listaPreguntaAlternativa = M.scene.listaPreguntaAlternativa,	
    	listaPreguntaconocimientoAPosteriori = M.scene.listaPreguntaconocimientoAPosteriori,
    	listaPreguntaResult = M.scene.listaPreguntaResult,
	    listaPregunta = M.listaPregunta, 
	    listaPreguntaIndicador =  M.scene.listaPreguntaIndicador,--LISTA DE TODAS LAS PREGUNTAS DEL DESEMPEÑO ESPECIFICADO
	    pregunta = M.pregunta,
	    filename = event.response.filename,
	    baseDirectory = event.response.baseDirectory,
	    filenameImage = M.filenameImage,
	    alternativa = M.alternativa,
	    listaAlternativa = M.listaAlternativa,
	    tiempo = M.scene.tiempo,
	    contador = M.contador,--segundos de la bd
	    conocimientoApriori = M.conocimientoApriori,
	    conocimientoAprioriInicial = M.scene.conocimientoAprioriInicial,
	    listaEstilo = M.listaEstilo,
	    listaNivel = M.scene.listaNivel,
	    estilo = M.estilo,
	    indexInicial =  M.scene.indexInicial,
	    grupoIndex = M.scene.grupoIndex
		}
		--ELIMINAMOS TEMPORIZADOR
		if M.scene.tmp1~=nil then 
			timer.pause( M.scene.tmp1 )
			timer.cancel( M.scene.tmp1 )
			M.scene.tmp1 = nil 
		end
		
		if M.audio~=nil then 
			audio.stop()
			audio.dispose( M.audio )--liberamos de memoria
			M.audio = nil
		end
		--reseteamos datos
		M.listaPregunta,M.alternativa,M.listaEstilo = {},{},{}
		--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
		package.loaded['src.pattern.controller.PreguntaSceneController'] = nil--THIS CONTROLLER
		M.scene.composer.gotoScene( 'src.pattern.view.LoadScene', { effect="fromRight", time=1000, params=_params } )
	end
end
--------------------DESCARGA DE IMAGEN DE UNA PREGUNTA AUDITIVA-------------------------
function M.downloadRecursoImageReceive( event )
	if ( event.isError ) then
		native.showAlert('Nimodo', 'Verifique su conexion a internet'..event.response, {'ok'}, function(event)end)
	else	
		if event.response.filename~=nil then 
			print('imagen name:'..event.response.filename)
			M.filenameImage = event.response.filename--nombre de la imagen de la pregunta auditiva  
		else
			M.filenameImage = nil
			print( 'la pregunta auditiva no tiene imagen...' )
		end
		M.network = network.download(M.url..M.recursoName,"GET",M.downloadRecursoPreguntaReceive,M.recursoNameAux,system.TemporaryDirectory )
	end
end
--FUNCION PARA REDONEDAR NUMEROS A LA CANTIDAD DE DECIMALES QUE SE DESEE
function M.round( num, numDecimalPlaces )--redondeamos numero
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

--FUNCION TIEMPO
function M.tiempo( )
	M.tiempoPregunta = M.tiempoPregunta + 1
	M.contador = M.contador + 1
	M.hora = M.contador /3600
	M.minuto = math.fmod (M.contador,3600)/60
	M.segundo =math.fmod(math.fmod (M.contador,3600),60)
	formattedTime = string.format("%02d:%02d:%02d", M.hora, M.minuto, M.segundo)
	M.scene.txtTiempo.label.text = formattedTime
	if M.contador == tonumber( M.scene.tiempo) then 
    	M.conocimientoApriori = M.scene.conocimientoApriori
		M.finishEvaluacionAdaptativa()
	end
end

function M.finishEvaluacionAdaptativa()
	timer.pause(M.scene.tmp1 )
	timer.cancel(M.scene.tmp1 )
	M.scene.tmp1 = nil 
	if M.audio~=nil then 
		audio.stop()
		audio.dispose( M.audio )--liberamos de memoria
		M.audio = nil
	end
	if M.network~=nil then 
		network.cancel( M.network )--cancelamos cualquier descarga(audio o imagen)
		M.network = nil
		print( 'cancelamos request...' )
	end
	if M.networkImage~=nil then 
		network.cancel( M.networkImage )--cancelamos cualquier descarga(audio o imagen)
		M.networkImage = nil
		print( 'cancelamos request...' )
	end
	local _params = {
	estudiante = M.scene.estudiante,
	docente = M.scene.docente,
	area = M.scene.area, 
    competencia = M.scene.competencia,
	periodo = M.scene.periodo,
	listaPreguntaRespuestaCorrecta = M.scene.listaPreguntaRespuestaCorrecta,
    listaPreguntaRespuestaIncorrecta = M.scene.listaPreguntaRespuestaIncorrecta,
    listaPreguntaAlternativa = M.scene.listaPreguntaAlternativa,
	listaPreguntaconocimientoAPosteriori = M.scene.listaPreguntaconocimientoAPosteriori,
	listaPreguntaResult = M.scene.listaPreguntaResult,
    tiempo = M.scene.tiempo,
    contador = M.contador,--segundos de la bd
    conocimientoApriori = M.conocimientoApriori,
    listaEstilo = M.listaEstilo,
    estilo = M.estilo
	}
	--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
	package.loaded['src.pattern.controller.PreguntaSceneController'] = nil--THIS CONTROLLER
	M.scene.composer.gotoScene( 'src.pattern.view.ResultadoScene', { effect="fromRight", time=1000, params=_params } )
	print( 'FIN EVALUACION' )	
end

return M