local composer = require 'composer'
local scene = composer.newScene()
--MODULOS EXTERNOS
local loginSceneController = require 'src.pattern.controller.LoginSceneController'
-------FUNCIONES--------------
function scene:crearMenu( )
	scene.background = display.newImage('src/images/background.png',display.contentCenterX,display.contentCenterY)
    scene.background.width = display.contentWidth+100
    scene.background.height = display.contentHeight

	scene.logo = display.newImage('src/images/logo.png',display.contentCenterX,display.contentCenterY-100)
    scene.logo.width = 80
    scene.logo.height = 80

	scene.txtUser = native.newTextField( display.contentCenterX, display.contentCenterY-20, 150, 20 )
    scene.txtUser.placeholder = 'User'
 	scene.txtUser.text = ''


    scene.txtPassword = native.newTextField( display.contentCenterX, display.contentCenterY+20, 150, 20 )
    scene.txtPassword.placeholder = 'Password'
	scene.txtPassword.text = ''
 	scene.txtPassword.isSecure = true

 	scene.imageUser = display.newImage('src/images/user.png',scene.txtUser.x - scene.txtUser.width/2-20,scene.txtUser.y)
    scene.imageUser.width = 20
    scene.imageUser.height = 20

    scene.imagePassword = display.newImage('src/images/password.png',scene.txtPassword.x - scene.txtPassword.width/2-20,scene.txtPassword.y)
    scene.imagePassword.width = 20
    scene.imagePassword.height = 20

 	scene.btnLogin = display.newImage('src/images/btnLogin.png',display.contentCenterX,display.contentCenterY+70)
    scene.btnLogin.width = 30
    scene.btnLogin.height = 30

    scene.group:insert(scene.background)
    scene.group:insert(scene.logo)
 	scene.group:insert(scene.txtUser)
 	scene.group:insert(scene.txtPassword)
 	scene.group:insert(scene.imageUser)
 	scene.group:insert(scene.imagePassword)
 	scene.group:insert(scene.btnLogin)
 	
	--CONTROLLER
	loginSceneController.new(scene)
	loginSceneController.initController()
end

function scene:create( event )
	scene.group = self.view 
	scene.composer = composer
    print( 'create LoginScene' )
    scene:crearMenu()
end


function scene:show( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'show LoginScene' )
	composer.removeScene( 'previusScene')
	end
end

function scene:hide( event )
	local phase = event.phase
	if phase == 'will' then
    print( 'hide LoginScene' )
	end
end

function scene:destroy( event )
    print( 'destroy LoginScene' )
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show')
scene:addEventListener( 'hide' )
scene:addEventListener( 'destroy' )

return scene