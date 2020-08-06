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
      love.window.setFullscreen(true, "desktop")
   else --fullscreen_hack = "yes"
      love.window.setFullscreen(false, "desktop")
   end--fullscreen_hack == "no" then
   --g.screen_height = love.graphics.getHeight()
   --g.screen_width  = love.graphics.getWidth()
end
