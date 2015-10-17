function game_menu_miniload()
   huge_font = love.graphics.newFont("data/newscycle-bold.ttf", 48 )
   dirt =  love.graphics.newImage( "data/images/basic001.png" )
   grass = love.graphics.newImage( "data/images/basic002.png" )
   trees = love.graphics.newImage( "data/images/basic003.png" )
   house = love.graphics.newImage( "data/images/basic026.png" )
   garden = love.graphics.newImage( "data/images/basic046.png")
   donkey = love.graphics.newImage( "data/sprites/s024.png")
   girl   = love.graphics.newImage( "data/sprites/s003.png")
   logo3 = love.graphics.newImage( "data/images/logo3.png")
   minimap = { 
      {trees, trees, trees, trees, trees,trees},
      {trees, grass, grass, grass, grass,trees},
      {trees, trees, garden, grass, grass,trees},
      {trees, trees, house, grass, grass,trees},
      {trees, grass, grass, grass, grass,trees},
      {trees, trees, trees, trees, trees,trees}
   }
   
end

--function draw_merchant_sale_menu()
--end

function game_menu_draw()
   local row = 45
   local col1 = 100
   --big_font = love.graphics.newFont("data/newscycle-bold.ttf", 24 )
   --love.graphics.setFont( big_font )
   love.graphics.setColor(255,255,255,255)--outside white
   love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )
   love.graphics.setColor(255,255,255,255)--inside black
   --love.graphics.rectangle( "fill", 5, 5, love.graphics.getWidth()-10, love.graphics.getHeight()-10 )
   love.graphics.draw(title3,0,0,0, love.graphics.getWidth( )/title3:getWidth(),love.graphics.getHeight( )/title3:getHeight() )
   love.graphics.setColor(255,255,255,255)--white lettering
   love.graphics.setFont( huge_font )
	love.graphics.setColor(0,0,0,150)
   love.graphics.rectangle( "fill", 90, 140, 250, 360)
   love.graphics.setFont( big_font )
   love.graphics.setColor(255,255,255,255)
   love.graphics.print("New Game", col1, 100 +row*1 )
   love.graphics.print("Load Game", col1, 100 +row*2 )
   if game.map_generated == 0 then
      love.graphics.setColor(80,80,80,255)
   else
      love.graphics.setColor(255,255,255,255) end
   love.graphics.print("Save Game", col1, 100 +row*3 )
   love.graphics.setColor(255,255,255,255)
   --love.graphics.print("Love Version  (" ..game.version..")", col1, 100 +row*4 )
   love.graphics.print("Full Screen (" ..game.fullscreen_mode..")", col1, 100 +row*4 )
   love.graphics.print("Sound  ("..game.togglesound..")", col1, 100 +row*5 )
   love.graphics.print("Quit Game Without Save", col1, 100 +row*6 )
   if game.map_generated == 0 then
      love.graphics.setColor(80,80,80,255)
   else
      love.graphics.setColor(255,255,255,255)
   end
   love.graphics.print("Save/Quit Game", col1, 100 +row*7 )
   lx=0
   ly=0
   love.graphics.setColor(255,255,255,255)
end

function game_menu_mouse(x,y,button)
   local row = 45
   local col1 = 100
   if button == "l" then
      if x >= col1 and x <= 500 and y >=100 +row*1 and y <= 100 +row*2 then --new game
	game.show_menu = 2
      end
      if x >= col1 and x <= 500 and y >=100 +row*2 and y <= 100 +row*3 then --load game
	 game.started = 1
	 love_crude_load()
	 load_game_res()
	 game.show_menu = 0
      end
      if x >= col1 and x <= 500 and y >=100 +row*3 and y <= 100 +row*4 then --save game
	 if game.map_generated == 1 then
	    love_crude_save()
	    game.show_menu = 0
	 end
      end
      if x >= col1 and x <= 500 and y >=100 +row*4 and y <= 100 +row*5 then --toggle version
	 --if game.version == "0.9.0" then game.version = "0.8.0" 
	 --else game.version = "0.9.0" end
	if game.fullscreen_mode == "No" then game.fullscreen_mode = "Yes"
      	else game.fullscreen_mode = "No" end
      	go_fullscreen()
      end
      if x >= col1 and x <= 500 and y >=100 +row*5 and y <= 100 +row*6 then --toggle version
	 if game.togglesound == "on" then game.togglesound = "off" 
	 else game.togglesound = "on" end
      end
      if x >= col1 and x <= 500 and y >=100 +row*6 and y <= 100 +row*7 then --exit nosave
	 love.event.quit()
      end
      if x >= col1 and x <= 500 and y >=100 +row*7 and y <= 100 +row*8 then --exit nosave
	 if game.map_generated == 1 then
	    love_crude_save()
	    love.event.quit()
	 end
      end
   end
end

function select_biome_mouse(x,y,click)
   if mouse_clicked_inrect(x,y, 150,200,64,148) == 1 then
      game.biome = "forest"
      load_game_res() --load map
      game.started = 1
      create_new_scene(file)
      game.show_menu = 0
   elseif mouse_clicked_inrect(x,y, 250,200,64,148) == 1 then
      game.biome = "japan"
      load_game_res() --load map
      game.started = 1
      create_new_scene(file) --no longer in load_game_res because it breaks restore from save
      game.show_menu = 0
   elseif mouse_clicked_inrect(x,y, 350,200,64,148) == 1 then
      game.biome = "desert"
      load_game_res() --load map
      game.started = 1
      create_new_scene(file) --no longer in load_game_res because it breaks restore from save
      game.show_menu = 0
   elseif mouse_clicked_inrect(x,y, 450,200,64,148) == 1 then
      game.biome = "frost"
      load_game_res() --load map
      game.started = 1
      create_new_scene(file) --no longer in load_game_res because it breaks restore from save
      game.show_menu = 0
   end
   
end

function draw_biome_select() -- select your biome!
   love.graphics.print("Letownbuilder: Select your biome", 100,100)
   love.graphics.draw(biome_forest_img, 150, 200)
   love.graphics.draw(biome_japan_img, 250, 200)
   love.graphics.draw(biome_desert_img, 350, 200)
   love.graphics.draw(biome_frost_img, 450, 200)
   love.graphics.setColor(255,255,255,255)
   --love.graphics.draw(biome_desert_img, 450, 200)
end
