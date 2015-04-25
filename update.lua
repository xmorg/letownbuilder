--main update functions, 
--increment day time and
function brew_drink() -- brew drinks at brewery, do in order of preference
   if kingdom_inventory.grain > 0 then
      --brew
      if kingdom_inventory.fish > 1 then
	 kingdom_inventory.grain = kingdom_inventory.grain-1
	 kingdom_inventory.fish = kingdom_inventory.fish-1
	 kingdom_inventory.fishwine = kingdom_inventory.fishwine+1
      else
	 kingdom_inventory.grain = kingdom_inventory.grain-1
	 kingdom_inventory.paleale = kingdom_inventory.paleale+1
      end
   else
      --add message "your brewery needs wheat to make drinks"
   end
end

function villagers_complete_jobs_by_buildings()
   if kingdom_inventory.brewery > 0 then
      for i=0, kingdom_inventory.brewery do
	 brew_drink()
      end
   end
   if kingdom_inventory.mine > 0 then
      kingdom_inventory.rocks = kingdom_inventory.rocks +
	 (kingdom_inventory.mine * (table.getn(game_villagers)*2))
      --need to put a random ore/iron/gold find
      found_ore = math.random(-20,5) --problem with this is you can only find 5
      found_gold = math.random(-200,5)--problem with this is you can only find 5
      if found_ore > 0 then
	 kingdom_inventory.iron_ore = kingdom_inventory.iron_ore+found_ore
      end
      if found_gold > 0 then
	 kingdom_inventory.gold_ore = kingdom_inventory.gold_ore+found_gold
      end
   end--if mine > 0
   if kingdom_inventory.smelter > 0 then
      for x = 1, kingdom_inventory.smelter do
	 for y = 1, 5 do
	    if kingdom_inventory.gold_ore > 0 then
	       kingdom_invetory.gold_ingots = kingdom_inventory.gold_ingots+1
	       kingdom_inventory.gold_ore = kingdom_inventory.gold_ore -1
	    elseif kingdom_inventory.iron_ore > 0 then
	       kingdom_inventory.iron_ingots = kingdom_inventory.iron_ingots+1
	       kingdom_inventory.iron_ore = kingdom_inventory.iron_ore -1
	    end
	 end --endfor
      end --endfor
   end --endif
end --endfunction

function update_run_daytimer() 
	if game.day_time < 24000 then
      game.day_time = game.day_time+1
      --sound_daytime     = love.audio.newSource("data/sounds/wind_1_wbirds.ogg", "static")
      --sound_nighttime = love.audio.newSource("data/sounds/wind_2_night.ogg", "static")
      if is_night() == 0 then --daytime
      	if music_townbg1:isPlaying() == false then music_townbg1:play() end
      	if music_nightbg1:isPlaying() == true then music_nightbg1:stop() end
      else --its night
      	if music_townbg1:isPlaying() == true then music_townbg1:stop() end
      	if music_nightbg1:isPlaying() == false then music_nightbg1:play() end
      end
      if is_night() == 0 and math.random(1,240) == 1 then --daytime   
      	play_sound(sound_light_breeze)
      elseif is_night() == 0 and math.random(1,240) == 2 then
      	play_sound(sound_daytime)
      elseif is_night() == 1 and math.random(1,240) == 1 then
      	play_sound(sound_nighttime)
      end
      --kingdom_inventory.villagers = table.getn(game_v
      --loop through villagers and loop thround villager timers
      for i,v in ipairs(game_villagers) do
	 check_for_disease(i) --run disease loop here.
      end--end for
      if game.day_time == 12000 then
	 villagers_eat_food(table.getn(game_villagers))
	 if kingdom_inventory.unrest >= 70 then
	    villagers_rioting_report(game_villagers)
	 end
      elseif game.day_time == 11000 then
	 daily_update_map()
      elseif game.day_time == 8000 then
	 merchants_arrive()
      elseif game.day_time == 17000 then
	 villagers_complete_jobs_by_buildings() --check for buildings and, apply resources.
      elseif game.day_time == 21000 then
	 villagers_seek_shelter(table.getn(game_villagers))
      elseif game.day_time % 1000 == 0 then
	 hourly_update_map()
      end
   else -- reset timer
      game.day_time = 0
      game.day_count = game.day_count+1
   end
end --update_run_daytimer()

-- new code, not implented the "job que" will allow for multiple jobs
function new_job()
   a = {
      timer = game_directives.timer,
      location_x = game_directives.location_x,
      location_y = game_directives.location_y,
      job_type = game_directives.job_type
   }
   return a
end
function create_job_forque()
   table.insert(game_job_que, new_job() )
end

function get_job_count()
   local job_count = 0
   for i,v in ipairs(game_job_que) do
      job_count = job_count+i
   end
   return job_count
end

function update_job_que()
   local sucessful = math.random(1,100)
   local woodcutting = 0
   local digging = 0
   local building = 0
   local gathering = 0
   local farming = 0
   local fishing = 0
   local firebuilding = 0
   for i,v in ipairs(game_job_que) do
      if game_job_que[i].timer > 0 then
	 if game_job_que[i].job_type == "Build house" and
	    (get_availible_worker(game_job_que[i].job_type)==true or get_availible_worker(game_job_que[i].job_type)==true)
	 and building == 0 then
	    on_game_directives_buildhouse(i)
	    game_job_que[i].timer = game_job_que[i].timer -1
	    building = 1  
	 elseif (game_job_que[i].job_type == "Cut trees") and get_availible_worker(game_job_que[i].job_type) == true and woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif (game_job_que[i].job_type == "Cut bamboo") and get_availible_worker(game_job_que[i].job_type) == true and woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif (game_job_que[i].job_type == "Cut sakura") and get_availible_worker(game_job_que[i].job_type) == true and woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif game_job_que[i].job_type == "Dig hole" and get_availible_worker(game_job_que[i].job_type)==true and digging == 0 then
	    on_sucessful_dig_hole(game_job_que[i].job_type, sucessful) -- check for dig hole
	    game_job_que[i].timer = game_job_que[i].timer -1
	    digging = 1
	 elseif game_job_que[i].job_type == "Gather Food" and gathering == 0 then
	    on_sucessful_gather_dojob(game.biome, game_job_que[i].job_type, game.current_weather,sucessful) -- fish, gathering
	    game_job_que[i].timer = game_job_que[i].timer -1
	    gathering = 1
	 elseif game_job_que[i].job_type == "Fishing" and fishing == 0 then
	    on_sucessful_gather_dojob(game.biome, game_job_que[i].job_type, game.current_weather,sucessful) -- fish, gathering
	    game_job_que[i].timer = game_job_que[i].timer -1
	    fishing = 1
	 elseif  game_job_que[i].job_type == "Make garden" and get_availible_worker(game_job_que[i].job_type)==true and farming == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    farming = 1
	 elseif  game_job_que[i].job_type == "Plant tomatoes" and get_availible_worker(game_job_que[i].job_type)==true and farming == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    farming = 1
	 elseif game_job_que[i].job_type == "Make bonfire" and firebuilding == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    firebuilding = 1
	 end
	 --count job types and only decrement timer if we havent decremented a timer on a job.	 
      else --game_job_que[i].timer > 0 then
	 if game_job_que[i].timer == 0 then --Building Complete
	    if game_job_que[i].job_type == "Demolish building" then
	       update_destroy_building(game_job_que[i].location_y, game_job_que[i].location_x)
	       -------------- START BUILD HOUSE -----------------------
	    elseif game_job_que[i].job_type == "Build house" then
	       build_house_complete(i)
	       
	    elseif game_job_que[i].job_type == "Build bridge" then  --GARDEN
	       kingdom_inventory.wood = kingdom_inventory.wood -5
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.house_to_build
	    elseif game_job_que[i].job_type == "Gather Food" then
	       if  game_map[game_job_que[i].location_y][game_job_que[i].location_x] == 2 then
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1
	       end
	    elseif game_job_que[i].job_type == "Make garden" then  --GARDEN
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 42 
	       kingdom_inventory.farmplot = kingdom_inventory.farmplot+1
	    elseif game_job_que[i].job_type == "Plant tomatoes" then  --GARDEN (Tomatoes
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 42 
	       game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1000
	       --kingdom_inventory.farmplot = kingdom_inventory.farmplot+1 --update me!
	    elseif game_job_que[i].job_type == "Make bonfire" then
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 47
	       game_fire_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1
	       kingdom_inventory.bonfire = kingdom_inventory.bonfire+1
	    elseif game_job_que[i].job_type == "Build road" then
	       game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.road_to_build
	    elseif game_job_que[i].job_type == "Dig hole" then
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.hole_tile --math.random(24,27)
	       instant_update_map()
	    elseif game_job_que[i].job_type == "Cut trees" then
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = math.random(1,2)
	    elseif game_job_que[i].job_type == "Cut bamboo" or game_job_que[i].job_type == "Cut sakura"  then
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = math.random(1,2) --change the map
	    end--endif game_job_que[i].job_type == "Demolish building" then
	    game_directives.active = 1
	    game_directives.timer = 0
	    game_directives.location_x = game_job_que[i].tilex
	    game_directives.location_y = game_job_que[i].tiley -- now update should take care of it.
	    table.remove(game_job_que, i) --remove from que!
	 end --if game_job_que[i].timer == 0 then --Building Complete
      end -- game_job_que[i].timer > 0 then
   end --end for ?
end --end fucntion.

function on_game_directives_buildhouse(i)
   if game_job_que[i].timer > 200 then
      game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = 56
   elseif game_job_que[i].timer > 100 then
      game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = 57
   elseif game_job_que[i].timer > 50 then
      game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = 58
   end
end

function on_sucessful_cut_trees(woodtype, sucessrate)
   if woodtype == "Cut trees" and sucessrate == 1 then
      kingdom_inventory.wood = kingdom_inventory.wood+1
      bonus = math.random(1,100)
      if bonus == 1 then
	 kingdom_inventory.cherries = kingdom_inventory.cherries+1
      end
   elseif woodtype == "Cut sakura" and sucessrate == 1 then
      kingdom_inventory.sakura = kingdom_inventory.sakura+1
      bonus = math.random(1,100)
      if bonus == 1 then
	 kingdom_inventory.cherries = kingdom_inventory.cherries+1
      end
   elseif woodtype == "Cut bamboo" and sucessrate == 1 then
      kingdom_inventory.bamboo = kingdom_inventory.bamboo+1
      bonus = math.random(1,100)
      if bonus == 1 then
	 kingdom_inventory.cherries = kingdom_inventory.cherries+1
      end
   end
end

function on_sucessful_dig_hole(job_type, sucessrate)
   if sucessrate == 1 and job_type == "Dig hole" then
      kingdom_inventory.rocks = kingdom_inventory.rocks+1
   elseif sucessrate == 2 and job_type == "Dig hole" then
      kingdom_inventory.carrots = kingdom_inventory.carrots+1
   elseif sucessrate == 3 and job_type == "Dig hole" then
      local found_iore = math.random(1,3)
      local found_gore = math.random(1,100)
      if found_iore == 1 and job_type == "Dig hole"  then
	 kingdom_inventory.iron_ore = kingdom_inventory.iron_ore+1
      end
      if found_gore == 1 and job_type == "Dig hole" then
	 kingdom_inventory.gold_ore = kingdom_inventory.gold_ore+1
      end
   end
end

function on_sucessful_gather_dojob(biome, job_type, weather,sucessrate)
   local halfdice = math.random(1,2)
   if sucessrate == 1 then --test the random for sucess on a number of directives.
      if job_type == "Gather Food" and halfdice == 1 then
	 if is_night() == 0 and game.biome == "forest" then --you cannot find carrots at night! :)
	    kingdom_inventory.carrots = kingdom_inventory.carrots+1
	 elseif game.biome == "japan" then
	    kingdom_inventory.sansai = kingdom_inventory.sansai+1
	 end
      elseif job_type == "Fishing" then
	 kingdom_inventory.fish = kingdom_inventory.fish+1
      end--endif
   elseif sucessrate == 2 and halfdice == 1 then
      if job_type == "Gather Food" then
	 kingdom_inventory.mushrooms = kingdom_inventory.mushrooms+1
      end
   end   
end

function update_directives()   
   if game.research_timer <= 0 then
      game.research_timer = 0
      update_research_directives() -- only ran if successful
   else
      game.research_timer = game.research_timer - 1 - kingdom_inventory.dark_elves
   end
   ------------directives for labor-----------------------------
   update_job_que() --go through the que and check whats going on.
   ------------still doing job ---------------------------------
   game_directives.job_type = "None"
   game_directives.active = 0
   game_directives.location_x = 0
   game_directives.location_y = 0
   --end--endif
end--function update_directives()

function update_migration_relations(vil)
   --given the list of villagers, assign children to parents.
   --randomly assign female to male relationships.
   for i,v in ipairs(vil) do --added age restrictions to prevent illogical marriages
      if vil[i].spouse_of == "None" and vil[i].sex == 1 and vil[i].age >= 18 then
	 for i2,v2 in ipairs(vil) do
	    if vil[i2].spouse_of == "None" and vil[i2].sex == 0 and vil[i2].age >= 14 then
	       vil[i].spouse_of = vil[i2].name
	       vil[i2].spouse_of = vil[i].name
	       break
	    end--endif
	 end--endfor
      end--endif
   end--endfor
   -- set who is whos child
   for i,v in ipairs(vil) do -- loop through children
      if vil[i].scion_of == "None" and vil[i].age < 18 then
	 eligible_parents = {}--find eligible_parents
	 for i2,v2 in ipairs(vil) do --loop through villagers
	    if vil[i].age < vil[i2].age -13 then--must be at least 13 years older than the child
	       table.insert(eligible_parents, vil[i2] )--insert into eligible_parents who could be the mother/father
	    end--endif
	 end--endfor
	 --now that we have a possible table who who could be the father we must check if the table is empty.
	 if next (eligible_parents) == nil then
	    vil[i].scion_of = "None"
	 else--if there are eligible parents(not nil table)
	    get_parent = math.random(1,table.getn(eligible_parents))
	    vil[i].scion_of = eligible_parents[get_parent].name
	    if eligible_parents[get_parent].spouse_of ~= "None" then
	       vil[i].scion_of = vil[i].scion_of..","..eligible_parents[get_parent].spouse_of
	    end--endif
	 end--endif/else
      end--endif
   end--endfor
end--fucntion update_migration_relations(vil)

function on_fire(tile)
   if tile == 1 then 
      return true
   else 
	 return false
   end
end

function on_update_fires(x,y) -- per tile do a fire update.
   local fire_limit = 4
   local fs = 0
   local catch_trees = 0
   if game_map[y][x] == 47 then
	if game_map[y][x-1] >=3 and game_map[y][x-1] <=20 then
		catch_trees = math.random(1,20)
	elseif game_map[y][x-1] >=57 and game_map[y][x-1] <=60 then
		catch_trees = math.random(1,20)
	else
		catch_trees = 0
	end
   else
	catch_trees = 0
   end --endif
   if on_fire(game_fire_map[y][x]) == true and catch_trees == 1 then
	if check_fireproof(game_map[y][x-1], game_fire_map[y][x-1]) == false 
	    and on_fire(game_fire_map[y][x-1]) == false	and fs < fire_limit then
		fs = fs+1
	       	game_fire_map[y][x-1] = 1
	       	message_que_add("The fire is spreading!", 300, 1)
	elseif check_fireproof(game_map[y][x+1], game_fire_map[y][x+1]) == false 
	    and on_fire(game_fire_map[y][x+1]) == false and fs < fire_limit then
	       fs = fs+1
	       game_fire_map[y][x+1] = 1
	       message_que_add("The fire is spreading!", 300, 1)
	elseif check_fireproof(game_map[y-1][x], game_fire_map[y-1][x]) == false 
	    and on_fire(game_fire_map[y-1][x]) == false and fs < fire_limit then
	       fs = fs+1
	       game_fire_map[y-1][x] = 1
	       message_que_add("The fire is spreading!", 300, 1)
	elseif check_fireproof(game_map[y+1][x], game_fire_map[y+1][x]) == false 
	    and on_fire(game_fire_map[y+1][x]) == false and fs < fire_limit then
	       fs = fs+1
	       game_fire_map[y+1][x] = 1
	       message_que_add("The fire is spreading!", 300, 1)
	end--endif
	    --elseif on_fire(game_fire_map[y][x]) == true and game_map[y][x] ~= 47 then
    end--endif
	 --items alreay on fire
    if game_map[y][x] ~= 47 and on_fire(game_fire_map[y][x]) == true then
	game_map[y][x] = fire_ravage_tile(game_map[y][x]) --burn it up
	local fire_complete = math.random(0,10)
	if fire_complete == 1 then --it burnt itself out
		game_fire_map[y][x] = 0 
	    end
	    if game_map[y][x] == 1 then
	       game_fire_map[y][x] = 0
	       if game_road_map[y][x] == 51 or game_road_map[y][x] == 52 or
	       game_road_map[y][x] == 70	then
		  game_road_map[y][x] = 73
	       elseif (game_road_map[y][x] >= 23 and game_road_map[y][x] <=26) or
	       (game_road_map[y][x] >= 61 and game_road_map[y][x] <= 68) then
		  game_road_map[y][x] = 73
		  kingdom_inventory.homes = kingdom_inventory.homes -1
	       elseif game_road_map[y][x] == 27 then
		  game_road_map[y][x] = 0
		  kingdom_inventory.mine = kingdom_inventory.mine -1
	       end
	    end
	 end--endif
	 --do rioting
	 --homes & mines(23-27) school,barn 51,52, 61-68 buildings, 70 fishing hut, 
	 --75 militia house, 80 smelter
	 if kingdom_inventory.unrest >= 70 then --rioting, randomly set fire to a building.
	    if game_road_map[y][x] >= 23 and game_road_map[y][x] <=27 then
	       riot_fire_chance = math.random(1,15)
	       if on_fire(game_fire_map[y][x]) == false and riot_fire_chance == 1 then
		  game_fire_map[y][x] = 1
		  message_que_add("Rioters have set a fire!".."("..x.."X"..y..")", 300, 1)
	       end
	    elseif game_road_map[y][x] == 51 or game_road_map[y][x] == 52 then
	       riot_fire_chance = math.random(1,15)
	       if on_fire(game_fire_map[y][x]) == false and riot_fire_chance == 1 then
		  game_fire_map[y][x] = 1
		  message_que_add("Rioters have set a fire!".."("..x.."X"..y..")", 300, 1)
	       end
	    elseif game_road_map[y][x] >= 61 and game_road_map[y][x] <= 68 then
	       riot_fire_chance = math.random(1,15)
	       if on_fire(game_fire_map[y][x]) == false and riot_fire_chance == 1 then
		  game_fire_map[y][x] = 1
		  message_que_add("Rioters have set a fire!".."("..x.."X"..y..")", 300, 1)
	       end
	    elseif game_road_map[y][x] == 70 then
	       riot_fire_chance = math.random(1,15)
	       if on_fire(game_fire_map[y][x]) == false and riot_fire_chance == 1 then
		  game_fire_map[y][x] = 1
		  message_que_add("Rioters have set a fire!".."("..x.."X"..y..")", 300, 1)
	       end
	    end
	 end
end --end fuction

function hourly_update_map()
   local fire_limit = 4
   local fs = 0
   local catch_trees = 0
   --on_update_fires(x,y)
   for y = 2, game.tilecount-1 do
      for x = 2, game.tilecount-1 do
	 on_update_fires(x,y) --- check to see if teh fire is spreading, also if rioters are starting fires.
      end--end for
   end--end for
end --function hourly_update_map()

function update_villager_new_destination(i, dt, custom_speed)
   --if i.x < i.dx
   if i.x < i.dx then
      i.x = i.x + (custom_speed)*dt
      if i.x > i.dx then --prevent overshooting
	 i.x = i.dx 
      end
   elseif i.x > i.dx then 
      i.x = i.x - (custom_speed)*dt
      if i.x < i.dx then --prevent overshooting
	 i.x = i.dx 
      end
   end
   if i.y < i.dy then 
      i.y = i.y + (custom_speed)*dt
      if i.y > i.dy then  --prevent overshooting
	 i.y = i.dy 
      end
   elseif i.y > i.dy then 
      i.y = i.y - (custom_speed)*dt
      if i.y < i.dy then  --prevent overshooting
	 i.y = i.dy 
      end
   else
      i.job = 0 
   end
end

function love.update(dt)
   --lets try some map dragging
   local mx = love.mouse.getX()
   local my = love.mouse.getY()
   --game.give_direction = "Scrolling"
   if game.loading_res == true then
      --load game resources
      --set loading to false
      load_game_res()
      game.loading_res = false
   	game.show_menu = 0
   end
   update_checkscrolling(mx, my)
   if game.game_paused == 0 and game.game_roster == 0 then --if both are 0 continue game
      for i,v in ipairs(game_message_que) do
	 if game_message_que[i].mtimer > 0 then
	    game_message_que[i].mtimer = game_message_que[i].mtimer-1
	    break
	 end
      end
      mouse_x, mouse_y = love.mouse.getPosition()
      if game.show_menu ~= 1 then
	 update_run_daytimer() -- run the clock
	 update_directives()
      end
      -- calculate tile_selected
      for y = 1, game.tilecount do
	 for x = 1, game.tilecount do
	    lx = 300+(y - x) * 32 + 64
	    ly = -100+(y + x) * 32 / 2 + 50
	    -- function -----  game tiles map table ---- isometric loc
	    if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+64 and mouse_y >= ly+game.draw_y+60 and mouse_y <= ly+game.draw_y+100) then
	       --put the number of the selected tile
	       game.tile_selected_x = x
	       game.tile_selected_y = y
	       game.loc_selected_x = lx+game.draw_x+ 32
	       game.loc_selected_y = ly+game.draw_y+ 16
	    end--endif
	 end--endfor x
      end--endfor y
      update_villager_jobs(dt) -- code for deciding what villagers should do
      for i, v in ipairs(game_wildlife) do
	 if game_wildlife[i].job == 0 and game_wildlife[i].alive == 1 then -- The living!
	    game_wildlife[i].job = math.random(1, 1000)
	    if game_wildlife[i].job < 10 then -- movment
	       game_wildlife[i].dx = game_wildlife[i].dx + math.random(-30,30) --temp workaround
	       game_wildlife[i].dy = game_wildlife[i].dy + math.random(-30,30)
	    end--endif
	 end --endif
	 update_villager_new_destination(game_wildlife[i], dt, game_wildlife[i].speed)
      end -- endfor (game_wildlife)
   end --if game.game_paused == 0 then
   on_update_earthquake(5)
   update_merchant_location()
end -- function love.update()
