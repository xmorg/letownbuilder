--main update functions, 
--increment day time and


require( "achivements")

function spread_fires(x,y)
   if game_fire_map[y][x] == 1 then
      fire_rand = math.random(1,4)
      if (fire_rand == 1) then		-- spread the fire!			
	 fire_spread = math.random(1,4)
	 if fire_spread == 1 and check_fireproof(game_map[y][x-1], game_fire_map[y][x-1]) == false and
	 game_fire_map[y][x-1] ~= nil then 
	    game_fire_map[y][x-1] = 1
	    message_que_add("The fire is spreading!", 300, 1)
	 elseif fire_spread == 2 and check_fireproof(game_map[y][x+1],game_fire_map[y][x+1] ) == false and
	 game_fire_map[y][x+1] ~= nil then 
	    game_fire_map[y][x+1] = 1
	    message_que_add("The fire is spreading!", 300, 1)
	 elseif fire_spread == 3 and check_fireproof(game_map[y-1][x], game_fire_map[y-1][x]) == false and
	 game_fire_map[y-1][x] ~= nil then 
	    game_fire_map[y-1][x] = 1
	    message_que_add("The fire is spreading!", 300, 1)
	 elseif fire_spread == 4 and check_fireproof(game_map[y+1][x],game_fire_map[y+1][x] ) == false and
	 game_fire_map[y+1][x] ~= nil then 
	    game_fire_map[y+1][x] = 1
	    message_que_add("The fire is spreading!", 300, 1)
	 end --endif
      end--endif
   end --endif
end

function daily_update_map() --happens at 11 oclock
   --provide resources from producing buildings
   --wildlife_proliferation() -- breed the wildlife!
   table.insert(game_wildlife, new_wildlife(0, "random") )
   table.insert(game_wildlife, new_wildlife(0, "random") )
   table.insert(game_wildlife, new_wildlife(0, "random") )
   table.insert(game_wildlife, new_wildlife(0, "random") )
   table.insert(game_wildlife, new_wildlife(0, "random") )
   --kingdom_inventory.grain = kingdom_inventory.grain + kingdom_inventory.farmplot *10
   kingdom_inventory.homes = 0 --clear for recount
   for y = 1, game.tilecount do --this updates weekly but for purposes
      for x = 1, game.tilecount do
	 if game_map[y][x] >= 43 and game_map[y][x] <= 46 then --43, 44, 45
	    local birds_ravage_garden = math.random(1,20-research_topics.agriculture)
	    if birds_ravage_garden == 1 and 
	    unlock_addition("scarecrow") == true then
	       game_map[y][x] = 42
	       message_que_add("Crows have ravaged your garden at "..y.."x"..x, 80, 1)
	    end
	 end
	 ---------------------------------
	 plant_regrowth(x,y)
	 ----------------------------------
	 spread_fires(x,y)
	 
      end --endfor
   end--endfor
   --more villagers arrive!
   migrants = math.random(1, 5)
   migrants_tab = {}
   for t=1, migrants do
      table.insert(migrants_tab, new_villager(1) )--put in a temp table		
   end
   update_migration_relations(migrants_tab)--update their relations
   game_families = get_villager_famgroups()
   if kingdom_inventory.dwarves > 0 then
   	research_topics.smelter = 1
   	research_topics.smithy = 1
   end
   
   --TODO update t
   for t=1, migrants do --put them into the main table.
      table.insert(game_villagers, migrants_tab[t]) 
      kingdom_inventory.villagers =  kingdom_inventory.villagers +1
   end
   --look for vacant positions
   if kingdom_inventory.sheriff > 0 then
      villagers_do_job(400, 400, "sheriff")
   end
   kingdom_inventory.families = get_villager_families(game_villagers)
   message_que_add(migrants.." migrants have arrived.  Welcome." , 300, 7)
   --kingdom_inventory.homeless = (kingdom_inventory.villagers - kingdom_inventory.homes)
   --game.message_box_timer = 300
   if kingdom_inventory.monument >= 1 then
      if kingdom_inventory.unrest < 60 then
	 kingdom_inventory.unrest = kingdom_inventory.unrest - kingdom_inventory.monument --monuments
	 local vandalism = math.random(1,300)
	 if vandalism ==1 then
	    vandalize_monument()
	 end--endif
      elseif kingdom_inventory.unrest > 60 then
	 kingdom_inventory.unrest = kingdom_inventory.unrest + kingdom_inventory.monument --monuments
	 local vandalism = math.random(1,3)
	 if vandalism ==1 then
	    vandalize_monument()
	 end
      end
   end
   if kingdom_inventory.holyman > 0 and kingdom_inventory.unrest < 60 then
      kingdom_inventory.unrest = kingdom_inventory.unrest - (kingdom_inventory.holyman*5)
      message_que_add("The people are encouraged by the holyman's sermon" , 90, 1)
      if kingdom_inventory.unrest < 0 then
	 kingdom_inventory.unrest = 0
      end
   elseif kingdom_inventory.unrest >= 60 then
      kingdom_inventory.unrest = kingdom_inventory.unrest + (kingdom_inventory.holyman*5)
      message_que_add("The people are outraged by the holyman's sermon" , 90, 1)
   end
   --insert weather and catastrophies here! ha!
   game.current_weather = run_weather_trigger()
   message_que_add(weather[game.current_weather], 90,1)
   --current_weather = 2, days_without_rain = 0, days_rained = 0, days_snowed = 0,
   --current_catastrophy = 0,
   run_catastrophies_trigger() -- check for  catastrophies.
   if game.current_weather == 11 or game.current_weather == 12 or game.current_weather == 13 then
      game.days_rained = game.days_rained+1
      game.days_without_rain = 0
   elseif game.current_weather >= 2 and game.current_weather <= 10 then --2 through 10
      game.days_without_rain = game.days_without_rain+1
      game.days_snowed = 0
   elseif game.current_weather >= 14 then
      game.days_snowed = game.days_snowed+1
   else
      game.days_snowed = 0
   end
end --daily_update_map()


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

function debug_negatives() --?
   if kingdom_inventory.rocks < 0 then
      kingdom_inventory.rocks = 0
   end
end

function check_for_events_in_timer()
   local nightwolves_night = math.random(1,20)
   if game.day_time == 12000 then
      villagers_eat_food(table.getn(game_villagers))
      if kingdom_inventory.unrest >= 70 then
	 villagers_rioting_report(game_villagers)
      end
   elseif game.day_time == 11000 then
      --message_que_add("DEBUG: Daily update map", 80, 109)
      daily_update_map()
   elseif game.day_time == 8000 then
      merchants_arrive()
   elseif game.day_time % 1000 == 0 then
      hourly_update_map()
   end

   if game.day_time == 17000 then
      villagers_complete_jobs_by_buildings() --check for buildings and, apply resources.
   end
   
   if game.day_time == 21000 then
      villagers_seek_shelter(table.getn(game_villagers))
      if nightwolves_night == 1 then
	 spawn_nightwolves() --put wolves in town
      end
   end

   if game.day_time == 6000 then
      if table.getn(game_nightwolves) > 0 then
	 update_achivements("The howling", 1)
      end
      drop_nightwolves()
   end
end

function update_run_daytimer()
   local total_food = 0
   total_food = kingdom_inventory.carrots+kingdom_inventory.sansai+kingdom_inventory.raw_meat+kingdom_inventory.smoked_meat+
      kingdom_inventory.tomatoes+kingdom_inventory.saltwort+kingdom_inventory.mushrooms+kingdom_inventory.fish+
      kingdom_inventory.smoked_fish+kingdom_inventory.grain+kingdom_inventory.cherries+kingdom_inventory.apples+
      kingdom_inventory.desert_onions
   if total_food >= 100 then
      update_achivements("Food horder", 100)
   end
   --check for food types
	if kingdom_inventory.villagers <= 0 then game.show_menu = 99 end   
   if game.day_time < 24000 then
      game.day_time = game.day_time+1
      --sound_daytime     = love.audio.newSource("data/sounds/wind_1_wbirds.ogg", "static")
      --sound_nighttime = love.audio.newSource("data/sounds/wind_2_night.ogg", "static")
      if game.togglesound == "on" then --play music if sound was on.
	 if is_night() == 0 then --daytime
	    if music_townbg1:isPlaying() == false then music_townbg1:play() end
	    if music_nightbg1:isPlaying() == true then music_nightbg1:stop() end
	 else --its night
	    if music_townbg1:isPlaying() == true then music_townbg1:stop() end
	    if music_nightbg1:isPlaying() == false then music_nightbg1:play() end
	 end
      else -- sound is off
	 if is_night() == 0 then --daytime
	    if music_townbg1:isPlaying() == true then music_townbg1:stop() end
	    if music_nightbg1:isPlaying() == true then music_nightbg1:stop() end
	 else --its night
	    if music_townbg1:isPlaying() == true then music_townbg1:stop() end
	    if music_nightbg1:isPlaying() == true then music_nightbg1:stop() end
	 end	 
      end  --end sound
      debug_negatives() --debug kingdom inventory to prevent negatives!
      --end debug
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
      check_for_events_in_timer() --NEW
   else -- reset timer
      game.day_time = 0
      game.day_count = game.day_count+1
   end
end --update_run_daytimer()

-- new code, not implented the "job que" will allow for multiple jobs
function new_job()
   a = {
      timer = game_directives.timer,
      timer_max = game_directives.timer,
      location_x = game_directives.location_x, --tile loc x/y
      location_y = game_directives.location_y,
      draw_x = 0,
      draw_y = 0,
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
	 if game_job_que[i].job_type == "Build house"  and
	    (get_availible_worker(game_job_que[i].job_type)==true or get_availible_worker(game_job_que[i].job_type)==true)
	 and building == 0 then
	    on_game_directives_buildhouse(i)
	    game_job_que[i].timer = game_job_que[i].timer -1
	    building = 1
	 elseif game_job_que[i].job_type == "Demolish building" and (get_availible_worker(game_job_que[i].job_type)==true) and building == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    building = 1
	 elseif game_job_que[i].job_type == "Build road" and building == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    building = 1
	 elseif (game_job_que[i].job_type == "Cut trees") and
	 get_availible_worker(game_job_que[i].job_type) == true and woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif (game_job_que[i].job_type == "Cut bamboo") and
	 get_availible_worker(game_job_que[i].job_type) == true and woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif (game_job_que[i].job_type == "Cut sakura") and
	    get_availible_worker(game_job_que[i].job_type) == true and
	 woodcutting == 0 then
	    on_sucessful_cut_trees(game_job_que[i].job_type, sucessful) -- trees, sakura, or bamboo
	    game_job_que[i].timer = game_job_que[i].timer -1
	    woodcutting = 1
	 elseif game_job_que[i].job_type == "Dig hole" and
	 get_availible_worker(game_job_que[i].job_type)==true and digging == 0 then
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
	 elseif  game_job_que[i].job_type == "Make garden" and
	 get_availible_worker(game_job_que[i].job_type)==true and farming == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    farming = 1
	 elseif  game_job_que[i].job_type == "Plant tomatoes" and
	 get_availible_worker(game_job_que[i].job_type)==true and farming == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    farming = 1
	 elseif game_job_que[i].job_type == "Make bonfire" and firebuilding == 0 then
	    game_job_que[i].timer = game_job_que[i].timer -1
	    firebuilding = 1
	 end
	 --count job types and only decrement timer if we havent decremented a timer on a job.	 
      else --game_job_que[i].timer > 0 then --JOBS FINISHED HERE!
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
	       if game.biome == "desert" then
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 2
	       elseif  game_map[game_job_que[i].location_y][game_job_que[i].location_x] == 2 then
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1
	       end
	    elseif game_job_que[i].job_type == "Make garden" then  --GARDEN
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 42 
	       kingdom_inventory.farmplot = kingdom_inventory.farmplot+1
	    elseif game_job_que[i].job_type == "Plant tomatoes" then  --GARDEN (Tomatoes
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 42 
	       game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1042
	       --kingdom_inventory.farmplot = kingdom_inventory.farmplot+1 --update me!
	    elseif game_job_que[i].job_type == "Make bonfire" then
	       game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 47
	       game_fire_map[game_job_que[i].location_y][game_job_que[i].location_x] = 1
	       kingdom_inventory.bonfire = kingdom_inventory.bonfire+1
	    elseif game_job_que[i].job_type == "Build road" then
	       --game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.road_to_build
	       game_road_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.road_to_build
	    elseif game_job_que[i].job_type == "Dig hole" then
	       if game.biome == "desert" then
		  --some digs will just level, 7, 11, 12,18
		  gm = game_map[game_job_que[i].location_y][game_job_que[i].location_x]
		  if gm == 7 or gm == 11 or gm == 12 or gm == 18 then
		     game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 2 --leveled tile
		  else
		     game_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.hole_tile
		  end		  
	       else
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = game.hole_tile
	       end
	       instant_update_map()
	    elseif game_job_que[i].job_type == "Cut trees" then
	       update_achivements("Tree Puncher", 1)
	       update_achivements("Pro logger", 1)
	       if game.biome == "desert" then
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = 2
	       else
		  game_map[game_job_que[i].location_y][game_job_que[i].location_x] = math.random(1,2)
	       end
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
      if game.biome == "desert" then -- wood is VERY rare.
      	addwood = math.random(0,1)
      else
      	addwood = 1
      end
      kingdom_inventory.wood = kingdom_inventory.wood+addwood
      bonus = math.random(1,100)
      if bonus == 1 and game.biome ~= "desert" then
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
		if game.biome == "desert" then
			kingdom_inventory.sandstone = kingdom_inventory.sandstone+1
		else
	 		kingdom_inventory.rocks = kingdom_inventory.rocks+1
      	end
    elseif sucessrate == 2 and job_type == "Dig hole" then
   		if game.biome == "forest" then --only forests have carrots laying around!
      		kingdom_inventory.carrots = kingdom_inventory.carrots+1
      	end
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
      if job_type == "Gather Food" then 
	 kingdom_inventory.seeds = kingdom_inventory.seeds+1 
      end
      if job_type == "Gather Food" and halfdice == 1 then
	 if is_night() == 0 and (game.biome == "forest" or game.biome == "frost") then --you cannot find carrots at night! :)
	    kingdom_inventory.carrots = kingdom_inventory.carrots+1
	 elseif game.biome == "japan" then
	    kingdom_inventory.sansai = kingdom_inventory.sansai+1
	 elseif game.biome == "desert" then
	    kingdom_inventory.seeds = kingdom_inventory.seeds+1
	    kingdom_inventory.desert_onions = kingdom_inventory.desert_onions+1
	 end
      elseif job_type == "Fishing" then
	 if game.biome == "desert" then
	    kingdom_inventory.fish = kingdom_inventory.fish+math.random(0,1)
	 else
	    kingdom_inventory.fish = kingdom_inventory.fish+1
	 end--endif
      end
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
   if on_fire(game_fire_map[y][x]) == true and game_road_map[y][x] == 52 then -- the barn is on fire!
      update_achivements("Worlds biggest BBQ", 1) --omg! you lost all your food!
      kingdom_inventory.carrots = 0
      kingdom_inventory.sansai = 0
      kingdom_inventory.raw_meat = 0
      kingdom_inventory.smoked_meat = 0
      kingdom_inventory.mushrooms = 0
      kingdom_inventory.fish = 0
      kingdom_inventory.smoked_fish = 0
      kingdom_inventory.grain = 0
      kingdom_inventory.cherries = 0
      kingdom_inventory.fishwine = 0
      kingdom_inventory.paleale = 0
      kingdom_inventory.apples = 0
      kingdom_inventory.desert_onions = 0	 
   end
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
	 end --endif  game_road_map[y][x] == 70 then
      end --endif game_road_map[y][x] >= 23 and game_road_map[y][x] <=27 then
   end --endif  kingdom_inventory.unrest >= 70 then
   --check if the barns on fire?
end --end fuction

function hourly_update_map()
   local fire_limit = 4
   local total_food = 0
   local fs = 0
   local catch_trees = 0
   --on_update_fires(x,y)
   for y = 2, game.tilecount-1 do
      for x = 2, game.tilecount-1 do
	 on_update_fires(x,y) --- check to see if teh fire is spreading, also if rioters are starting fires.
      end--end for
   end--end for
   --check for food
   
end --function hourly_update_map()kingdom_inventory

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
      if game.show_menu ~= 1 and game.show_menu ~= 2 and game.show_menu ~= 7 then
	 update_run_daytimer() -- run the clock
	 update_directives()
      end
      -- calculate tile_selected
      for y = 1, game.tilecount do
	 for x = 1, game.tilecount do
	    lx = 300+(y - x) * 32 + 64
	    ly = -100+(y + x) * 32 / 2 + 50
	    -- function -----  game tiles map table ---- isometric loc
	    if(mouse_x >= lx+game.draw_x and mouse_x <= lx+game.draw_x+64 and
		  mouse_y >= ly+game.draw_y+60 and mouse_y <= ly+game.draw_y+100) then
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
      update_nightwolves(dt) --update nightwolves.
   end --if game.game_paused == 0 then
   
   on_update_earthquake(5)
   update_merchant_location()
   get_tooltip_info_from_item() --ran in update?
end -- function love.update()


function plant_regrowth(x,y)
   if game_map[y][x] == 1 and game.days_since_regrowth == 7 then --dirt
      game_map[y][x] = 2 --grass
   elseif game_map[y][x] == 42 then --garden
      game_map[y][x] = 43 -- sprouts
      if game_road_map[y][x] == 1042 then
	 game_road_map[y][x] = 1043
      end
   elseif game_map[y][x] == 43 then --sprouts
      if game.days_without_rain >=7 or game.days_snowed >= 7 then
	 game_map[y][x] = 42
      else
	 game_map[y][x] = 44
      end
      if game_road_map[y][x] == 1043 then
	 game_road_map[y][x] = 1044
      end
   elseif game_map[y][x] == 44 then --plants
      if game_road_map[y][x] == 1044 then
	 game_road_map[y][x] = 1045
      end
      if game.days_without_rain >=7 or game.days_snowed >= 7  then
	 game_map[y][x] = 42
      else
	 game_map[y][x] = 45
      end
   elseif game_map[y][x] == 45 then --almost ready
      if game_road_map[y][x] == 1045 then
	 game_road_map[y][x] = 1046
      end
      if game.days_without_rain >=7 or game.days_snowed >= 7  then
	 game_map[y][x] = 42
      else
	 game_map[y][x] = 46 --ready to harvest
      end
   elseif game_map[y][x] == 46 then --next day harvest and replant
      if game_road_map[y][x] == 1046 then
	 kingdom_inventory.tomatoes = kingdom_inventory.tomatoes+10	
      else
	 kingdom_inventory.grain = kingdom_inventory.grain+10
	 game_road_map[y][x] = 1042
      end
      game_map[y][x] = 42
   elseif game_road_map[y][x] >= 23 and game_road_map[y][x] <= 26 then
      kingdom_inventory.homes = kingdom_inventory.homes+1
   elseif game_road_map[y][x] == 55 then --fishing hut
      kingdom_inventory.fish = kingdom_inventory.fish+ math.random(1,5)
   end
   game.days_since_regrowth = game.days_since_regrowth+1
   if game.days_since_regrowth >= 7 then
      game.days_since_regrowth = 0
   end
end
