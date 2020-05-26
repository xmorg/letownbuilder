function graphics_getWidth()
   return love.graphics.getWidth()
end
function graphics_getHeight()
   return love.graphics.getHeight()
end

function love_graphics_setMode080()
   love.graphics.setMode(0, 0, true, false)  -- 0.8.0
   love.graphics.setMode(love.graphics.getMode())
end
function love_graphics_setMode()
   
end
function gdraw(i, x, y)
   love.graphics.draw(i, x, y)
end
function gpush()
   love.graphics.push()
end
function gpop()
   love.graphics.pop()
end
function gscale(g)
   love.graphics.scale(g)
end
function load_image(img)
   love.graphics.newImage(img)
end

function load_font(fnt)
   return love.graphics.newFont(fnt)
end
function set_font( f )
   love.graphics.setFont(f)
end

function love_audio_play(s)
   love.audio.play(s)
end

function love_window_setFullScreen( b )
   love.window.setFullscreen( b )
end

function love_graphics_setMode(x, y, b1, b2)
   love.graphics.setMode(800, 600, false, false)
end

function love_window_setMode(x,y)
   love.window.setMode(x,y)
end

function go_fullscreen(g) --moved from main
   if fullscreen_hack == "no" then
      if g.version == "0.8.0" then 
	 love.graphics.setMode(0, 0, true, false)  -- 0.8.0
	 love.graphics.setMode(love.graphics.getMode())
      else 
	 --flags = {
	 --   fullscreen = true,
	 --   fullscreentype = "normal",
	 --   vsync = true,
	 --   fsaa = 0,
	 --   resizable = false,
	 --   borderless = false,
	 --   centered = true,
	 --   display = 1,
	 --   minwidth = 1,
	 --   minheight = 1 
	 --}		
	 --love.window.setMode( 0, 0, flags )
	 love_window_setFullscreen( true )
	 fullscreen_hack = "yes"
      end -- 0.9.0
   else --fullscreen_hack = "yes"
      if g.version == "0.8.0" then 
	 love_graphics_setMode(800, 600, false, false)  -- 0.8.0
	 --love.graphics.setMode(love.graphics.getMode())
      else 
	 flags = { fullscreen = false,		vsync = true,
		   resizable = false,borderless = false,centered = true,	display = 1,
		   minwidth = 1,minheight = 1 } --fsaa = 0,invalid window setting
	 --fullscreentype = "normal",
	 love_window_setMode( 800, 600 )--, flags ) 
      end -- version == "0.8.0" then 
      fullscreen_hack = "no"
   end--fullscreen_hack == "no" then
   g.screen_height = love.graphics.getHeight()
   g.screen_width  = love.graphics.getWidth()
end
