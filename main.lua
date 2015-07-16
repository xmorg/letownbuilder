--plans, working gardens (not giving food?)
--bugs: (BIG-FIXED) House count no longer updates/stays updated.
--bugs:  fire spreads where no trees are, cant build trade post even with enough wood
--bugs: message log flows offscreen with prolonged play. - FIXED
--bugs: wood shows -15 in japanese biome (something subtracting wood not sakura)
--bugs: forward slash roads do not connect.
--TODO: Too much talking! decrease by increasing the chance of text by random (1, table.getn(game_villagers)*100)

g_version = "0.9.0" --"0.8.0"
fullscreen_hack = "no"
--fonts data/newscycle-regular.ttf   data/newscycle-bold.ttf
base_font = love.graphics.newFont("data/newscycle-bold.ttf", 14 )
big_font = love.graphics.newFont("data/newscycle-bold.ttf", 24 )
font_row_1 = 3
font_row_2 = 20
font_row_3 = 37
blank_icon = 1

game = {state = 1, give_direction = "None", day_time = 6000, day_count = 1,
	tile_selected_x = 0,tile_selected_y = 0, mouse_last_x=0, mouse_last_y=0, 
	draw_x=-100, draw_y=-100, screen_width = love.graphics.getWidth(), love.graphics.getHeight(),
	scroll_speed=3, loc_selected_x = 0, loc_selected_y = 0, --lx+ 32 --ly+ 16
	tilecount = 32, actor_speed = 2, printx = 0, printy = 0, -- 0  -62-- 536-600
	water_tile = 38, hole_tile = 37, fish_icon = 16, bridge_tile1 = 21,
	bridge_tile2 = 22, axe_icon = 52, shovel_icon = 15, green_selected = 39, 
	yellow_selected = 40, house_to_build = 0, road_to_build = 0, day_ttl = 1200,
	nightwolf = 42, --night wolves!
	current_weather = 2, days_without_rain = 0, days_rained = 0, days_snowed = 0,
	current_catastrophy = 0, days_since_regrowth = 0,

	biome = "forest", game_paused = 0, game_roster = 0, game_mque = 0,
	show_menu = 1, version = g_version, roster_selected = "Villagers",
	loading_res = false,
	togglesound = "on",
	map_generated = 0, show_tutorial = 1,
	message_box_text = "None",  message_box_icon = 3, message_box_timer = 0,
	records_tab = 1,
	research_timer = 0, disablekeyboard = 0, disablescrolling = 0, lastscreenshot=0,
	mayor_sex = 62, --62 male 63 female
	message_num = 0,
	zoom_level = 1,
	earthquake_draw_offset = 5, earthquake_timer = 1000, earthquake_shake_timer = 0, earthquake = 0,
	merchant_arrived = 0, --if to draw merchants
	trading_timer = 0, -- how long they stay at the post
	merchant_spawn_x=0, merchant_spawn_y=0, --start location of current merchants(randomly set on arrival)
	merchant_target_x = 0, merchant_target_y = 0
}

weather = {
  "A fog has come", 
  "The weather is clear", 
  "Cool weather has come", 
  "The Cold has come", 
  "It is Cloudy", 
  "It is Sunny", 
  "It is Hot", 
  "The heat is Sweltering", 
  "Feel the Sunshine", 
  "The weather is Cloudy", 
  "It is Sprinkling", -- Greater than 10 (rain)
  "There has come a Light Rain", 
  "There has come a Heavy Downpour",
  "It is Snowing",   -- Greater than 13 snow
  "There is a Blizzard" }


--function run_weather_trigger()
--function run_catastrophies_trigger()
villager_jobs = {"idle", "gather food", "cut trees", "dig hole", "build house",
	"build road", "eat food", "sleep", "take break"}
game_tiles = {}
game_icons = {}
game_map = {}
game_fire_map =  {} --check if tile is on fire!
game_road_map = {}
game_sprites = {}
weather_quads = {}
game_directives = {active = 0, timer = 0, location_x = 0, location_y = 0, 
		  job_type = "None", research_type = "None"
}
game_job_que = {}
--message, line2, icon, timer, priority
game_message_que = {}
game_invaders = {} --bandits, armies, vikings, zombies, etc.
game_villagers = {}
game_families = {}
game_adults = {}
game_wildlife = {}
game_villager_pets = {}
kingdom_inventory = {wood = 0, sakura = 0, bamboo = 0, carrots = 0, sansai = 0,
		     raw_meat =0, smoked_meat = 0, tomatoes = 0, saltwort = 0,
		     mushrooms = 0, fish = 0, smoked_fish = 0, grain = 0, cherries = 0,
		     fishwine = 0, paleale=0, apples = 0, desert_onions = 0,
		     rocks = 0, iron_ore = 0, rocksalt = 0, sandstone = 0,
	iron_ingots = 0, gold_ore = 0, gold_ingots = 0, unrest = 0, 
	hunger = 0, homes = 0, homeless = 0, mine = 0, barns = 0, farmplot = 0, 
	chickenfarm = 0, inns = 0, bonfire = 0, schools = 0, graveyards = 0, 
	tradepost = 0, sheriff = 0, fishinghut = 0, ghosts=0,
	villagers = 0, holyman = 0, dark_elves = 0, werewolves=0, families = 0,
	dwarves = 0,
	monument = 0, watchtower = 0, smelter = 0, brewery = 0, smithy = 0
}

require( "villagers")
require( "topics" )
require( "filesave" )
require( "research" )
require( "mouse" )
require( "buildings" )
require( "menu")
require( "update")
require( "catastrophies" ) -- new functions
require( "render" )
require( "invaders" )
require( "merchants")
require( "animals")

math.randomseed(os.time())

function play_sound(sound)
   if game.togglesound == "on" then
      love.audio.play(sound)
   end
end

function play_music(sound)
   if game.togglesound == "on" then
      ---huh?
   end
end

-------------------MESSAGE QUE PROTOTYPE --------------
--add a message to the que
function message_que_add(message, timer, icon)
   game.message_num = game.message_num+1
   game.message_box_text = message
   game.message_box_timer = timer
   if icon > 55 then
      game.message_box_icon = 3
   else
      game.message_box_icon = icon
   end
   
   m = {
      mtext = message, 
      old=true, 
      mtimer = timer, 
      micon = game.message_box_icon,
      mtime="D:"..game.day_count.." T:"..game.day_time, 
      game.message_num}
   table.insert(game_message_que, m) --insert into the table
   if table.getn(game_message_que) > 15 then
      table.remove(game_message_que, 1)
   end
end
--remove the first message with 0 timer encountered.

function is_night() -- 1 yes, 0 no
   hard_time = math.floor(game.day_time/1000)
   if hard_time <= 4 or hard_time >= 21 then
      return 1
   else
      return 0
   end
end

function tile_near_water( gtsy, gtsx ) --game.tile_selected_x )
   if gtsy > 1 and game_map[gtsy -1][gtsx] == game.water_tile then
      return 1
   elseif gtsy < game.tilecount and game_map[gtsy +1][gtsx] == game.water_tile then
      return 1
   elseif gtsx > 1 and game_map[gtsy][gtsx-1] == game.water_tile then
      return 1
   elseif gtsx < game.tilecount and game_map[gtsy][gtsx+1] == game.water_tile then
      return 1
   else
      return 0
   end
end

function new_game_map()
   local river = math.random(1,5)
   local lake = math.random(1,5)
   local lake_x = math.random(7, game.tilecount - 7)
   local lake_y = math.random(7, game.tilecount - 7)
   local tree_density = math.random(2,10)
   local t
   for y = 1, game.tilecount do -- create a random map.
      row = {}
      fire_row = {}
      road_row = {} -- check for houses
      table.insert(game_map, row)
      table.insert(game_fire_map, fire_row)
      table.insert(game_road_map, road_row)
      --table.insert(game_house_map, house_row)
      for x = 1, game.tilecount do
	 table.insert(game_fire_map[y], 0)
	 table.insert(game_road_map[y], 0)
	 water_random = math.random(1,100)
	 bridge_random = math.random(1,2)
	 if water_random == 1 then
	    table.insert(game_map[y], game.water_tile)
	 else
	    t = math.random(1, tree_density )
	    if t == 1 then
	    	table.insert(game_map[y], 2)
	    else
	    	table.insert(game_map[y], math.random(1,20))
	    end
	 end--end if water random
      end--end for
   end--end for
   
   --random for 7x7 lake
   lake_yy = lake_y+7
   lake_xx = lake_x+7
   if lake == 1 then
      for y = lake_y, lake_yy do -- create a random map.
	 for x = lake_x, lake_xx do
	    game_map[y][x] = game.water_tile
	    jagged = math.random(0,1)
	    tilemaker = math.random(1,20)
	    if game.biome == "japan" then tilemaker = 2 end
	    if x == lake_x  and jagged == 1 then
	       game_map[y][x] = tilemaker
	    end
	    if y == lake_y  and jagged == 1 then
	       game_map[y][x] = tilemaker
	    end
	    if x == lake_xx and jagged == 1 then
					game_map[y][x] = tilemaker
	    end
	    if y == lake_yy and jagged == 1 then
	       game_map[y][x] = tilemaker
	    end
	 end
      end
   end
   if river == 1 then
      vh = math.random(0,1) -- vertical or horizontal
      river_loc = math.random( 3, game.tilecount -3)
      if vh == 0 then -- vertical
	 for y = 1, game.tilecount do
	    jagged = math.random(0,2)
	    game_map[y][river_loc] = game.water_tile
	    if jagged == 1 then
	       game_map[y][river_loc-1] = game.water_tile
	    elseif jagged == 2 then
	       game_map[y][river_loc+1] = game.water_tile
	    end--endif
	 end
      else            -- horizontal
	 for x = 1, game.tilecount do
	    game_map[river_loc][x] = game.water_tile
	    jagged = math.random(0,2)
	    if jagged == 1 then
	       game_map[river_loc-1][x] = game.water_tile
	    elseif jagged == 2 then
	       game_map[river_loc+1][x] = game.water_tile
	    end--endif
	 end--endfor
      end--endif
   end
   game.map_generated = 1
   message_que_add("Village Founded.", 66, 7)
end--end fucntion30

function instant_update_map() -- check map after an event and update accordingly.
   for y = 1, game.tilecount do --this updates weekly but for purposes
      for x = 1, game.tilecount do
	 if game_map[y][x] == 37 then --if its a hole 
	    if y > 1 and x > 1 and game_map[y][x+1] and game_map[y][x+1] == 38 then
	       game_map[y][x] = 38
	    elseif y > 1 and x > 1 and game_map[y][x-1] and game_map[y][x-1] == 38 then
	       game_map[y][x] = 38
	    elseif y > 1 and x > 1 and game_map[y+1][x] and game_map[y+1][x] == 38 then --threw an error (was digging map edge)
	       game_map[y][x] = 38
	    elseif y > 1 and x > 1 and game_map[y-1][x] and game_map[y-1][x] == 38 then
	       game_map[y][x] = 38
	    end--endif y>1
	 end--endif game_map[y][x]==37
      end--end for x=1
   end--end for y=1
end--end fuction instant_update_map()
function fire_ravage_tile(tile) --to be run after each "hour"
   if (tile == 2) then
      return 1
   elseif (tile==55) then
      return 1
   elseif (tile==56) then
      return 1
      --3-20
   elseif (tile>=3 and tile <=20) then
      return 76 --to game_map (fix tile in gimp ok)
   elseif (tile>=57 and tile <=60) then
      return 76
   else
      return tile --its not burning.
   end
end
function check_fireproof(tile, firetile) --true, fireproof false burnable!   check to see if tile is burnable
   if (tile == 1 ) then  --dirt
      return true
   elseif(tile == 61 ) then -- burned out?
      return true
   elseif(tile == 45) then --trenches	
      return true
   elseif(tile == 46) then --water
      return true -- cant burn water!
   else 
      return false 
   end
end

function vandalize_monument() --map update
   message_que_add("Someone has vandalized a statue of the mayor!" , 1, game.mayor_sex)
   kingdom_inventory.unrest = kingdom_inventory.unrest +5
   --TODO, make the game_road_map[y][x] = 79
   --TODO, on draw, if game_road_map[y][x] == 79 then draw game.mayor_sex then draw game_road_map[y][x]
   for y = 1, game.tilecount do
      for x = 1, game.tilecount do
	 if game_road_map[y][x] == 62 or game_road_map[y][x] == 63 then --see a clean statue
	    game_road_map[y][x] = 68 --vandalize the statue.
	    break --break the loop in case there are multiple statue.
	 end
      end
   end
end

function create_new_scene(file)
   table.insert(game_villagers, new_villager(1) ) --make sure starting villagers are not
   table.insert(game_villagers, new_villager(1) ) --aflicted with the various things that
   table.insert(game_villagers, new_villager(1) ) --migrants can bring in.
   table.insert(game_villagers, new_villager(1) )
   table.insert(game_villagers, new_villager(1) )
   if kingdom_inventory.dwarves > 0 then
   	research_topics.smelter = 1
   	research_topics.smithy = 1
   end
   update_migration_relations(game_villagers) -- test code
   
   game_families = get_villager_famgroups() --update the families
   --new code count families, based on the family table
   kingdom_inventory.families = table.getn(game_families)  --get_villager_families(game_villagers)
   
   table.insert(game_wildlife,  new_wildlife(0, "random") )
   table.insert(game_wildlife,  new_wildlife(0, "random") )
   table.insert(game_wildlife,  new_wildlife(0, "random") )
   table.insert(game_wildlife,  new_wildlife(0, "random") )
   table.insert(game_wildlife,  new_wildlife(0, "random") )
   
   kingdom_inventory.villagers = 5
   new_village_mayor(game_villagers)
   new_game_map()
   animationRate = 12
   startTime = love.timer.getTime()
   mouse_x, mouse_y = love.mouse.getPosition()
end

function go_fullscreen()
   if fullscreen_hack == "no" then
      if game.version == "0.8.0" then 
	 love.graphics.setMode(0, 0, true, false)  -- 0.8.0
	 love.graphics.setMode(love.graphics.getMode())
      else 
	 flags = {
	    fullscreen = true,
	    fullscreentype = "normal",
	    vsync = true,
	    fsaa = 0,
	    resizable = false,
	    borderless = false,
	    centered = true,
	    display = 1,
	    minwidth = 1,
	    minheight = 1 
	 }		
	 love.window.setMode( 0, 0, flags )
	 fullscreen_hack = "yes"
      end -- 0.9.0
   else --fullscreen_hack = "yes"
      if game.version == "0.8.0" then 
	 love.graphics.setMode(800, 600, false, false)  -- 0.8.0
	 --love.graphics.setMode(love.graphics.getMode())
      else 
	 flags = { fullscreen = false,	fullscreentype = "normal",	vsync = true,
		   fsaa = 0,resizable = false,borderless = false,centered = true,	display = 1,
		   minwidth = 1,minheight = 1 }
	 love.window.setMode( 800, 600, flags ) 
      end -- version == "0.8.0" then 
      fullscreen_hack = "no"
   end--fullscreen_hack == "no" then
   game.screen_height = love.graphics.getHeight()
   game.screen_width  = love.graphics.getWidth()
end

function mouse_left_icons_pressed(x, y, button)
   return game.givedirection
end

function load_game_res() --- load game resources after a love version has been selected
   local tile_dir = "data/tiles/"
   local forest_tile_dir = "data/tiles/forest"
   local japan_tile_dir = "data/tiles/japan"
   local desert_tile_dir = "data/tiles/desert"
   
   local icon_dir = "data/icons/"
   local sprite_dir = "data/sprites/"
   local tile_files = nil
   local icon_files = nil
   local sprite_files = nil
   --local biome_random = math.random(1,2) --bug!
   --if biome_random == 2 then game.biome = "japan" end --it was set to forest before
   if game.version == "0.9.0" then
      --tile_files = love.filesystem.getDirectoryItems(tile_dir)
      -- just load one biome?
      if game.biome == "forest" then
      	tiles_image = love.graphics.newImage("data/tiles/forest/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      elseif game.biome == "japan" then
      	tiles_image = love.graphics.newImage("data/tiles/japan/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      elseif game.biome == "desert" then
      	tiles_image = love.graphics.newImage("data/tiles/desert/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      else
      	tiles_image = love.graphics.newImage("data/tiles/japan/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      end
      table.insert(weather_quads, love.graphics.newQuad(0,0,  200,200,  400,200))
      table.insert(weather_quads, love.graphics.newQuad(200,0,200,200,  400,200))
      --end new code
      icon_files = love.filesystem.getDirectoryItems(icon_dir)
      sprite_files = love.filesystem.getDirectoryItems(sprite_dir)
   else --lower than 0.9.0
      --tile_files = love.filesystem.enumerate(tile_dir)
      -- just load one biome?
      if game.biome == "forest" then
      	japan_tiles = love.graphics.newImage("data/tiles/forest/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      elseif game.biome == "japan" then
      	japan_tiles = love.graphics.newImage("data/tiles/forest/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      elseif game.biome == "desert" then
      	japan_tiles = love.graphics.newImage("data/tiles/desert/tiles01.png")
      	weather_image = love.graphics.newImage("data/tiles/japan/weather01.png")
      end
      --end new code
      icon_files = love.filesystem.enumerate(icon_dir)
      sprite_files = love.filesystem.enumerate(sprite_dir)
   end
   --for k, file in ipairs(tile_files) do
   --   table.insert(game_tiles, love.graphics.newImage(tile_dir..file) )
   --end--end44
   for j = 0,9 do
      for k = 0,7 do -- 8x10--64x100 --512 × 1000 --game_tiles = {}
	 --quad = love.graphics.newQuad( x, y, width, height, sw, sh )
	 local px = k*64
	 local py = j*100
	 table.insert(game_tiles, love.graphics.newQuad(px,py,64,100,512,1000 ) )
      end
   end -- end quad loop
   
   for k, file in ipairs(icon_files) do
      table.insert(game_icons, love.graphics.newImage(icon_dir..file) )
   end
   for k, file in ipairs(sprite_files) do
      table.insert(game_sprites, love.graphics.newImage(sprite_dir..file))
   end
   --if save file exists then load save file	--else
   
   --create_new_scene(file) --move to right when new game is pressed.
   --end
   if fullscreen_hack == "yes" then
      if game.version == "0.8.0" then 
	 love.graphics.setMode(0, 0, true, false)  -- 0.8.0
      else 
	 flags = {
	    fullscreen = true,
	    fullscreentype = "normal",
	    vsync = true,
	    fsaa = 0,
	    resizable = false,
	    borderless = false,
	    centered = true,
	    display = 1,
	    minwidth = 1,
	    minheight = 1 }
	 love.window.setMode( 0, 0, flags ) 
      end -- if version == "0.8.0" then love.graphics.setMode(0, 0, true, false)0.9.0
   end--fullscreen_hack == "yes" then
end
---------------------------------------
-- the love.functions!
---------------------------------------
function love.load()
   resource_bar = love.graphics.newImage("data/images/resource_bar.png")
   records_button = love.graphics.newImage("data/images/records_button.png")
   game_menu_miniload() --miniload to add graphics to the menu before resources are loaded.
   biome_forest_img = love.graphics.newImage("data/images/icon_074.png")
   biome_japan_img = love.graphics.newImage("data/images/icon_075.png")
   biome_desert_img = love.graphics.newImage("data/images/icon_076.png")
   sound_build_house = love.audio.newSource("data/sounds/cut_pumpkin_02.ogg", "static")
   sound_light_breeze = love.audio.newSource("data/sounds/wind_1.ogg", "static")
   sound_daytime     = love.audio.newSource("data/sounds/wind_1.ogg", "static")
   sound_nighttime = love.audio.newSource("data/sounds/wind_2_night.ogg", "static")
   sound_click = love.audio.newSource("data/sounds/tim_click.ogg")
   sound_treecutting = love.audio.newSource("data/sounds/tree_cutting.ogg")
   music_townbg1 = love.audio.newSource("data/sounds/041415calmbgm_0.ogg")
   music_townbg1:setLooping( true )
   music_nightbg1 = love.audio.newSource("data/sounds/un_com_night.ogg")
   music_nightbg1:setLooping( true )
end

function get_kingdom_researchable()
   if kingdom_inventory.schools > 0 or kingdom_inventory.dark_elves > 0 then
      return 1
   else
      return 0
   end
end
---------------------------------------
function love.keypressed(key)
   if game.disablekeyboard == 0 then
      if key == "e" then
	 screenshot = love.graphics.newScreenshot( false )
	 screenshot:encode("screenie"..game.lastscreenshot..".jpg")
	 game.lastscreenshot = game.lastscreenshot+1
      elseif key == "escape" then
	 --love_crude_save() --save/quit autosave feature
	 --love.event.quit()
	 if game.show_menu == 0 then game.show_menu = 1
	 else game.show_menu = 0 end
      elseif key == "f2" then
	 go_fullscreen()
      elseif key == "s" then
	 love_crude_save() -- crude saving
      elseif key == "c" then
	 game.draw_x = 0--center the field of view
	 game.draw_y = 0
      elseif key == "z" then
	 game.zoom_level=game.zoom_level +0.2
      elseif key == "x" then
	 game.zoom_level=game.zoom_level -0.2
      elseif key == "r" then --reports
	 if game.game_mque == 0 then
	    game.game_mque = 1
	 else 
	    game.game_mque = 0
	 end
      elseif key == "l" then
	 love_crude_load()
	 message_que_add("Game loaded."..j.name.."!", 100, 1) -- produce message 1
      elseif key == " " then
	 if game.game_paused == 0 then
	    game.game_paused = 1
	 else
	    game.game_paused = 0
	 end   	
      end
   end--endif
end

---------------------------------------
function love.draw()
   if game.show_menu == 1 then
      game_menu_draw()
   elseif game.show_menu == 2 then
      draw_biome_select() -- select which biome.
   else	
      game.screen_height = love.graphics.getHeight()
      game.screen_width  = love.graphics.getWidth()
      local xdraw = math.random(1, 20)
      love.graphics.setFont( base_font )
      if game.show_menu == 1 then 
      end
      love.graphics.push()	love.graphics.scale(game.zoom_level)
      draw_game_tiles()
      
      ----------------------------------- END DRAWING TILES
      draw_villagers() -- draw villagers
      --draw wildlife
      draw_wildlife()
      draw_merchants()
      --draw weather
      --draw_night_lights()
      love.graphics.pop()
      draw_weather(game.current_weather)
      draw_task_icons()
      
      draw_research_icons()
      ------------------- TOP UI Drawing ---------------------------------
      --draw_inventory_icons()
      draw_resource_bar()
      draw_game_ui()
      if game.game_roster == 1 then
	 draw_roster_list()
      elseif game.game_mque == 1 then
	 draw_message_que()
      end
      ----------------------- END TOP UI Drawing ------------------------
   end--endif
end--end function
