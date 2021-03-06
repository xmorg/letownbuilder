--function show_tooltop_message(text, x,y) -- render.lua show text on mouseover 

function mouse_clicked_inrect(x,y, cx, cy, cw, ch) -- clicked in a rectangle
   if y >= cy and y <= cy+ch and 
   x >= cx and x <= cx+cw then
      return 1
   else
      return 0
   end
end

function mouse_clicked_inphonerect(x,y, cx,cy)
   
end

function love.mousereleased(x, y, button)
   if button == 1 then
      if game.give_direction == "Scrolling" then
	 game.give_direction = "None"
      end
   end
end

function map_edge_detect(x,y) -- detect the edge of the map altering jobs from being done there.
	if x==1 or y==1 then 
	end
end

function on_plow_where_click()
   if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      game_directives.job_type = "None."
      game_directives.active = 0
      game.give_direction = "Clear this area first"
   elseif kingdom_inventory.seeds < 3 then
      game_directives.job_type = "None"
      game_directives.active = 0
      game.give_direction = "Not enough seeds"
      message_que_add("Not enough seeds (Seeds: 3)", 80, 41)
   else
      update_directives_loc(300, 1)
      game_directives.job_type = "Make garden"
      game.give_direction = "Plow where?"  --"None"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "farmer")
      --if garden_type == "wheat" then
      -- game.house_to_build = 42
      --elseif garden_type == "tomatoes" then
      -- game.house_to_build = 1042 --are we using 1000?
      --end
      create_job_forque()
      play_sound(sound_click)
      kingdom_inventory.seeds = kingdom_inventory.seeds-3
   end -- game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
end

function on_tomatoes_where_click()
   if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      game_directives.job_type = "None."
      game_directives.active = 0
      game.give_direction = "Clear this area first"
   elseif kingdom_inventory.seeds < 5 then
      game_directives.job_type = "None"
      game_directives.active = 0
      game.give_direction = "Not enough seeds"
      message_que_add("Not enough seeds (Seeds: 5)", 80, 41)
   else
      update_directives_loc(300, 1)
      game_directives.job_type = "Plant tomatoes"
      game.give_direction = "Tomatoes where?"  --"None"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "farmer")
      create_job_forque()
      play_sound(sound_click)
      kingdom_inventory.seeds = kingdom_inventory.seeds-5
   end -- game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
end

function on_cut_where_click()
   if (game.biome == "forest" or game.biome == "frost") and
      game_map[game.tile_selected_y][game.tile_selected_x] >= 3 and
   game_map[game.tile_selected_y][game.tile_selected_x] <= 20 then
      update_directives_loc(300, 1)
      game_directives.job_type = "Cut trees"
      game.give_direction = "Cut where?"
      villagers_do_job(game_directives.location_x, game_directives.location_y , "woodcutter")
      create_job_forque()
      play_sound(sound_treecutting)
      --17-20 desert, has limited "trees"
   elseif game.biome == "desert" and game_map[game.tile_selected_y][game.tile_selected_x] >= 17 and
   game_map[game.tile_selected_y][game.tile_selected_x] <= 20 then
      update_directives_loc(300, 1)
      game_directives.job_type = "Cut trees"
      game.give_direction = "Cut where?"
      villagers_do_job(game_directives.location_x, game_directives.location_y , "woodcutter")
      create_job_forque()
      play_sound(sound_treecutting)
   elseif game.biome == "japan" and game_map[game.tile_selected_y][game.tile_selected_x] >= 3 and
   game_map[game.tile_selected_y][game.tile_selected_x] <= 9 then
      --japan 3-9 sakura, 10-20 bamboo
      update_directives_loc(300, 1)
      game_directives.job_type = "Cut sakura"
      game.give_direction = "Cut where?"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "woodcutter")
      create_job_forque()
      play_sound(sound_treecutting)
   elseif game.biome == "japan" and game_map[game.tile_selected_y][game.tile_selected_x] >= 10 and
   game_map[game.tile_selected_y][game.tile_selected_x] <= 20 then
      update_directives_loc(300, 1)
      game_directives.job_type = "Cut bamboo"
      game.give_direction = "Cut where?"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "woodcutter")
      create_job_forque()
      play_sound(sound_treecutting)
   else
      game_directives.job_type = "No Trees here" --error you cant find any wood here.
      game_directives.active = 0
      game.give_direction = "No Trees here"
   end -- game_map[game.tile_selected_y][game.tile_selected_x] 
end

function on_dig_where_click()
   if game.biome == "desert" then --you can dig almost anywhere in a desert.
      if game_map[game.tile_selected_y][game.tile_selected_x] > 17 then
	 game_directives.job_type = "None."
	 game_directives.active = 0
	 game.give_direction = "Clear this area first"
      else
	 update_directives_loc(300, 1)
	 game_directives.job_type = "Dig hole"
	 game.give_direction = "Dig where?"
	 villagers_do_job(game_directives.location_x, game_directives.location_y, "miner")
	 create_job_forque()
	 play_sound(sound_click)
      end --desert
   elseif game_map[game.tile_selected_y][game.tile_selected_x] > 2 and
      game_map[game.tile_selected_y][game.tile_selected_x] ~= 55 and
   game_map[game.tile_selected_y][game.tile_selected_x] ~= 56 then
      
      game_directives.job_type = "None."
      game_directives.active = 0
      game.give_direction = "Clear this area first"
   else
      update_directives_loc(300, 1)
      game_directives.job_type = "Dig hole"
      game.give_direction = "Dig where?"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "miner")
      create_job_forque()
      play_sound(sound_click)
   end -- if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
end

function mouse_clicked_in32(x, y, icon_x, icon_y)
   if y >= icon_y and y <= icon_y +32 and x >= icon_x and x <= icon_x+32 then
      return 1
   else
      return 0
   end
end

function mouse_clicked_in64(x, y, icon_x, icon_y)
   local bs = game.button_size
   if y >= icon_y and y <= icon_y +bs and x >= icon_x and x <= icon_x+bs then
      return 1
   else
      return 0
   end
end

function mouse_clicked_on_selectresearch(x,y)
   local bs = game.button_size
   --if x >= 0 and x <= 64*1 and y >=64*5 and y <= 64*5+64 then
   if mouse_clicked_in64(x, y, 0, bs*5) == 1 then
      game.give_direction = "None"
      --elseif x >= 64*1 and x <= 64*2 and y >=64*5 and y <= 64*5+64 then
   elseif mouse_clicked_in64(x, y, bs*1, bs*5) == 1 then
      game.give_direction = "Research economy"
      game_directives.research_type = "Research economy"
      game.research_timer = 5000
   elseif mouse_clicked_in64(x,y, bs*2, bs*5) == 1 then --x >= 64*2 and x <= 64*3 and y >=64*5 and y <= 64*5+64 then
      game.give_direction = "Research security"
      game_directives.research_type = "Research security"
      game.research_timer = 5000
   elseif mouse_clicked_in64(x,y,bs*3, bs*5) == 1 then --x >= 64*3 and x <= 64*4 and y >=64*5 and y <= 64*5+64 then
      game.give_direction = "Research agriculture"
      game_directives.research_type = "Research agriculture"
      game.research_timer = 5000
   elseif mouse_clicked_in64(x,y,bs*4, bs*5) == 1 then --x >= 64*4 and x <= 64*5 and y >=64*5 and y <= 64*5+64 then
      game.give_direction = "Research civics"
      game_directives.research_type = "Research civics"
      game.research_timer = 5000
   elseif mouse_clicked_in64(x,y,bs*5, bs*5) == 1 then --x >= 64*5 and x <= 64*6 and y >=64*5 and y <= 64*5+64 then
      game.give_direction = "Research industry"
      game_directives.research_type = "Research industry"
      game.research_timer = 5000
   elseif game.give_direction == "Research" then
      on_click_research_buttons(x,y)
   end
end

function mouse_clicked_on_selecthousetobuild(x, y)
   local bs = game.button_size
   if mouse_clicked_in64(x,y, bs*0, bs*3) == 1 then
      game.give_direction = "None"
   elseif mouse_clicked_in64(x,y, bs*1, bs*3) == 1 then
      build_house_directive("Build house", 23, 23)
   elseif mouse_clicked_in64(x,y, bs*2, bs*3) == 1 then --x >= 64*2 and x <= 64*(2+1) and y >=64*3 and y <= 64*3+64 then --house2
      build_house_directive("Build house", 24, 24)
   elseif mouse_clicked_in64(x,y, bs*3, bs*3) == 1 then --x >= 64*3 and x <= 64*(3+1) and y >=64*3 and y <= 64*3+64 then --house3
      build_house_directive("Build house", 25, 25)
   elseif mouse_clicked_in64(x,y, bs*4, bs*3) == 1 then --x >= 64*4 and x <= 64*(4+1) and y >=64*3 and y <= 64*3+64 then --house4
      build_house_directive("Build house", 26, 26)
   elseif mouse_clicked_in64(x,y, bs*5, bs*3) == 1 then --x >= 64*5 and x <= 64*(5+1) and y >=64*3 and y <= 64*3+64 then --mine
      build_house_directive("Build house", 27, 27)
   elseif mouse_clicked_in64(x,y, bs*6, bs*3) == 1 then --x >= 64*6 and x <= 64*(6+1) and y >=64*3 and y <= 64*3+64 then --school
      build_house_directive("Build house", 51, 51)
   elseif mouse_clicked_in64(x,y, bs*7, bs*3) == 1 then --x >= 64*7 and x <= 64*(7+1) and y >=64*3 and y <= 64*3+64 then --barn
      build_house_directive("Build house", 52, 52)
   elseif mouse_clicked_in64(x,y, bs*8, bs*3) == 1 then --x >= 64*8 and x <= 64*(8+1) and y >=64*3 and y <= 64*3+64 then --graveyard
      build_house_directive("Build house", 53, 53)
   elseif mouse_clicked_in64(x, y, bs*1, bs*4) == 1 then --***** Economy *******
      if research_topics.economy >= 1 then
	 build_house_directive("Build house", 66, 66)--trade post
      end
   elseif mouse_clicked_in64(x, y, bs*2, bs*4) == 1 then --****** Security ******
      if research_topics.security >= 1 then
	 build_house_directive("Build house", 67, 67)--sharrifs office
   end
	--quick_task_icon64(64*4,64*4, 60, "militia", 1, "game_tiles")
   elseif mouse_clicked_in64(x, y, bs*4, bs*4) == 1 then
      if research_topics.militia_house >= 1 then
	 build_house_directive("Build house", 60,60)--militia house (needs resource check)
      end
   elseif mouse_clicked_in64(x, y, bs*3, bs*4) == 1 then
      if research_topics.industry >= 1 then
	 build_house_directive("Build house", 55, 55)--fishing hut
      end	 
   elseif mouse_clicked_in64(x, y, bs*5, bs*4) == 1 then
      if research_topics.mayors_monument >= 1 then
	 build_house_directive("Build house", game.mayor_sex, game.mayor_sex)--mayors monument
      end
   elseif mouse_clicked_in64(x, y, bs*6, bs*4) == 1 then
      if research_topics.watchtower >= 1 then
	 build_house_directive("Build house", 65, 65)--watchtower
      end
   elseif mouse_clicked_in64(x, y, bs*7, bs*4) == 1 then
      if research_topics.smelter >= 1 then
	 build_house_directive("Build house", 70, 70)--smelter
      end
   elseif mouse_clicked_in64(x, y, bs*8, bs*4) == 1 then
      if research_topics.brewery >= 1 then
	 build_house_directive("Build house", 71, 71)--brewery
      end
      ---------------row 3-------------------------------
   elseif mouse_clicked_in64(x, y, bs*1, bs*5) == 1 then
      if research_topics.smithy  >= 1 then
	 build_house_directive("Build house", 64, 64)--smithy
      end
   elseif mouse_clicked_in64(x, y, bs*2, bs*5) == 1 then
      if research_topics.church  >= 1 then
	 --build_house_directive("Build house", 72, 1) then
	 build_house_directive("Build house", 71, 71)--brewery
      end
      ---------------row 3-------------------------------
   elseif mouse_clicked_in64(x, y, bs*1, bs*5) == 1 then
      if research_topics.smithy  >= 1 then
	 build_house_directive("Build house", 64, 64)--smithy
      end
   elseif mouse_clicked_in64(x, y, bs*2, bs*5) == 1 then
      if research_topics.church  >= 1 then
	 build_house_directive("Build house", 72, 72)--church
      end --research_topics.church  >= 1 then
   end--mouse_clicked_in64(x, y, 64*2, 64*5) == 1 then
end

function on_clicked_rosterbutton(x,y)
   col_one = 80
   col_two = 160
   col_three = 240
   col_four = 328
   col_five = 428
   row_num = 1
   if mouse_clicked_inrect(x,y, col_one-3, 20+68, 60, 23) == 1 then
      game.records_tab = 1
      game.roster_selected = "villagers"
   elseif mouse_clicked_inrect(x,y, col_two-3, 20+68, 60, 23) == 1 then  -- food?
      game.records_tab = 2
      game.roster_selected = "food"
   elseif mouse_clicked_inrect(x,y, col_three-3, 20+68, 60, 23) == 1 then  -- resources?
      game.records_tab = 3
      game.roster_selected = "resources"
   elseif mouse_clicked_inrect(x,y, col_four-3, 20+68, 60, 23) == 1 then
      game.records_tab = 4
      game.roster_selected = "messages"
   else return 0
   end
   return 1
end

function on_new_quickbutons(x,y) --- new QUICK BUTTONS, (android friendly)
   local bs = game.button_size
   --if mouse_clicked_in64(x, y, 536, 0) == 1 then --records
   --note! this icons are still 64x64 and could create display issues if resized
   if x >= 536 and x <= 536+64 and y >=0 and y <= 64 then 
      if game.game_roster == 0 then 
	 game.game_roster = 1
      else 
	 game.game_roster = 0
      end
   elseif x >= 536+64 and x <= 536+64*2 and y >=0 and y <= 64 then --mouse_clicked_in64(x, y, 536+bs, 0) == 1 then --zoom
      if game.zoom_level == 2 then game.zoom_level = 1
      else game.zoom_level = 2 end
   elseif x >= 536+64*2 and x <= 536+64*3 and y >=0 and y <= 64 then--mouse_clicked_in64(x, y, 536+bs*2, 0) == 1 then --menu
      if game.show_menu == 0 then game.show_menu = 1 --
      elseif game.show_menu == 7 and game.started == 1 then game.show_menu = 0
      elseif game.show_menu == 7 then game.show_menu = 1
      elseif game.show_menu == 99 then game.show_menu = 1
      else 
	 if game.started == 1 then game.show_menu = 0 end 
      end
   end
end

function on_clicked_buttons(x,y)---------------------QUICK BUTTONS
   local bs = game.button_size
   function on_select_job(x,y)
      --nothing
      return 0
   end
   
   on_new_quickbutons(x,y)
   if mouse_clicked_in64(x, y, 0, bs*1) == 1 then --Select job
      if game.give_direction == "Select job" then
	 game.give_direction = "None" --unselect job
      else
	 game.give_direction = "Select job" --select job
      end --end
   elseif mouse_clicked_in64(x, y, 0, bs*2) == 1 then --Gather Food
      game.give_direction = "Gather Food"
   elseif mouse_clicked_in64(x, y, 0, bs*3) == 1 then --Build House
      if game.give_direction == "Select house to build" then
	 game.give_direction = "None"
      else
	 game.give_direction = "Select house to build" --"Build house"
      end
   elseif mouse_clicked_in64(x, y, 0, bs*4) == 1 then --Build Road
      if game.give_direction == "Select road to build"  then
	 game.give_direction = "None"
      else
	 game.give_direction = "Select road to build"
      end
   elseif mouse_clicked_in64(x, y, 0, bs*5) == 1 then --and game.give_direction == "None" then
      if get_kingdom_researchable() == 1 and game.give_direction == "Research" then
	 game.give_direction = "None" -- check for researchables
      elseif get_kingdom_researchable() == 1 then
	 game.give_direction = "Research" -- check for researchables
      end
   elseif game.game_roster == 1 then
      on_clicked_rosterbutton(x,y)
   elseif  mouse_clicked_in64(x,y, 0, bs) == 1 then
      game.give_direction = "None"
   elseif mouse_clicked_in64(x,y, bs*1, bs) == 1 then
      game.give_direction = "Cut where?" --pressed axe
   elseif mouse_clicked_in64(x,y, bs*2, bs) == 1 then
      game.give_direction = "Dig where?" --spressed shovel
   elseif mouse_clicked_in64(x,y, bs*3, bs) == 1 then
      game.give_direction = "Plow where?" --farming!
   elseif mouse_clicked_in64(x,y, bs*4, bs) == 1 then
      game.give_direction = "Hunt what?" -- hunting
   elseif mouse_clicked_in64(x,y, bs*5, bs) == 1 then
      game.give_direction = "Make fire where?"
   elseif mouse_clicked_in64(x,y, bs*6, bs) == 1 then
      game.give_direction = "Demolish what?"
   elseif mouse_clicked_in64(x,y, bs*7, bs) == 1 then
      if research_topics.tomatoes == 1 then
	 game.give_direction = "Plant tomatoes"
      end
   elseif game.give_direction == "Research" then
      mouse_clicked_on_selectresearch(x,y)
      -- ************** Do Job
   elseif game.give_direction == "Demolish what?" then
      on_demolish_structure()
   elseif game.give_direction == "Hunt what?" then
      on_hunt_something(x,y)
   elseif game.give_direction == "Gather Food" then
      on_gather_food() --buildings.lua
   elseif game.give_direction == "Cut where?" then
      on_cut_where_click()
   elseif game.give_direction == "Plow where?" then
      on_plow_where_click()
   elseif game.give_direction == "Plant tomatoes" then
      on_tomatoes_where_click()
   elseif game.give_direction == "Dig where?" then
      on_dig_where_click()
   elseif game.give_direction == "Select job" then
      on_select_job(x,y) -- click the job you want.
      -------------- SELECT HOUSE TO BUILD ------------------------
   elseif game.give_direction == "Select house to build" then
      mouse_clicked_on_selecthousetobuild(x, y)
   else --no "buttons" where clicked"
      return 0
   end --elseif game.give_direction == "Select house to build" then
   return 1 -- a button was probably clicked?
end --on clicked buttons

function love.mousereleased(x,y,button)
   if button == 1 then
      game.scroll_direction = "none"
   end
end

function love.mousepressed(x, y, button)
   local bs = game.button_size
   if button == 1 then -- 1 l
      game.printx = x		--game.printx = 0 -- 0  -62
      game.printy = y      --game.printy = 0 -- 536-600 --0, 64
      if game.show_menu == 1 then -- Title menus
	 game_menu_mouse(x,y,"l")
      elseif game.show_menu == 2 then
	 select_biome_mouse(x,y,"l")
      elseif game.show_menu == 7 then
      	--64 at screen corner
      	  if mouse_clicked_inrect(x,y, love.graphics.getWidth( )-bs, 0, bs, bs) == 1 then
      	  	game.show_menu = 1
      	  end
      else --no menus are up
	 --is this the menu for scrolling? add game.give_direction = "None" to prevent doing more clicks.
	 function set_game_dir_to_none() --stopping the moue bug where you try to move when you are on "Select job"
	 	if game.give_direction == "Select job" then return 0
 		else game.give_direction = "None"
 		end
	 end
	 --scrolling
	 if mouse_clicked_in32(x, y, game.screen_width-64-128, game.screen_height-70)==1 then
	    game.scroll_direction = "left" set_game_dir_to_none()
	 elseif mouse_clicked_in32(x, y, game.screen_width-64-88, game.screen_height-42)==1 then
	    game.scroll_direction = "down" set_game_dir_to_none()
	 elseif mouse_clicked_in32(x, y, game.screen_width-64-80,game.screen_height-128) == 1 then
	    game.scroll_direction = "up" set_game_dir_to_none()
	 elseif mouse_clicked_in32(x, y, game.screen_width-64-40, game.screen_height-80) ==1 then
	    game.scroll_direction = "right" set_game_dir_to_none()
	 else
	    game.scroll_direction = "none"
	 end
	 
	 --update tile location
	 --mouse_x, mouse_y = love.mouse.getPosition()
	 --for y = 1, game.tilecount do
	 --   for x = 1, game.tilecount do
	       --lx = (300+(y - x) * 32 + 64) * game.zoom_level
	       --ly = (-100+(y + x) * 32 / 2 + 50) * game.zoom_level
	 --      local w = game.tilewidth_fx -- width and height of the tiles
	 --      local h = 100-68	 -- minus dead air
	 --      local lx = (x - y) * w/2 + game.draw_x
	 --      local ly = (y + x) * h/2  + game.draw_y
	       -- function -----  game tiles map table ---- isometric loc
	 --      if(mouse_x >= lx and mouse_x <= lx+w and
	--	  mouse_y >= ly and mouse_y <= ly+h) then
		  --put the number of the selected tile
	--	  game.tile_selected_x = x
	--	  game.tile_selected_y = y
	--	  game.loc_selected_x = lx+ 32
	--	  game.loc_selected_y = ly+ 16
	--       end--endif
	--    end--endfor x
	-- end--endfor y
	 --update_mouse_to_tile(dt)
	 
	 if on_clicked_buttons(x,y) == 1 then --you clicked a button, but other code will run after?
	    --nothing, just testing that it was done
	 elseif game.give_direction == "Select road to build" then --28,36
	    for i = 0, 10 do
	       if y >= bs*4 and y <= bs*4+bs and x >= bs*i and x <= bs*(i+1) then
		  if i*bs == 0 then
		     game.give_direction = "None"
		  else
		     game.give_direction = "Build road"
		     game.road_to_build = 27+i --1 or higher because of if
		  end
	       end--endif
	    end --endfor
	    for i = 0, 2 do
	       if y >= bs*5 and y <= bs*5+64 and x >= bs*i and x <= bs*(i+1) then
		  if i*bs == 0 then
		     game.give_direction = "None"
		  else
		     game.give_direction = "Build bridge"
		     game.house_to_build = 20+i
		  end --endif
	       end -- endif
	    end --endfor
	 elseif game.give_direction == "Make garden" then --Garden
	    on_build_garden("wheat")
	 elseif game.give_direction == "Plant tomatoes" then
	    on_build_garden("tomatoes")
	 elseif game.give_direction == "Hunt What?" then
	    on_hunt_something(x,y) --villagers.lua
	 elseif game.give_direction == "Make bonfire" then
	    on_build_bonfire()
	 elseif game.give_direction == "Make fire where?" then
	    on_build_bonfire()
	 elseif game.give_direction == "Build house" then
	    on_build_house()  --buildings.lua
	 elseif game.give_direction == "Build bridge" then
	    on_build_bridge() --buildings.lua
	 elseif game.give_direction == "Build road" then
	    on_build_road()   --buildings.lua
	 end
	 for i,v in ipairs(game_villagers) do
	    if mouse_clicked_inrect(x,y,game_villagers[i].x+game.draw_x, 
				    game_villagers[i].y+game.draw_y, 10, 10) == 1 then
	       game_villagers[i].selected = 1
	    else
	       game_villagers[i].selected = 0
	    end
	 end --end for i,v in ipairs(game_villagers) do
      end --end menu type
   elseif button == "r" then -- right mousoe button?
      local lx = 0
      local ly = 0
      for y = 1, game.tilecount do --loopy
	 for x = 1, game.tilecount do --loopx
	    --lx = 300+(y - x) * 32 + 64      --create isometric
	    --ly = -100+(y + x) * 32 / 2 + 50  --tile blit locations
	    local w = game.tilewidth_fx -- width and height of the tiles
	    local h = 100-68	 -- minus dead air
	    local lx = (x - y) * w/2 + game.draw_x
	    local ly = (y + x) * h/2  + game.draw_y
	    if x == game.tile_selected_x and y == game.tile_selected_y then
	       for i,v in ipairs(game_villagers) do
		  if game_villagers[i].position == "militia captain" and game_villagers[i].selected==1 then
		     game_villagers[i].dx = lx+16 --+game.draw_x
		     game_villagers[i].dy = ly+60 --+game.draw_y
		  end
	       end
	    end
	 end
      end
   end --end left/right click
end --end function

function get_tooltip_info_from_item() --ran in update?
   mx = love.mouse.getX() --mouse x coord
   my = love.mouse.getY() --mouse y coord
   scrw = love.graphics.getWidth() --screen width
   scrh = love.graphics.getHeight() --screen height
   --if mouse_clicked_inrect(mx,my, 600, 1, 32, 32)== 1 then --wood
   if mouse_clicked_inrect(mx,my, 536, 1, 64, 64)== 1 then
      game.tooltip_text = "Town records"
      --elseif mouse_clicked_inrect(mx,my, 600, 32, 32, 32)== 1 then --wood
      --	game.tooltip_text = "pause game"
      --elseif mouse_clicked_inrect(mx,my, 632, 1, 32, 32)== 1 then --wood
      --   game.tooltip_text = "load game"
      --elseif mouse_clicked_inrect(mx,my, 632, 32, 32, 32)== 1 then --wood
      --	game.tooltip_text = "controller"
   elseif mouse_clicked_inrect(mx,my, 600, 1, 64, 64)== 1 then --wood
      game.tooltip_text = "Zoom"
   elseif mouse_clicked_inrect(mx,my, 664, 1, 64, 64)== 1 then --wood
      game.tooltip_text = "Menu"
      --elseif mouse_clicked_inrect(mx,my, 696, 1, 32, 32)== 1 then --wood
      --   game.tooltip_text = "save and exit"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 1, 32, 32)== 1 then --wood
      game.tooltip_text = "wood"
   elseif mouse_clicked_inrect(mx,my, scrw-32, 1, 32,32) == 1 then --sakura
      game.tooltip_text = "sakura"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 32, 32,32)== 1 then --sakura
      game.tooltip_text = "rocks"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 32, 32,32) == 1 then --sakura
      game.tooltip_text = "bamboo"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 64, 32,32)== 1 then --sakura
      game.tooltip_text = "fish"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 64, 32,32) == 1 then --sakura
      game.tooltip_text = "iron ore"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 96, 32,32)== 1 then --sakura
      game.tooltip_text = "cherries"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 96, 32,32) == 1 then --sakura
      game.tooltip_text = "gold ore"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 128, 32,32)== 1 then --sakura
      game.tooltip_text = "carrots"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 128, 32,32) == 1 then --sakura
      game.tooltip_text = "iron bars"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 160, 32,32)== 1 then --sakura
      game.tooltip_text = "tomatoes"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 160, 32,32) == 1 then --sakura
      game.tooltip_text = "gold bars"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 192, 32,32)== 1 then --sakura
      game.tooltip_text = "meat"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 192, 32,32) == 1 then --sakura
      game.tooltip_text = "wheat"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 224, 32,32)== 1 then --sakura
      game.tooltip_text = "sansai"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 224, 32,32) == 1 then --sakura
      game.tooltip_text = "apples"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 256, 32,32)== 1 then --sakura
      game.tooltip_text = "fish wine"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 256, 32,32) == 1 then --sakura
      game.tooltip_text = "pale ale"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 288, 32,32)== 1 then --sandstone
      game.tooltip_text = "sandstone"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 288, 32,32) == 1 then --wild onions
      game.tooltip_text = "wild onions"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 320, 32,32) == 1 then --sakura
      game.tooltip_text = "pelts"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 320, 32,32) == 1 then --pelts
      game.tooltip_text = "seeds"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 352, 32,32) == 1 then --sakura
      game.tooltip_text = "weapons"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 352, 32,32) == 1 then --pelts
      game.tooltip_text = "tools"
   elseif mouse_clicked_inrect(mx,my, scrw-30, 352+32, 32,32) == 1 then --sakura
      game.tooltip_text = "coins"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 352+32, 32,32) == 1 then --pelts
      game.tooltip_text = "treasures"
   elseif mouse_clicked_inrect(mx,my, scrw-64, 352+64,32,32) == 1 then
      game.tooltip_text = "mushrooms"
   else 
      game.tooltip_text = "NONE"
   end
end

function update_checkscrolling(mx, my)
   if game.mouse_last_x > mx and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x-game.scroll_speed
   elseif game.mouse_last_x < mx and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_x = game.draw_x+game.scroll_speed
   end
   if game.mouse_last_y >  my and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y-game.scroll_speed
   elseif game.mouse_last_y <  my and love.mouse.isDown(1) and game.give_direction == "Scrolling" then
      game.draw_y = game.draw_y+game.scroll_speed
   end
   if love.keyboard.isDown("up") or game.scroll_direction == "up" then
      game.draw_y = game.draw_y+game.scroll_speed
   elseif love.keyboard.isDown("down") or game.scroll_direction == "down"  then
      game.draw_y = game.draw_y-game.scroll_speed
   elseif love.keyboard.isDown("left") or game.scroll_direction == "left" then
      game.draw_x = game.draw_x+game.scroll_speed
   elseif love.keyboard.isDown("right") or game.scroll_direction == "right" then
      game.draw_x = game.draw_x-game.scroll_speed
   end
end
