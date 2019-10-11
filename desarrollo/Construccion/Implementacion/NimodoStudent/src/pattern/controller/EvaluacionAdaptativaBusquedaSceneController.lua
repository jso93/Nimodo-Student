local M = {}
--MODULOS EXTERNOS
M.matrizDao = require 'src.pattern.dao.MatrizDao'
M.periodoDao = require 'src.pattern.dao.PeriodoDao'
M.evaluacionTradicionalDao = require 'src.pattern.dao.EvaluacionTradicionalDao'
--VARIABLES
M.listaAreas,M.listaCompetencias,M.listaBimestres,M.listaPeriodos,M.listaFecha,M.listaEvaluacionTradicional,M.listaCalificacion,M.listaCalificacionCompetencia,M.listaAreaCompetencia = {},{},{},{},{},{},{},{},{}
M.cantComp,M.cantBim,M.cantET,M.cantCal = 0,0,0,0
function M.new(_scene)
	M.scene = _scene 
end

function M.initController()
	M.scene.searchExam:addEventListener( 'touch', M.searchExamOnclick )
end

--FUNCIONES DE EVENTOS
function M.searchExamOnclick(event)
	if event.phase == 'began' then 
		transition.to( M.scene.searchExam,{time = 200,xScale = .8,yScale = .8} )
	end
	if event.phase == 'ended' and M.scene.searchExam.alpha == 1 then
		M.scene.searchExam.alpha = .5
		M.idDocenteAula = M.scene.docente.iddocente_aula
		M.matrizDao.new(M)
		M.matrizDao.matrizAreaRead(M.idDocenteAula)
		----PERIODOS
		M.periodoDao.new(M)
		M.periodoDao.periodoRead()
	end
end	

---RESPUESTAS REQUEST 
function M.matrizAreaReadReceive(_listaAreas)--lista de areas
	if #_listaAreas>0 then
		M.listaAreas = _listaAreas
		for i=1,#M.listaAreas do
			M.matrizDao.matrizCompetenciaAreaRead(M.listaAreas[i].area,M.idDocenteAula)
		end
	else
		native.showAlert('Nimodo', 'Las evaluaciones estan desactivadas!', {'ok'}, function(event)end)
		--RESTABLECEMOS OPACIDAD DEL BOTON BUSCAR
		M.scene.searchExam.alpha = 1
		transition.to( M.scene.searchExam,{time = 200,xScale = 1,yScale = 1} )
	end
end

function M.matrizCompetenciaAreaReadReceive(_listaCompetencias)--lista de competencias
	if #_listaCompetencias>0 then
		for i=1,#_listaCompetencias do
			M.cantComp = M.cantComp + 1
			M.listaCompetencias[M.cantComp] = _listaCompetencias[i]
			M.matrizDao.matrizCompetenciaBimestreRead(_listaCompetencias[i].idcompetencia,M.idDocenteAula)
		end
	else
		native.showAlert('Nimodo', 'Las evaluaciones estan desactivadas!', {'ok'}, function(event)end)		
	end
end

function M.matrizCompetenciaBimestreReadReceive(_listaBimestre)--lista de bimestres
	if #_listaBimestre>0 then	
		for i=1,#_listaBimestre do
			M.cantBim = M.cantBim + 1
			M.listaBimestres[M.cantBim] = _listaBimestre[i]
		end
	end
end  

function M.periodoReadReceive(_listaPeriodo)--lista de periodos
	if #_listaPeriodo>0 then
		M.listaPeriodos = _listaPeriodo
	else
		native.showAlert('Nimodo', 'No hay registro de Periodos!', {'ok'}, function(event)end)	
	end
end				

function M.datosFechasEvaluacionTradicionalReceive(_listaFechas)--fechas de las evaluaciones trdicionales
	if #_listaFechas>0 then
		M.listaFecha = _listaFechas
		for i=1,#_listaFechas do
			print( _listaFechas[i].fecha )
			M.evaluacionTradicionalDao.getEvaluacionTradicionalEstudiante(M.scene.docente.dni,M.periodo,M.area,_listaFechas[i].fecha,M.scene.estudiante.dni)
		    M.evaluacionTradicionalDao.getEvaluacionTradicionalCalificacionEstudiante(M.scene.docente.dni,M.periodo,M.area,_listaFechas[i].fecha,M.scene.estudiante.dni)
		end
	else
		native.showAlert('Nimodo', 'No tienes evaluaciones tradicionales registradas en el '..M.periodo.periodo, {'ok'}, function(event)
		M.scene.tableViewEvaluacionAdaptativa.alpha = 1
			end)	
	end
end

function M.getEvaluacionTradicionalEstudianteReceive( _listaEstudiante )--evaluaciones tradicionales de estudiantes
	for i=1,#_listaEstudiante do
		M.cantET = M.cantET + 1
		M.listaEvaluacionTradicional[M.cantET] =_listaEstudiante[i] 
		--print(_listaEstudiante[i].dni..'evaluaciones tradicionales:'.._listaEstudiante[i].nombres..' idevaluacion_tradicional:'.._listaEstudiante[i].idevaluacion_tradicional )
	end
end

function M.getEvaluacionTradicionalCalificacionEstudianteReceive(_listaCalificaciones)--calificaciones de las evaluaciones tradicionales de los estudiantes
	for i=1,#_listaCalificaciones do
		M.cantCal = M.cantCal + 1
		M.listaCalificacion[M.cantCal] = _listaCalificaciones[i]
		--print('idevaluacion_tradicional:'.._listaCalificaciones[i].idevaluacion_tradicional..' CALIFICACION:'.._listaCalificaciones[i].calificacion )
	end	
end

---LEEMOS DATOS DE LA MATRIZ UNA VEZ QUE TODOS LOS REQUEST HAYAN FINALIZADO
function M.matrizRead( )
	M.scene.tableViewEvaluacionAdaptativa:deleteAllRows()--reseteamos tableView
	for i=1,#M.listaAreas do
		--print('AREA : '..M.listaAreas[i].area)
		for j=1,#M.listaCompetencias do
			if M.listaAreas[i].idarea == M.listaCompetencias[j].idarea then 
				--print('\tCOMPETENCIA : '..M.listaCompetencias[j].competencia)
				for k=1,#M.listaBimestres do
					if M.listaCompetencias[j].idcompetencia == M.listaBimestres[k].idcompetencia then 
						if #M.listaPeriodos>0 then
							if M.listaBimestres[k].primer_bimestre == '1' then 
								M.scene.tableViewEvaluacionAdaptativa:insertRow({params = {area = M.listaAreas[i],competencia = M.listaCompetencias[j].competencia,periodo = M.listaPeriodos[1]}})
							end
							if M.listaBimestres[k].segundo_bimestre == '1' then 
								M.scene.tableViewEvaluacionAdaptativa:insertRow({params = {area = M.listaAreas[i],competencia = M.listaCompetencias[j].competencia,periodo = M.listaPeriodos[2]}})
							end
							if M.listaBimestres[k].tercer_bimestre == '1' then 
								M.scene.tableViewEvaluacionAdaptativa:insertRow({params = {area = M.listaAreas[i],competencia = M.listaCompetencias[j].competencia,periodo = M.listaPeriodos[3]}})
							end
							if M.listaBimestres[k].cuarto_bimestre == '1' then 
								M.scene.tableViewEvaluacionAdaptativa:insertRow({params = {area = M.listaAreas[i],competencia = M.listaCompetencias[j].competencia,periodo = M.listaPeriodos[4]}})
							end
						end
					end
				end
			end
		end
	end
	M.listaCompetenciasBackup = M.listaCompetencias
	M.listaAreas,M.listaCompetencias,M.listaBimestres,M.listaPeriodos = {},{},{},{}
	M.cantComp,M.cantBim = 0,0
	--RESTABLECEMOS OPACIDAD DEL BOTON BUSCAR
	M.scene.searchExam.alpha = 1
	transition.to( M.scene.searchExam,{time = 200,xScale = 1,yScale = 1} )
end

---LEEMOS DATOS DE LAS EVALUACIONES TRADICIONALES UNA VEZ QUE TODOS LOS REQUEST HAYAN FINALIZADO
function M.evaluacionesTradicionalesRead()
	M.cantCal = 0
	for i=1,#M.listaEvaluacionTradicional do
		if M.listaEvaluacionTradicional[i].dni == M.scene.estudiante.dni and M.listaEvaluacionTradicional[i].idarea == M.area.idarea and M.listaEvaluacionTradicional[i].idperiodo == M.periodo.idperiodo  then
		--print('ESTUDIANTE:'..M.listaEvaluacionTradicional[i].nombres..'EVALUACION ID: '..M.listaEvaluacionTradicional[i].idevaluacion_tradicional )
		--print( 'AREA:'..M.area.area.."PERIODO:"..M.periodo.periodo ) 
		M.cantCompBackup = 0
		for k=1,#M.listaCompetenciasBackup do
			if M.listaEvaluacionTradicional[i].idarea == M.listaCompetenciasBackup[k].idarea then 
				--print( 'xxxxx:'..M.listaCompetenciasBackup[k].competencia )
				M.cantCompBackup = M.cantCompBackup + 1
				M.listaAreaCompetencia[M.cantCompBackup] = M.listaCompetenciasBackup[k]
			end
		end
		M.cantComp = 0
			for j=1,#M.listaCalificacion do
				if M.listaEvaluacionTradicional[i].idevaluacion_tradicional == M.listaCalificacion[j].idevaluacion_tradicional then 
					--print('\tevaluacion id:'..M.listaCalificacion[j].idevaluacion_tradicional.. 'CALIFICACION : '..M.listaCalificacion[j].calificacion )
					M.cantComp = M.cantComp + 1
					M.cantCal = M.cantCal + 1
					M.listaCalificacionCompetencia[M.cantCal] = M.listaCalificacion[j].calificacion
				end
			end
		end
		
	end
	--LLAMAMOS A LA FUNCION PARA CALCULAR EL CONOCIMIENTO A PRIORI QUE TIENE EL ESTUDIANTE EN CADA COMPETENCIA
	M.getConocimientoApriori()
	-----RESETEAMOS
	M.listaCalificacionCompetencia,listaCompetenciasBackup,M.listaAreaCompetencia = {},{},{}
	M.cantET,M.cantComp,M.cantCal,M.cantCompBackup = 0,0,0,0--reseteamos 
end


--CALCULAMOS EL CONOCIMIENTO APRIORI QUE TIENE EL ESTUDIANTE A PARTIR DE LAS EVALUACIONES TRADICIONALES
function M.getConocimientoApriori()
	M.LG,M.LGH,M.LGS,M.LCA ={},{},{},{},{}
	M.aux1,M.aux2 = 0,0
	for i=1,#M.listaCalificacionCompetencia do
		M.aux1 = M.aux1 + 1
		if M.aux1<=M.cantComp then 
			M.LGH[M.aux1] = M.listaCalificacionCompetencia[i]
		end
		if M.aux1 ==M.cantComp then 
			M.aux2 = M.aux2 + 1
			M.LG[M.aux2] = M.LGH
			M.LGH = {}
			M.aux1 = 0
		end
	end

	for i=1,M.cantComp do
		M.LGS[i] = 0 --INICIALIZAMOS VALORES PARA ALMACENAR LA SUMA
	end

	for i=1,#M.LG do--SUMA POR CADA COMPETENCIA DE CADA EVALUACION
		for j=1,M.cantComp do
			M.LGS[j] = M.LGS[j] + M.LG[i][j]
		end
	end
	---CONOCIMIENTO A PRIORI
	for i=1,M.cantComp do
		M.LCA[i] = M.LGS[i]/#M.LG 
	end
	--IMPRIMIMOS LISTA DE CALIFICACIONES PROMEDIO A PRIORI POR COMPETENCIA DE TODAS LAS EVALUACIONES TRAICIONALES
	M.conocimientoApriori = 0
	for i=1,#M.LCA do
		--print(M.listaAreaCompetencia[i].competencia..'A PRIORI COMPETENCIA:'..M.LCA[i])
		if M.competencia == M.listaAreaCompetencia[i].competencia then--VERIFICAMOS QUE COMPETENCIA ELIGIO 
			M.conocimientoApriori = M.LCA[i]/20--[escala de 0,1]
			M.conocimientoApriori = M.round(M.conocimientoApriori,4)--conocimiento a priori segun la competencia seleccionada
			print(M.listaAreaCompetencia[i].competencia..'CALIFICACION PROMEDIO EN LA COMPETENCIA:'..M.LCA[i])
			print('CONOCIMIENTO  PRIORI:'..M.conocimientoApriori)
			print('PROBBILIDD DE CONOCIMIENTO:'..(M.conocimientoApriori*100)..'%' ) 
			local _params = {
			    estudiante = M.scene.estudiante,
			    docente = M.scene.docente,
			    area = M.area,
			    competencia = M.listaAreaCompetencia[i],
			    idDocenteAula = M.idDocenteAula,
			    periodo = M.periodo,
			    conocimientoApriori = M.conocimientoApriori
			}
			--ELIMINAMOS DE MEMORIA MODULOS EXTERNOS
			package.loaded['src.pattern.dao.MatrizDao'] = nil
			package.loaded['src.pattern.dao.PeriodoDao'] = nil
			package.loaded['src.pattern.dao.EvaluacionTradicionalDao'] = nil
			package.loaded['src.pattern.controller.EvaluacionAdaptativaBusquedaSceneController'] = nil--THIS CONTROLLER
			M.scene.composer.gotoScene( "src.pattern.view.EvaluacionAdaptativaScene", { effect="fromRight", time=500, params=_params } )
			break
		end
	end	
	--resetemos valores
	M.LG,M.LGH,M.LGS,M.LCA ={},{},{},{},{}
	M.aux1,M.aux2 = 0,0
end

--FUNCION PARA REDONEDAR NUMEROS A LA CANTIDAD DE DECIMALES QUE SE DESEE
function M.round( num, numDecimalPlaces )--redondeamos numero
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

---------------------------------------------------------------
--TABLEVIEW
function M.onRowRender( event )
	local row = event.row
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    local competencia = display.newText( row, row.params.competencia, 0, 0, "src/fonts/Alessia.otf", 12 )
    competencia:setFillColor( 0,0,1 )
    competencia.anchorX = 0
    competencia.x = 90
    competencia.y = rowHeight/2-5

    local periodo = display.newText( row, row.params.periodo.periodo, 0, 0, "src/fonts/Alessia.otf", 10 )
    periodo:setFillColor( 0 )
    periodo.anchorX = 0
    periodo.x = competencia.x
    periodo.y = rowHeight/2+5

    local iconLabel = display.newImageRect(row, "src/images/evaluacion.png", 30, 30)
	iconLabel.x = 40
	iconLabel.y = rowHeight/2    
end

function M.onRowTouch( event )
	local phase = event.phase
	local row = event.target
	if phase == 'release' and M.scene.tableViewEvaluacionAdaptativa.alpha == 1 then
		M.competencia = row.params.competencia
		M.periodo = row.params.periodo
		M.area = row.params.area
		M.scene.tableViewEvaluacionAdaptativa.alpha = .5
		--FECHAS EVALUACIONES TRADICIONALES
		M.evaluacionTradicionalDao.new(M)
		M.evaluacionTradicionalDao.getFechas(M.scene.docente.dni,M.periodo,M.area)
		-------------------------
	end
end

return M