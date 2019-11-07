function load_image(img)
   love.graphics.newImage(img)
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
