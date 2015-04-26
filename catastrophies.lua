--- File to define catastrophies.  --get_parent = math.random(1,table.getn(eligible_parents))
--game = {state = 1, give_direction = "None", day_time = 6000, day_count = 1,
--	tile_selected_x = 0,tile_selected_y = 0, mouse_last_x=0, mouse_last_y=0, 
--	draw_x=-100, draw_y=-100, screen_width = love.graphics.getWidth(), love.graphics.getHeight(),
--	scroll_speed=3, loc_selected_x = 0, loc_selected_y = 0, --lx+ 32 --ly+ 16
--	tilecount = 32, actor_speed = 2, printx = 0, printy = 0, -- 0  -62-- 536-600
--	water_tile = 38, hole_tile = 37, fish_icon = 22, bridge_tile1 = 21,
--	bridge_tile2 = 22, axe_icon = 85, shovel_icon = 21, green_selected = 39, 
--	yellow_selected = 40, house_to_build = 0, road_to_build = 0, day_ttl = 1200,
--	current_weather = "None", days_without_rain = 0, days_rained = 0, days_snowed = 0, current_catastrophy = 0
--	biome = "forest", game_paused = 0, game_roster = 0, game_mque = 0,
--	show_menu = 1, version = g_version,
--	loading_res = false,
--	togglesound = "on",
--	map_generated = 0, show_tutorial = 1,
--	message_box_text = "None",  message_box_icon = 2, message_box_timer = 0,
--	records_tab = 1,
--	research_timer = 0, disablekeyboard = 0, disablescrolling = 0, lastscreenshot=0,
--	mayor_sex = 77, --77 mail 78 female
--	message_num = 0
--}

--function run_weather_trigger()
--function run_catastrophies_trigger()
function run_weather_trigger()
  dice = math.random(1,table.getn(weather)) -- roll a dice 1-13
  return dice
end
function on_update_bandit_raid()
   --create a bunch of bandits.
   --table.insert(game_invaders, new_invader("bandit")
   --for update, if invader touches villager, 50/50 one dies
   --food goes 1/100 missing every count
   --daughters go missing 1/1000
end
function zombiefy_villager_by_name(name) --look up villager name and undead them
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].name == name then
	 game_villagers[i].alive = -1 -- -1 = undeath!
	 game_villagers[i].villager_type = "Zombie!"
	 kingdom_inventory.villagers = kingdom_inventory.villagers -1 --remove living villagers
	 --game_villagers[i].opinion = "Died on Day"..game.day_count.." at "..game.day_time
	 game_villagers[i].opinion = "Brains!"
	 --game_villagers[i].died_x = game_villagers[i].x
	 --game_villagers[i].died_y = game_villagers[i].y
	 game.message_box_icons = 19
	 set_family_opionions(game_villagers[i]) --not yet tested
	 if game_villagers[i].sex == 0 then
	    message_que_add(game_villagers[i].name.." is acting strange!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
	 else
	    message_que_add(game_villagers[i].name.." is shambling around!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+5
	 end
      end
   end
end

function update_villager_zombiefied_by_zombie(i, j)
   local name = "none"
   if villager_touched(i, j) == 1 and i.alive == -1 then
      if  i.alive == -1 and j.alive == 1 then
	 zombiefy_villager_by_name(j.name)
      end --if
   end --if 
end--end fucntion

function on_update_zombie_apacalypse() -- happens for ever!
   --infect a random citizen!
   --let the update continue, like werewolves touching, a zombie who touches a citizen
   --will infect them 80% of the time.
   local randomvillager = 0
   local vname = "none"
   for i,v in ipairs(game_villagers) do
      --count the villagers
      randomvillager = randomvillager+1
   end
   randomvillager = math.random(1, randomvillager)
   for i,v in ipairs(game_villagers) do
      --find a villager and zombiefy them! --even if they are dead!!!!
      if i == randomvillager then
	 vname = game_villagers[i].name
	 zombiefy_villager_by_name(vname) -- you must be zombiefied!
      end
   end
   message_que_add("These are truly the last days!", 100, 6)
end

function on_update_earthquake(shaketimer) --make the screen shake, calc chances
   --for building collapse
   local villager_name = "none"
   if game.earthquake == 1 then --this happens if there is an earthquake going on.
      if game.earthquake_shake_timer == 0 then
	 game.earthquake_shake_timer = shaketimer
	 if game.earthquake_draw_offset == 5 then
	    game.earthquake_draw_offset = -5
	    game.draw_x = game.draw_x +game.earthquake_draw_offset
	 else
	    game.earthquake_draw_offset = 5
	    game.draw_x = game.draw_x +game.earthquake_draw_offset
	 end
      else
	 game.earthquake_shake_timer = game.earthquake_shake_timer-1
      end
      if game.earthquake_timer > 0 then
	 game.earthquake_timer = game.earthquake_timer -1 --decrement the earthquake
	 --people die here
	 local die_random = math.random(1,1000)
	 for i,v in ipairs(game_villagers) do
	    if i == die_random and game_villagers[i].alive == 1 then
	       villager_name = game_villagers[i].name
	       kill_villager_by_name(villager_name, " an earthquake related crushing")
	    end --end if
	 end--end for
	 --hopes and homes are destroyed here.
	 local house_count = 0
	 local hx = math.random(1, game.tilecount)
	 local hy = math.random(1, game.tilecount)
	 for y = 2, game.tilecount-1 do --but are we looping through every tile per count?
	    for x = 2, game.tilecount-1 do --i guess we are?
	       --if a house exists, blow it up?
	       if x == hx and y == hy and game_road_map[y][x] > 0 then
		  --do the house!
		  update_destroy_building(y,x)
		  --now change the tile to rubble.
		  game_road_map[y][x] = 72 -- colapsing house are now done!
	       end
	    end
	 end
      else
	game.earthquake = 0
     end
   end --end if
end
function run_catastrophies_trigger()
  dice = math.random(1,1000)
  --roll a dice 1/1000
  if dice == 47 then  --start the zombie apacalypse!
     on_update_zombie_apacalypse()
     dice = 47
  elseif dice == 42 then --start a bandit raid
     dice = 42
  elseif dice == 45 then --start an earthquake!
     game.earthquake = 1
     game.earthquake_timer = math.random(300,1000)
     --add message queue
     message_que_add("An earthquake has come!", 80, 2)
     dice = 45
  end
  return dice
end

    
