local M = {}
M.tai = require 'src.pattern.test.Tai'
M.estudiante = {}
function M.validarLogin(_user,_password)
	M.tai.new(M)
	M.tai.validarLogin(_user,_password)
end
--VALIDAMOS LOGIN
function M.validarLoginReceive(_estudiante)
	if _estudiante.dni~=nil then 
		M.tai.estudianteMatricula(_estudiante.dni)
	else
		native.showAlert('Nimodo', 'El usuario no existe, o contraseña incorrecta!', {'OK'}, function()end)	
	end
end
--VERIFICAMOS MATRICULA DEL ESTUDIANTE
function M.estudianteMatriculaReceive(_estudiante)
	if _estudiante.idaula~=nil then 
		M.estudiante = _estudiante
		M.tai.docenteAula(M.estudiante.grado,M.estudiante.seccion)--verificamos si existe docente asignado al aula
	else
		native.showAlert('Nimodo', 'No estas matriculado!', {'OK'}, function()end)	
	end
end
--VERIFICAMOS ASIGNACION DEL DOCENTE A UNA AULA
 function M.docenteAulaReceive(_docente)
	if _docente.iddocente_aula~=nil then 
		M.docente = _docente--DATOS DEL DOCENTE
		--local _params = {--enviamos como parametros datos del estudiante matriculado y del docente asignado a una aula
		--    estudiante = M.estudiante,
		--    docente = M.docente
		--}
		print( 'iddocenteaula: '..M.docente.iddocente_aula )
		M.idDocenteAula = M.docente.iddocente_aula
		--M.matrizDao.new(M)
		M.tai.matrizAreaRead(M.idDocenteAula)
		----PERIODOS
		--M.periodoDao.new(M)
		M.tai.periodoRead()
		--PASAMOS A LA SIGUIENTE ESCENA
		--M.scene.composer.gotoScene( "src.pattern.view.PrincipalScene", { effect="fromRight", time=500, params=_params } )
	else
		native.showAlert('Nimodo', 'No hay docente asignado al aula!', {'OK'}, function()end)	
	end		
end
---LISTA DE AREAS 
function M.matrizAreaReadReceive(_listaAreas)--lista de areas
	if #_listaAreas>0 then
		M.listaAreas = _listaAreas
		for i=1,#M.listaAreas do
			--M.matrizDao.matrizCompetenciaAreaRead(M.listaAreas[i].area,M.idDocenteAula)
			print(M.listaAreas[i].area)
		end
	else
		native.showAlert('Nimodo', 'Las evaluaciones estan desactivadas!', {'ok'}, function(event)end)
		--RESTABLECEMOS OPACIDAD DEL BOTON BUSCAR
		--M.scene.searchExam.alpha = 1
		--transition.to( M.scene.searchExam,{time = 200,xScale = 1,yScale = 1} )
	end
end
--LISTA DE PERIODOS
function M.periodoReadReceive(_listaPeriodo)--lista de periodos
	if #_listaPeriodo>0 then
		M.listaPeriodos = _listaPeriodo
		for i=1,#M.listaPeriodos do
			print( i )
		end
	else
		native.showAlert('Nimodo', 'No hay registro de Periodos!', {'ok'}, function(event)end)	
	end
end	

return M