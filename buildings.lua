--buildibles

--function to start building house.
function update_directives_loc(timer_set, active)
   game_directives.location_x = game.tile_selected_x
   game_directives.location_y = game.tile_selected_y
   game_directives.timer = timer_set
   game_directives.active = active
end

function build_house_directive(adirection, jhouse_to_build, house_to_build)
   game.give_direction = adirection
   game.house_to_build = house_to_build
   
end

function update_destroy_building(y,x) --if house is destroyed or deconstructed
   local housetypes = {23,24,25,26,61,62,63,64}
   local barn_types = {52,65} --setup items
   local mine      = 27
   local graveyard = 53
   local school    = 50
   local tradepost = 66
   local sheriff   = 67
   local fishinghut = 55
   local watchtower = 65
   function unassign_house()
      kingdom_inventory.homes = kingdom_inventory.homes -1
      for i2,v2 in ipairs(game_villagers) do
	 if game_villagers[i2].house_x == x and game_villagers[i].house_x == y then
	    game_villagers[i2].house_x = 0 -- villager no longer has a 
	    game_villagers[i2].house_y = 0 -- house.
	 end--endif
      end
   end
   if game_road_map[y][x] >= 23 and game_road_map[y][x] <= 26 then
      unassign_house()
   elseif game_road_map[y][x] >= 61 and game_road_map[y][x] <= 64 then
      unassign_house()
   end
   if game_road_map[y][x] == barn_types[1] or game_road_map[y][x] == barn_types[2] then
      kingdom_inventory.barns = kingdom_inventory.barns-1
   elseif game_road_map[y][x] == mine then
      kingdom_inventory.mine = kingdom_inventory.mine-1
   elseif game_road_map[y][x] == graveyard then
      kingdom_inventory.graveyards = kingdom_inventory.graveyards-1
   elseif game_road_map[y][x] == school then
      kingdom_inventory.schools = kingdom_inventory.schools-1
   elseif game_road_map[y][x] == tradepost then
      kingdom_inventory.tradepost = kingdom_inventory.tradepost-1
   elseif game_road_map[y][x] == sheriff then
      kingdom_inventory.sheriff = kingdom_inventory.sheriff-1
   elseif game_road_map[y][x] == fishinghut then
      kingdom_inventory.fishinghut = kingdom_inventory.fishinghut-1
   elseif game_road_map[y][x] == watchtower then
      kingdom_inventory.watchtower = kingdom_inventory.watchtower-1
   end
   game_road_map[y][x] = 0 -- make building disappear
end

function update_add_building(y,x, strtype) -- give them by tile selected
   if strtype == "house" then
      kingdom_inventory.homes = kingdom_inventory.homes+1
      for i,v in ipairs(game_villagers) do
	 if game_villagers[i].house_x == 0 and game_villagers[i].house_x == 0 then
	    game_villagers[i].house_x = x
	    game_villagers[i].house_y = y
	    break
	 end--endif
      end--endfor
   elseif strtype == "barn" then 
      kingdom_inventory.barns = kingdom_inventory.barns +1
   elseif strtype == "mine" then 
      kingdom_inventory.mine = kingdom_inventory.mine +1
   elseif strtype == "graveyard" then 
      kingdom_inventory.graveyards = kingdom_inventory.graveyards +1
   elseif strtype == "school" then 
      kingdom_inventory.schools = kingdom_inventory.schools +1
   elseif strtype == "tradepost" then 
      kingdom_inventory.tradepost = kingdom_inventory.tradepost +1
   elseif strtype == "sheriff" then 
      kingdom_inventory.sheriff =  kingdom_inventory.sheriff+1
   elseif strtype == "fishinghut" then 
      kingdom_inventory.fishinghut = kingdom_inventory.fishinghut+1
   elseif strtype == "smithy" then 
      kingdom_inventory.smithy = kingdom_inventory.smithy+1
   elseif strtype == "brewery" then
      kingdom_inventory.brewery = kingdom_inventory.brewery+1
   elseif strtype == "smelter" then
      kingdom_inventory.smelter = kingdom_inventory.smelter+1
   elseif strtype == "monument" then
      kingdom_inventory.monument = kingdom_inventory.monument+1
      game.house_to_build = game.mayor_sex --fix bug?x
   end--endif
   game_road_map[y][x] = game.house_to_build
end

function build_house_complete(i) -- house is complete, remove resources used, and run update_add_building
   if game.house_to_build >= 23 and game.house_to_build <= 26 then --house
      if game.biome == "forest" then
	 kingdom_inventory.wood = kingdom_inventory.wood -5
	 kingdom_inventory.rocks = kingdom_inventory.rocks -5
      elseif game.biome == "japan" then
	 kingdom_inventory.sakura = kingdom_inventory.sakura -5
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
      end
      villagers_do_job(game_directives.location_x, game_directives.location_y, "builder")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "house")
   elseif game.house_to_build == 27 then  -- mine
      if game.biome == "japan" then
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
      elseif game.biome == "forest" then
	 kingdom_inventory.wood = kingdom_inventory.wood -5
      end
      kingdom_inventory.rocks = kingdom_inventory.rocks -5
      villagers_do_job(game_directives.location_x, game_directives.location_y, "miner")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "mine")
   elseif game.house_to_build == 51 then --school
      if game.biome == "japan" then
	 kingdom_inventory.sakura = kingdom_inventory.sakura -15
      else
	 kingdom_inventory.wood = kingdom_inventory.wood -15
      end
      kingdom_inventory.rocks = kingdom_inventory.rocks -15
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "school")
   elseif game.house_to_build == 52 then--barn
      if game.biome == "japan" then
	 kingdom_inventory.sakura = kingdom_inventory.sakura -5
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -3
      else
	 kingdom_inventory.wood = kingdom_inventory.wood -8
      end
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "barn")
   elseif game.house_to_build == 53 then
      villagers_do_job(game_directives.location_x, game_directives.location_y, "undertaker")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "graveyard")
   elseif game.house_to_build == game.mayor_sex then -- mayors monument.
      kingdom_inventory.rocks = kingdom_inventory.rocks -20
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "monument")
   elseif game.house_to_build == 65 then --watchtower (new)
      if kingdom_inventory.bamboo >=30 then
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -30
      elseif kingdom_inventory.wood >=30 then
	 kingdom_inventory.wood = kingdom_inventory.wood -30
      end
      villagers_do_job(game_directives.location_x, game_directives.location_y, "watchman")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "watchtower")
   elseif game.house_to_build == 55 then --fishinghut (15 wood/bamboo)
      if game.biome == "japan" then
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -15
      elseif game.biome == "forest" then
	 kingdom_inventory.wood = kingdom_inventory.wood -15
      end
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "fishinghut")
   elseif game.house_to_build == 60 then --militia house
      kingdom_inventory.rocks = kingdom_inventory.rocks -20
      villagers_do_job(game_directives.location_x, game_directives.location_y, "builder")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "militia house")
   elseif game.house_to_build == 64 then --smithy
      if game.biome == "japan" then
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -10
	 kingdom_inventory.rocks = kingdom_inventory.rocks -10
      elseif game.biome == "forest" then
	 kingdom_inventory.wood = kingdom_inventory.wood -10
	 kingdom_inventory.rocks = kingdom_inventory.rocks -10
      end
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "smithy")
   elseif game.house_to_build == 66 then --tradepost
      if game.biome == "japan" then
	 kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
      elseif game.biome == "forest" then
	 kingdom_inventory.wood = kingdom_inventory.wood -5
      end
      --kingdom_inventory.tradepost = kingdom_inventory.tradepost+1
      villagers_do_job(game_directives.location_x, game_directives.location_y, "trader")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "tradepost")
   elseif game.house_to_build == 67 then --sheriff
      kingdom_inventory.rocks = kingdom_inventory.rocks -35
      villagers_do_job(game_directives.location_x, game_directives.location_y, "sheriff")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "sheriff")
   elseif game.house_to_build == 70 then --smelter
      kingdom_inventory.rocks = kingdom_inventory.rocks -30
      kingdom_inventory.iron_ore = kingdom_inventory.iron_ore -2
      villagers_do_job(game_directives.location_x, game_directives.location_y, "smelter")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "smelter")
   elseif game.house_to_build == 71 then --brewery
      if game.biome == "forest" then
	 kingdom_inventory.rocks = kingdom_inventory.wood -15
      elseif game.biome == "japan" then
	 kingdom_inventory.sakura = kingdom_inventory.sakura -15
      end
      villagers_do_job(game_directives.location_x, game_directives.location_y, "brewery")
      update_add_building(game_job_que[i].location_y, game_job_que[i].location_x, "brewery")
   end
end

function on_build_house() --check for resources and conditions, if ok start building.
   function start_build_house_job()
      update_directives_loc(300, 1)
      game_directives.job_type = game.give_direction
      game.give_direction = "None"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "builder")
      create_job_forque()
      play_sound(sound_build_house)
   end
   if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      game_directives.job_type = "Cant build on water"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Cant build on water", 80, 41)
   elseif (game.house_to_build >= 23 and game.house_to_build <= 26) then  --house
      if
	 (game.biome == "japan" and (kingdom_inventory.sakura < 5 or kingdom_inventory.bamboo < 5)) or
	 (game.biome == "forest" and (kingdom_inventory.wood < 5 or kingdom_inventory.rocks < 5))
      then --house
	 game_directives.job_type = "Not Resources"
	 game_directives.active = 0
	 game.give_direction = "None"
	 if game.biome == "japan" then
	    message_que_add("Not Resources for a house(sakura 5, bamboo 5)", 80, 109)
	 else
	    message_que_add("Not Resources for a house(wood 5, stone 5)", 80, 109)
	 end
      else
	 start_build_house_job()
      end
   elseif game.house_to_build == 27 then --mine
      if game_map[game.tile_selected_y][game.tile_selected_x] ~= 37 then --mine
	 game_directives.job_type = "Must build at a dig site"
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add("Must build a mine at a dig site", 80, 60)
      elseif (game.biome == "japan" and (kingdom_inventory.sakura < 5 or kingdom_inventory.rocks < 5)) or
      (game.biome == "forest" and (kingdom_inventory.wood < 5 or kingdom_inventory.rocks < 5)) then
	 --not enought resources
	 game_directives.job_type = "Not Resources"
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add("Not Resources for a mine (wood/sakura 5, stone 5)", 80, 41)
      else
	 start_build_house_job()
      end
   elseif game.house_to_build == 51 then -- school
      if (game.biome == "japan" and (kingdom_inventory.sakura < 15 or kingdom_inventory.rocks < 15)) or
	 (game.biome == "forest" and (kingdom_inventory.wood < 15 or kingdom_inventory.rocks < 15))
      then --house
	 game_directives.job_type = "Not Resources(sakura 15, stone 15)"
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add("Not Resources for a school (sakura 15, stone 15)", 80, 41)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 52 then --barn
      if (game.biome == "japan" and (kingdom_inventory.sakura < 5 or kingdom_inventory.bamboo < 3 )) or
	 (game.biome == "forest" and (kingdom_inventory.wood < 8))
      then --barn
	 game_directives.job_type = "Not Resources(wood 8 / sakura 8)"
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a barn (wood 8)", 80, 41)
      else
	 start_build_house_job()
      end
   elseif game.house_to_build == 65 then
      if (game.biome == "japan" and kingdom_inventory.bamboo < 30) or (game.biome == "forest" and kingdom_inventory.wood < 30) then
       	 game_directives.job_type = "Not Resources(bamboo 30/wood 30)" --Watchtower
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a watchtower(bamboo 30 or wood 30)", 80, 41)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 66 then --trade post
      if game.biome == "japan" and kingdom_inventory.bamboo < 10 then
	 game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a tradepost(bamboo 10 or wood 10)", 80, 41)
      elseif game.biome == "forest" and kingdom_inventory.wood < 10 then
	 game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a tradepost(bamboo 10 or wood 10)", 80, 41)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 70 then--smelter
      if kingdom_inventory.rocks < 30 or kingdom_inventory.iron_ore < 2 then
	 game_directives.job_type = "Not Resources(stone 30, iron ore 2)" --smelter
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a smelter(stone 30, iron ore 2)", 80, 41)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 71 then--brewery
      if game.biome == "forrest" and kingdom_inventory.wood < 15 then
	 game_directives.job_type = "Not Resources(wood 15)" --brewery
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a brewery(wood 15)", 80, 41)
      elseif game.biome == "japan" and kingdom_inventory.sakura < 15 then
	 game_directives.job_type = "Not Resources(sakura 15)" --brewery
	 game_directives.active = 0
	 game.give_direction = "None"
	 message_que_add( "Not Resources for a brewery(sakura 15)", 80, 41)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 55 then -- fishing hut
      if game.biome == "japan" and kingdom_inventory.bamboo < 10 then
	 game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --fishing hut
	 message_que_add("Not Resources for a fishing hut(bamboo 10 or wood 10)", 80, 41)
      elseif  game.biome == "forest" and kingdom_inventory.wood < 10 then
	 game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --fishing hut
	 message_que_add("Not Resources for a fishing hut(bamboo 10 or wood 10)", 80, 41)
      elseif tile_near_water( game.tile_selected_y, game.tile_selected_x ) == 0 then
	 game_directives.job_type = "Must build near water."
	 message_que_add("Must build near water.", 80, 59)
      else
	 start_build_house_job() 
      end
   elseif game.house_to_build == 67 and kingdom_inventory.rocks < 35  then --jail/sheriff office
      game_directives.job_type = "Not Resources(stone 35)"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Not Resources for a Sheriff office (stone 35)", 80, 9)
      --go to end
   elseif game.house_to_build == 75 and kingdom_inventory.rocks < 20  then --militia house
      game_directives.job_type = "Not Resources(stone 20)"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Not Resources for a Militia House (stone 20)", 80, 9)
      --go to end
   elseif game.house_to_build == 64 and kingdom_inventory.rocks < 10  then --smelter
      game_directives.job_type = "Not Resources(stone 10)"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Not Resources for a Smelter (stone 10)", 80, 9)
      --go to end
   elseif game.house_to_build == game.mayor_sex and kingdom_inventory.rocks < 20 then
      game_directives.job_type = "Not Resources(stone 20)"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add( "Not Resources for a monument (stone 20)", 80, 41)
      --go to end
   else
      start_build_house_job()
   end
end

function on_build_road()
   function start_build_road_job()
      update_directives_loc(300, 1)
      game_directives.job_type = game.give_direction
      game.give_direction = "None"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "builder")
      create_job_forque()
      play_sound(sound_build_house)
   end
   if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      game_directives.job_type = "Cant build on water"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("You cannot build roads on water", 80, 41)
   elseif game_map[game.tile_selected_y][game.tile_selected_x] ~= 1 and 
      game_map[game.tile_selected_y][game.tile_selected_x] ~= 2 and
      game_map[game.tile_selected_y][game.tile_selected_x] ~= 55 and
   game_map[game.tile_selected_y][game.tile_selected_x] ~= 56 then
      -----less than ------- 3 1,2 ,55 or 56
      game_directives.job_type = "Clear this area first"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Clear this area first", 80, 41)
   --NOTE: dirt roads do not require stone.
   --however rain can wash out roads!
   --elseif kingdom_inventory.rocks < 1 then
   --   game_directives.job_type = "Not enough stone." --stone?
   --   game_directives.active = 0
   --   message_que_add( "Not enough stone to build a road.(1 Stone)", 80, 41)
   else
      kingdom_inventory.rocks = kingdom_inventory.rocks -1 --stone
      --update_directives_loc(100, 1)
      --game_directives.job_type = game.give_direction
      --game.give_direction = "None"
      start_build_road_job()
   end--if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
end

function on_build_bridge() --BUG, need sakura?
   if game_map[game.tile_selected_y][game.tile_selected_x] ~= game.water_tile then
      game_directives.job_type = "Must build on water"
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("You must build bridges on water", 80, 41)
   elseif game.biome == "forest" and kingdom_inventory.wood < 5 then
      game_directives.job_type = "Not enough wood." --stone?
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Not enough wood to build a bridge.(5 Wood)", 80, 41)
   elseif game.biome == "japan" and kingdom_inventory.bamboo < 5 then
      game_directives.job_type = "Not enough bamboo."
      game_directives.active = 0
      game.give_direction = "None"
      message_que_add("Not enough bamboo to build a bridge.(5 Bamboo)", 80, 41)
   else
      --kingdom_inventory.rocks = kingdom_inventory.wood -1 --stone
      update_directives_loc(100, 1)
      game_directives.job_type = game.give_direction
      villagers_do_job(game_directives.location_x, game_directives.location_y, "builder")
      create_job_forque()
      game.give_direction = "None"
   end--if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
end
function on_build_bonfire()
   if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      game_directives.job_type = "Cant build on water"
      game_directives.active = 0
      game.give_direction = "None"
   elseif game.biome == "japan" and kingdom_inventory.sakura < 5 then
      game_directives.job_type = "Not Resources(sakura 5)"
      game_directives.active = 0
      game.give_direction = "None"
   elseif game.biome == "forest" and kingdom_inventory.wood < 5 then
      game_directives.job_type = "Not Resources(wood 5)"
      game_directives.active = 0
      game.give_direction = "None"
   elseif game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      game_directives.job_type = "None."
      game_directives.active = 0
      game.give_direction = "Clear this area first"
   else
      if game.biome == "japan" then kingdom_inventory.sakura = kingdom_inventory.sakura-5
      elseif game.biome == "forest" then kingdom_inventory.wood = kingdom_inventory.wood -5
      end
      update_directives_loc(300, 1)
      game_directives.job_type = "Make bonfire"
      game.give_direction = "None"
      create_job_forque()
   end
end

function on_demolish_structure()
   if game_road_map[game.tile_selected_y][game.tile_selected_x] == 0 then
      game_directives.active = 0
      game.give_direction = "Nothing to demolish"
      game.give_direction = "None"
   else
      update_directives_loc(300, 1)
      game_directives.job_type = game.give_direction
      game_directives.job_type = "Demolish building"
      game.give_direction = "None"
      create_job_forque()
   end
end

function on_build_garden()
   if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      game_directives.job_type = "Cant build on water"
      game_directives.active = 0
      game.give_direction = "None"
   elseif kingdom_inventory.wood < 1 then
      game_directives.job_type = "Not Resources(wood 1)"
      game_directives.active = 0
      game.give_direction = "None"
   else
      kingdom_inventory.wood = kingdom_inventory.wood -1
      update_directives_loc(300, 1)
      game_directives.job_type = game.give_direction
      game.house_to_build = 42
      game.give_direction = "None"
      villagers_do_job(game_directives.location_x, game_directives.location_y, "farmer")
      create_job_forque()
      play_sound(sound_build_house)
   end
end

function on_gather_food()
   if game.biome = "desert" then
      if game_map[game.tile_selected_y][game.tile_selected_x] >= 3 and game_map[game.tile_selected_y][game.tile_selected_x] <= 8 and
      game_map[game.tile_selected_y][game.tile_selected_x] ~= 5 then --there is food except for 5
	 game_directives.active = 1
	 game_directives.timer = 300
	 game_directives.location_x = game.tile_selected_x
	 game_directives.location_y = game.tile_selected_y
	 game_directives.job_type = game.give_direction
	 game.give_direction = "None"
	 create_job_forque() -- make a job for the queue
	 --wait! how do we go back to sand!
      else
	 game_directives.job_type = "None."
	 game_directives.active = 0
	 game.give_direction = "No food here."
      end
   elseif game.tile_selected_y > 1 and game.tile_selected_x > 1 and game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      game_directives.active = 1
      game_directives.timer = 300
      game_directives.location_x = game.tile_selected_x
      game_directives.location_y = game.tile_selected_y
      game_directives.job_type = game.give_direction
      game.give_direction = "None"
      game_directives.job_type = "Fishing"
      create_job_forque()
      villagers_do_job(game_directives.location_x, game_directives.location_y, "fisherman")
   elseif game_map[game.tile_selected_y][game.tile_selected_x] == 1 or game_map[game.tile_selected_y][game.tile_selected_x] == 37 then
      --no food here!
      game_directives.job_type = "None."
      game_directives.active = 0
      game.give_direction = "No food here."
   else
      game_directives.active = 1
      game_directives.timer = 300
      game_directives.location_x = game.tile_selected_x
      game_directives.location_y = game.tile_selected_y
      game_directives.job_type = game.give_direction
      game.give_direction = "None"
      create_job_forque() -- make a job for the queue
   end-- if game.tile_selected_y > 1
end



