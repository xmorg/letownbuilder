--plans, bears!, bonfires, fires spreading(buggy)
--bugs: building homes on top of homes increases ammount of homes(exploit)
--Prototypes!
--function update_villager_jobs(dt)
--function love_crude_load()
--function love_crude_save()
--function villager_touched(v1, v2)
version = "0.9.0" --"0.8.0"
fullscreen_hack = "no"
game = {state = 1, give_direction = "None", day_time = 11000, day_count = 1,
	tile_selected_x = 0,tile_selected_y = 0, mouse_last_x=0, mouse_last_y=0, 
	draw_x=-100, draw_y=-100, screen_width = 800, screen_height = 600,
	scroll_speed=3, loc_selected_x = 0, loc_selected_y = 0, --lx+ 32 --ly+ 16
	tilecount = 32, actor_speed = 2, printx = 0, printy = 0, -- 0  -62-- 536-600
	water_tile = 38, hole_tile = 37, fish_icon = 22, bridge_tile1 = 21,
	bridge_tile2 = 22, axe_icon = 85, shovel_icon = 21, green_selected = 39, 
	yellow_selected = 40, house_to_build = 0, road_to_build = 0, day_ttl = 1200,
	message_box_timer = 0, game_paused = 0, event_text = "None", 
	event_text2 = "None", message_box_icon = 2, biome = "forest",
	research_timer = 0 
}
villager_jobs = {"idle", "gather food", "cut trees", "dig hole", "build house",
	"build road", "eat food", "sleep", "take break"}
game_tiles = {}
game_icons = {}
game_map = {}
game_fire_map =  {} --check if tile is on fire!
game_sprites = {}
game_directives = {active = 0, timer = 0, location_x = 0, location_y = 0, 
		  job_type = "None", research_type = "None"
}
game_job_que = {}
game_villagers = {}
game_wildlife = {}
kingdom_inventory = {wood = 0, sakura = 0, bamboo = 0, carrots = 0, sansai = 0,
	mushrooms = 0, fish = 0, grain = 0, cherries = 0, rocks = 0, unrest = 0, 
	hunger = 0, homes = 0, homeless = 0, mine = 0, barns = 0, farmplot = 0, 
	chickenfarm = 0, inns = 0, bonfire = 0, schools = 0, graveyards = 0, 
	tradepost = 0, sheriff = 0, fishinghut = 0,
	villagers = 0, holyman = 0, dark_elves = 0, werewolves=0, families = 0
}


--fonts data/newscycle-regular.ttf   data/newscycle-bold.ttf
base_font = love.graphics.newFont("data/newscycle-bold.ttf", 14 )
big_font = love.graphics.newFont("data/newscycle-bold.ttf", 24 )
font_row_1 = 3
font_row_2 = 20
font_row_3 = 37
	
research_topics = { economy = 0, security = 0, agriculture = 0, civics = 0, industry = 0}
crude_names_front = {"Al", "Bre", "Cel", "Dan", "Ed", "Ford", "Guy", "Haus", "Ister",
	"Jim", "Kael", "Liam", "Mor", "Nast", "Oh", "Pel", "Qin", "Ray", "Sten","Tell",
	"Urst", "Val", "Wist", "Xen", "Yor", "Zum"}
crude_names_back = {"ane", "eber", "ic", "od", "ue", "af", "eg", "him", "oi",
	"aj", "ek", "ille", "om", "un", "ao", "ep", "quipp", "or", "us","at",
	"eur", "iv", "ow", "ux", "ay", "ez"
}

--Note there needs to be 27 items or you will get an array out of bounds nill!
talk_topics_happy = { "Hello", "Im Hungry", "Will no one help me?", "I think i saw a bear!",
	"Im cold", "What is the meaning of life?", "There she goes!", "I feel so lonely",
	"Zombies are real!", "Ho hum....", "What will I do today?", "Think it will rain?",
	"Save the trees!", "Ewww...I think I stepped in something.", "Im thirsty", "Love your brother",
	"Squirrels!", "Argh! Rabbits after my patuleas again!", "Hey I think we...hmm forgot",
	"Are snails edible?", "There is an odour under my arms.", "I see things in my sleep",
	"bleh...", "Hahahaha!", "Hehehe....", "Whats this?", "Go ahead... make my day!"}

talk_topics_ok = {"Keep a stiff upperlip", "Just hang in there", "We are ok.",
	"We've had our struggles", "Hard work can solve anything", "Maybe ill get my house tomorrow?", 
	"Id rather have fish than carrots", "That bear ate my food!", "Your roof is leaking", 
	"Is it me or is the water drying up?", "Psst, you stink", "Keep a stiff upperlip", 
	"Just hang in there", "We are ok.", "We've had our struggles", 
	"Hard work can solve anything", "Maybe ill get my house tomorrow?", 
	"Id rather have fish than carrots", "That bear ate my food!", "Your roof is leaking", 
	"Is it me or is the water drying up?", "Psst, your stink","That bear ate my food!", 
	"Its not bad, here just....", "Im ok, for now.", "Im soooo hongry...", 
	"We'll sleep on the ground tonight."}
talk_topics_grumbling = {"Carrots again?!?!", "How are we expected to live like this?", 
	"Oh well...", "This aint right!", "Well maybe there will be food tomorrow", 
	"Mayor? Um...", "Life is hard", "I see a train wreck coming.", 
	"This villiage is headed for disaster", "Is the mayor braindead?", 
	"If I gotta cut another tree, im gonna lose it.","Is the mayor asleep?", 
	"Corruption is to blame", "Liberals fouling up our homes!", 
	"There are no jobs!", "The taxes are too high!", "Why me? I can barely feed myself!", 
	"grrr...hmmm... oh nothing", "You all are just LAZY!", "Why, why?!?!", 
	"Im so miserable!","Hello?!?! does anyone care?", "This is all your fault!",
	"Whats the point of even trying?", "Im on strike!", "This will get worse",
	"We need more boards!"}

talk_topics_angry = {"No food again?", "Im still hungry!", "How could it get any worse?", 
	"someone otta do something!", "Im about to blow my top!", "Im starving!",
	"Its about to hit the fan!", "The end is near!", "This is all because of our sins!", 
	"How are we expected to live like this?", "The food is gone...again", 
	"This ain't right!","We are all going to die!", "You can't make me do nothing!",
	"Im going to start burning things!","You wont like me when im angry",
	"Im so mad!","Bite me, Mayor!","Its unbearable.","This is horrible!",
	"Someone's gonna pay!","Im broke, hungry and homless...yea","How about punch me in the face too!",
	"Right off a cliff...yea","I hate everyone!","Im so tired of this!",
	"Im not gonna die here!"}

talk_topics_riot = {"Rawr!", "I want blood!", "Bring out the Mayor!", 
	"Argh!", "Oh, you're gonna hear ME roar!", "Burn everything!", 
	"Burn the trees!", "Someone save me!", "its officially hit the fan!", 
	"Break their bones!", "Aiiieeee!", "Smash!", "Take their Blue ray players!", 
	"Fire, heheheh...", "We're not gonna take this anymore!", "Ill just eat YOU!", 
	"Die, Die. DIE!", "I wish I were dead!", "Flee for your lives!", 
	"For the slaying of the sword!", "Death to the breathers!", "Bring the pain!", 
	"Grrrr!", "Argh! my Knee!", "Bleed on me, and ill hurt you!", "WAAAAGH!", 
	""}
talk_topics_werewolf ={"Aaaoooo!", "Fooooooooood!", "[snarl]",  "[growl]",
	"[sniff][sniff]", "Ouuuuu!", "Arrraa!", "....",
	" ", " ", " ", " ",	" ", " ", " ", " ",	" ", " ", " ",	" ", " ", " ",
	" ", " ", " ", " ", " "
}
talk_topics_holyman ={"Bless you my child", "Bless you dear", "You are absolved",  
	"Dont forget to tithe", "Good shall always prevail", "This too shall pass", 
	"Do we need an inquisition?", "....",	"Cleanse your mind", "Fear no evil ", 
	"Do you have something to confess? ", "Dark Elves cannot be saved.",	
	"Repent!!!", "Give and it shall be given.", "The church needs repair ", 
	"Dont believe gossip",	"Obey the mayor.", "Work hard and give offerings ", 
	"Love your bother",	"More wine is needed for sacrement", 
	"More food is needed for sacrement", "Time heals all", "Fast today, eat tomorrow ", 
	"Beware of sin!", "Obey your parents.", "Blessed are the humble.", 
	"Blessed are the meek."
}
villager_types = { "normal", "dark elf", "bandit", "werewolf", "holyman"
}

tutorial_messages = { 
	--set a tutorial timer to 100, and run the timer down before displaying the next message
	--If you are required to collect something before proceeding, then wait until conditions are met
	--if tutorial_level == 1 and tutorial_timer == ??
	"Welcome to LeTownBuilder, lets get started!", --tutorial_level 0 and tutorial_timer = 0
	--set tutorial_level = 2 and tutorial_timer = 100
	--if tutorial_level == 2 and tutorial_timer == 0
	"First things first. You need to eat! collect at least 5 food by gathering in a forest tile",
	--if food >= 5 and tutorial level == 2
	--set tutorial_level = 3 and tutorial_timer = 100
	"Now you're cooking! Well not quite, but at least you wont starve.",
	--set tutorial_level = 4
	--if tutorial level == 4 and tutorial_timer = 0
	"Next, your villagers need shelter.  Cut down some trees needed for wood.",
	--if wood >= 5
	"Good Job! But you can't build a house just yet. The foundation requires stone.  Dig holes to find stone.",
	--set tutorial_level = 5
	--if tutorial_level == 5 and tutorial_timer = 0
	"Now you got some stone!",
	"Now lets build a house!",
	"Great! You need as many houses as residents, or some villagers will go homeless"
}

math.randomseed(os.time())

function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end


function love_crude_load()
	chunk = love.filesystem.load( "game.lua" )
	chunk()
	
	chunk = love.filesystem.load( "game_directives.lua" )
	chunk()
	
	chunk = love.filesystem.load( "kingdom_inventory.lua" )
	chunk()
	
	chunk = love.filesystem.load( "research_topics.lua" )
	chunk()  -- research_topics
	
	chunk = love.filesystem.load( "game_villagers.lua" )
	chunk()  --
	
	chunk = love.filesystem.load( "game_map.lua" )
	chunk()  -- 
	
	chunk = love.filesystem.load( "game_fire_map.lua" )
	chunk()  -- 
	
	chunk = love.filesystem.load( "game_wildlife.lua" )
	chunk()
end

function love_crude_save()
	love.filesystem.write( "game.lua", 
		table.show(game, "game")) 
	love.filesystem.write( "game_directives.lua", 
		table.show(game_directives, "game_directives")) 
	love.filesystem.write( "kingdom_inventory.lua", 
		table.show(kingdom_inventory, "kingdom_inventory"))
	love.filesystem.write( "research_topics.lua", 
		table.show(research_topics, "research_topics"))
	--research_topics
	love.filesystem.write( "game_villagers.lua", 
		table.show(game_villagers, "game_villagers"))
	love.filesystem.write( "game_map.lua", 
		table.show(game_map, "game_map"))
		
	love.filesystem.write( "game_fire_map.lua", 
		table.show(game_fire_map, "game_fire_map"))
		
	love.filesystem.write( "game_wildlife.lua", 
		table.show(game_wildlife, "game_wildlife"))	
		
end

function villager_touched(v1, v2) --if villagers colliding with each other.
	tx = v1.x +2
	ty = v1.y +10
	if tx >= v2.x and tx <= v2.x+5 and ty >= v2.y and ty <= v2.y+10 then
		return 1
	else 
		return 0
	end
end
function update_villager_gohome(v) --game_villagers[i])
	--this villager wants to go to his/her own house
	--given house_x, house_y make villager go to the location of this tile
	--set the dx/dy to the x/y of the location of the tile
	local one = 1
end
function update_villager_assign_house(x, y) -- give them by tile selected
	for i,v in ipairs(game_villagers) do
		if game_villagers[i].house_x == 0 and game_villagers[i].house_x == 0 then
			game_villagers[i].house_x = x
			game_villagers[i].house_y = y
			break
		end
	end
end
function get_villager_families(vil)
	--loop through villagers, and analyze who is husband/wife
	--loop through villagers and analize who is scion of
	--kids have their own families if they have no parents
	--adults have their own families if they have not spouse
	--everyone else is families + (everyone_else/2)
	local families = 0
	local single_family = 0
	local married_adult = 0
	local child_w_parents = 0
	local everyone_else = 0
	for i,v in ipairs(vil) do
		if vil[i].scion_of == "None" and vil[i].age < 18 then
			single_family = single_family+1
		elseif vil[i].scion_of ~= "None" and vil[i].age < 18 then
			child_w_parents = child_w_parents+1
		elseif vil[i].spouse_of == "None" and vil[i].age >= 18 then
			single_family = single_family+1
		elseif vil[i].spouse_of ~= "None" then
			married_adult = married_adult+1
		end
	end
	families = single_family + (married_adult/2)
	families = math.floor(families) --just in case there are missing...?'s?
	return families
end
function update_migration_relations(vil)
	--given the list of villagers, assign children to parents.
	--randomly assign female to male relationships.
	for i,v in ipairs(vil) do
		if vil[i].spouse_of == "None" and vil[i].sex == 0 then
			for i2,v2 in ipairs(vil) do
				if vil[i2].spouse_of == "None" and vil[i2].sex == 1 then
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
end--endfucntion

function new_wildlife(migration)
	local start_x = math.random(100,900)
	local start_y = math.random(100,900)
	a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
			  died_x = 0, died_y = 0, direction = 0, job = 0, speak = 0, 
			  talk_timer = 0, alive=1, --always start alive 
			  sex = math.random(0,1), --0 male, 1 female
			  age = nil, --math.random 18,65
			  wildlife_type = "rabbit", -- 1, normal, 2, dark elf, 3 bandit, 4 light elf
			  speed = 0
	}
	if migration == 0 then
		a.age = math.random(18,50)
		a.wildlife_type = "rabbit"
	else
		a.age = math.random(1,70)
		a.wildlife_type = "rabbit"
	end --if migration == 0 then
	if a.wildlife_type == "rabbit" then 
		a.speed = 15 
	end
	return a
end

function new_villager(migration)
	local start_x = math.random(400,600)
	local start_y = math.random(400,600)
	a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
			  died_x = 0, died_y = 0, direction = 0, 
			  job = "idle", 
			  speak = 0, 
			  talk_timer = 0, alive=1, --always start alive 
			  name = crude_names_front[math.random(1,26)]..crude_names_back[math.random(1,26)],  
			  sex = math.random(0,1), --0 male, 1 female
			  age = nil, --math.random 18,65
			  villager_type = "normal", -- 1, normal, 2, dark elf, 3 bandit, 4 light elf
			  house_x = 0, 
			  house_y = 0,
			  spouse_of = "None",
			  scion_of  = "None",
			  position = "peasant"			  
	}
	if migration == 0 then
		a.age = math.random(18,50)
	else
		a.age = math.random(1,70)
		--TODO: Decrease the chances of getting these.
		troublemaker = math.random(1,100)
		if troublemaker == 1 then -- create a troublemaker
			random_type = math.random(1, table.getn(villager_types))
			a.villager_type = villager_types[random_type]
		end
	end --if migration == 0 then
	--some testing code
	--a.villager_type = villager_types[ math.random(1, table.getn(villager_types)) ]---testing!
	if a.villager_type == "werewolf" then
		kingdom_inventory.werewolves=kingdom_inventory.werewolves+1
	elseif a.villager_type == "dark elf" then
		kingdom_inventory.dark_elves=kingdom_inventory.dark_elves+1
	elseif a.villager_type == "holyman" then
		kingdom_inventory.holyman=kingdom_inventory.holyman+1
	end
	return a
end
function new_village_mayor(game_villagers)
	adult_count = 0
	--game_villagers[i].alive
	for i, v in ipairs(game_villagers) do
		if game_villagers[i].age > 17 then 
			adult_count = adult_count+1 
		end--count adults
		if game_villagers[i].position == "mayor" then 
			game_villagers[i].position = "peasant" 
		end --clear mayor
	end
	random_mayor = math.random(1, adult_count)--select random mayor
	adult_count = 0 --clear adult count
	for i, v in ipairs(game_villagers) do --loop through game_villagers again
		if game_villagers[i].age > 17 then -- if adult
			if i == random_mayor then 
				game_villagers[i].position = "mayor"
				if game_villagers[i].sex == 1 then 
					mself = "himself"
				else mself = "herself"
					game.event_text = game_villagers[i].name.." has declared "..mself.." 'defacto' mayor for life!"
					game.message_box_timer = 200
				end
			end --endif
		end--endif
	end--endfor
end -- endfunction

function is_night()
	hard_time = math.floor(game.day_time/1000)
	if hard_time <= 4 or hard_time >= 21 then
		return 1
	else
		return 0
	end
end

function munch_food()
	if kingdom_inventory.fish > 0 then kingdom_inventory.fish = kingdom_inventory.fish -1
	elseif kingdom_inventory.mushrooms > 0 then kingdom_inventory.mushrooms = kingdom_inventory.mushrooms -1 
		return 1
	elseif kingdom_inventory.carrots > 0 then kingdom_inventory.carrots = kingdom_inventory.carrots -1
		return 1
	elseif kingdom_inventory.grain > 0 then kingdom_inventory.grain = kingdom_inventory.grain -1
		return 1
	elseif kingdom_inventory.cherries > 0 then kingdom_inventory.cherries = kingdom_inventory.cherries -1
		return 1
	else
		return 0
	end
end

function villagers_eat_food(num_villagers) -- eat food
	local rot_flag = 0
	game.event_text = "Its lunchtime!"  
	game.message_box_timer = 300
	game.message_box_icon  = 98
	
	kingdom_inventory.hunger=0
	--bandits steal food first!
	--loop through villagers, if vandit is alive take food
	for i,v in ipairs(game_villagers) do
		if game_villagers[i].alive == 1 and game_villagers[i].villager_type == "bandit" then
			munch_food()
			game.event_text = game.event_text.." Food has gone missing!"
		end
	end
	for x = 1, num_villagers do
		if munch_food() == 0 then
			kingdom_inventory.hunger = kingdom_inventory.hunger + 1 
			kingdom_inventory.unrest = kingdom_inventory.unrest + kingdom_inventory.hunger
		end
	end
	if kingdom_inventory.hunger == 0 and kingdom_inventory.unrest > 0 then --lower unrest if there is plenty of food.
		kingdom_inventory.unrest = kingdom_inventory.unrest-1
	end
	--after eating food starts to perish(unless you have a barn!
	if kingdom_inventory.fish > 0 and kingdom_inventory.barns == 0 then
	kingdom_inventory.fish = kingdom_inventory.fish -1
	rot_flag = 1
	end
	if kingdom_inventory.carrots > 0 and kingdom_inventory.barns == 0 then
	kingdom_inventory.carrots = kingdom_inventory.carrots -1
	rot_flag = 1
	end
	if kingdom_inventory.mushrooms > 0 and kingdom_inventory.barns == 0 then
	kingdom_inventory.mushrooms = kingdom_inventory.mushrooms -1
	rot_flag = 1
	end
	if kingdom_inventory.grain > 0 and kingdom_inventory.barns == 0 then
	kingdom_inventory.grain = kingdom_inventory.grain -1
	rot_flag = 1
	end
	if rot_flag == 1 then
	game.event_text = game.event_text.." Without proper storage, some of your food rotted!"
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

function villagers_seek_shelter(num_villagers)--check how many homes are availible
	local families = get_villager_families(game_villagers)
	kingdom_inventory.families = families
	game.event_text = "It is night." -- it is night message
	game.message_box_icon = 102
	if kingdom_inventory.bonfire < 1 then
		game.event_text = "It is night.".."  It is dark and cold!"
		-- + unrest if there is no bonfire
		game.message_box_icon = 32
		kingdom_inventory.unrest = kingdom_inventory.unrest+ table.getn(game_villagers)
	end
	game.message_box_timer = 300
	-- TODO: instead of each villager, check for families
	-- TODO:!  It will be hard to know how many homes you need if there is no census taken
	--         of families
	if kingdom_inventory.homes < families then
	--if kingdom_inventory.homes < table.getn(game_villagers) then
		kingdom_inventory.homeless = families - kingdom_inventory.homes
		--kingdom_inventory.homeless = (table.getn(game_villagers) - kingdom_inventory.homes)
		kingdom_inventory.unrest = kingdom_inventory.unrest + kingdom_inventory.homeless
	elseif kingdom_inventory.homes >= table.getn(game_villagers) then --fixed bug where there is always 1 homeless
		kingdom_inventory.homeless = 0
		if kingdom_inventory.unrest > 0 then --general unrest decreases if all are housed
			kingdom_inventory.unrest = kingdom_inventory.unrest - 1
		end
	end
end

function display_game_event(text) --puts a messagebox with a game event of "text"
	--sets a game timer for the messagebox
	love.graphics.setColor(50, 50, 50, 255)
	love.graphics.rectangle("fill", 20, 500, 500, 200)
	love.graphics.setColor(150, 150, 150, 255)
	love.graphics.rectangle("fill", 23, 503, 494, 194)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(text, 53+64, 525, 500, "left")
	if game.event_text2 ~= "None" then
		--event_text2
		love.graphics.printf(game.event_text2, 53+64, 545, 500, "left")
	end
	--put an icon! (thats really a tile! because we dont know... we need tiles!
	love.graphics.draw(game_icons[game.message_box_icon], 45, 510)
end

function new_game_map()
	local river = math.random(1,5)
	local lake = math.random(1,5)
	local lake_x = math.random(7, game.tilecount - 7)
	local lake_y = math.random(7, game.tilecount - 7)
	for y = 1, game.tilecount do -- create a random map.
		row = {}
		fire_row = {}
		table.insert(game_map, row)
		table.insert(game_fire_map, fire_row)
		for x = 1, game.tilecount do
			table.insert(game_fire_map[y], 0)
			water_random = math.random(1,100)
			bridge_random = math.random(1,2)
			if water_random == 1 then
				table.insert(game_map[y], game.water_tile)
			else
				table.insert(game_map[y], math.random(1,20))
			end--end if water random
		end--end for
	end--end for
	
	--game.bu = math.random(1,2)
	local jtilemaker = 2
	if game.biome == "japan" then
		for y = 1, game.tilecount do
			for x = 1, game.tilecount do
				jtilemaker = math.random(55,61)
				if jtilemaker == 61 then jtilemaker = 2 
				elseif jtilemaker > 60 then jtilemaker = 2 --trying to stop an array out of bounds bug
				end
				game_map[y][x] = jtilemaker
			end
		end
	end
	
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
	--debug map
	--love.filesystem.write( "debug.lua", table.show(game_map, "game_map"))	
end--end fucntion30

function instant_update_map() -- check map after an event and update accordingly.
	for y = 1, game.tilecount do --this updates weekly but for purposes
		for x = 1, game.tilecount do
			if game_map[y][x] == 37 then --if its a hole 
				if y > 1 and x > 1 and game_map[y][x+1] and game_map[y][x+1] == 38 then
					game_map[y][x] = 38
				elseif y > 1 and x > 1 and game_map[y][x-1] and game_map[y][x-1] == 38 then
					game_map[y][x] = 38
				elseif y > 1 and x > 1 and game_map[y+1][x] and game_map[y+1][x] == 38 then
					game_map[y][x] = 38
				elseif y > 1 and x > 1 and game_map[y-1][x] and game_map[y-1][x] == 38 then
					game_map[y][x] = 38
				end--endif y>1
			end--endif game_map[y][x]==37
		end--end for x=1
	end--end for y=1
end--end fuction instant_update_map()
function check_fireproof(tile) --check to see if tile is burnable
	if (tile >= 3 and tile <= 26) then return 1
	elseif(tile >= 41 and tile <= 46) then return 1
	else return 0 end
end

function week_update_map() --update the map
	kingdom_inventory.rocks = kingdom_inventory.rocks + (kingdom_inventory.mine * (table.getn(game_villagers)*2))
	--kingdom_inventory.grain = kingdom_inventory.grain + kingdom_inventory.farmplot *10
	kingdom_inventory.homes = 0 --clear for recount
	for y = 1, game.tilecount do --this updates weekly but for purposes
		for x = 1, game.tilecount do
			if game_map[y][x] == 2 then
				game_map[y][x] = 1
			elseif game_map[y][x] == 42 then
				game_map[y][x] = 43
			elseif game_map[y][x] == 43 then
				game_map[y][x] = 44
			elseif game_map[y][x] == 44 then
				game_map[y][x] = 45
			elseif game_map[y][x] == 45 then
				game_map[y][x] = 46
			elseif game_map[y][x] == 46 then
				kingdom_inventory.grain = kingdom_inventory.grain + 5 + (research_topics.agriculture*3)
			elseif game_map[y][x] >= 23 and game_map[y][x] <= 26 then
				kingdom_inventory.homes = kingdom_inventory.homes+1
			end
			if game_fire_map[y][x] == 1 then
				fire_rand = math.random(1,4)
				if (fire_rand == 1) then		-- spread the fire!			
					fire_spread = math.random(1,4)
					if fire_spread == 1 and check_fireproof(game_map[y][x-1]) and game_fire_map[y][x-1] ~= nil then game_fire_map[y][x-1] = 1
					game.event_text = "The fire is spreading!"  
					game.message_box_timer = 300
					elseif fire_spread == 2 and check_fireproof(game_map[y][x+1]) and game_fire_map[y][x+1] ~= nil then game_fire_map[y][x+1] = 1
					game.event_text = "The fire is spreading!"  
					game.message_box_timer = 300
					elseif fire_spread == 3 and check_fireproof(game_map[y-1][x]) and game_fire_map[y-1][x] ~= nil then game_fire_map[y-1][x] = 1
					game.event_text = "The fire is spreading!"  
					game.message_box_timer = 300
					elseif fire_spread == 4 and check_fireproof(game_map[y+1][x]) and game_fire_map[y+1][x] ~= nil then game_fire_map[y+1][x] = 1
					game.event_text = "The fire is spreading!"  
					game.message_box_timer = 300
					end
				end
			end
		end
	end
	--more villagers arrive!
	migrants = math.random(1, 5)
	migrants_tab = {}
	for t=1, migrants do
		table.insert(migrants_tab, new_villager(1) )--put in a temp table		
	end
	update_migration_relations(migrants_tab)--update their relations
	--TODO update t
	
	for t=1, migrants do --put them into the main table.
		table.insert(game_villagers, migrants_tab[t]) 
		kingdom_inventory.villagers =  kingdom_inventory.villagers +1
	end
	kingdom_inventory.families = get_villager_families(game_villagers)
	game.event_text = migrants.." migrants have arrived.  Welcome."  
	--kingdom_inventory.homeless = (kingdom_inventory.villagers - kingdom_inventory.homes)
	game.message_box_timer = 300
	if kingdom_inventory.holyman > 0 and kingdom_inventory.unrest < 60 then
		kingdom_inventory.unrest = kingdom_inventory.unrest - (kingdom_inventory.holyman*5)
		game.event_text = game.event_text.." The people are encouraged by the holyman's sermon"
		if kingdom_inventory.unrest < 0 then
			kingdom_inventory.unrest = 0
		end
	elseif kingdom_inventory.unrest >= 60 then
		kingdom_inventory.unrest = kingdom_inventory.unrest + (kingdom_inventory.holyman*5)
		game.event_text = game.event_text.." The people are outraged by the holyman's sermon!"
	end
end

function create_new_scene(file)
--create_new_map()
	table.insert(game_villagers, new_villager(1) ) --make sure starting villagers are not
	table.insert(game_villagers, new_villager(1) ) --aflicted with the various things that
	table.insert(game_villagers, new_villager(1) ) --migrants can bring in.
	table.insert(game_villagers, new_villager(1) )
	table.insert(game_villagers, new_villager(1) )
	update_migration_relations(game_villagers) -- test code
	kingdom_inventory.families = get_villager_families(game_villagers)
	
	table.insert(game_wildlife,  new_wildlife(0) )
	table.insert(game_wildlife,  new_wildlife(0) )
	table.insert(game_wildlife,  new_wildlife(0) )
	table.insert(game_wildlife,  new_wildlife(0) )
	table.insert(game_wildlife,  new_wildlife(0) )

	kingdom_inventory.villagers = 5
	new_village_mayor(game_villagers)
	new_game_map()
	animationRate = 12
	startTime = love.timer.getTime()
	mouse_x, mouse_y = love.mouse.getPosition()
	sound_build_house = love.audio.newSource("data/sounds/cut_pumpkin_02.ogg", "static")
	sound_light_breeze =love.audio.newSource("data/sounds/wind_0.ogg", "static")
end

function go_fullscreen()
	if fullscreen_hack == "no" then
		if version == "0.8.0" then 
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
			minheight = 1 
			}		
			love.window.setMode( 0, 0, flags )
			fullscreen_hack = "yes"
		end -- 0.9.0
	else --fullscreen_hack = "yes"
		if version == "0.8.0" then 
			love.graphics.setMode(800, 600, false, false)  -- 0.8.0
		else 
			flags = { fullscreen = false,	fullscreentype = "normal",	vsync = true,
				fsaa = 0,resizable = false,borderless = false,centered = true,	display = 1,
				minwidth = 1,minheight = 1 }
			love.window.setMode( 800, 600, flags ) 
		end -- version == "0.8.0" then 
		fullscreen_hack = "no"
	end--fullscreen_hack == "no" then
	--reset the screen_width/height to recalc the buttons
	--game.screen_width = 800, game.screen_height = 600
	game.screen_height = love.graphics.getHeight()
	game.screen_width  = love.graphics.getWidth()
end

function build_house_directive(adirection, jhouse_to_build, house_to_build)
	game.give_direction = adirection --mine
    if game.biome == "japan" then
		game.house_to_build = jhouse_to_build --japan mine
    else
    	game.house_to_build = house_to_build --forest mine
    end
end

function update_checkscrolling(mx, my)
	if game.mouse_last_x > mx and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
   	game.draw_x = game.draw_x-game.scroll_speed
   elseif game.mouse_last_x < mx and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
   	game.draw_x = game.draw_x+game.scroll_speed
   end
   if game.mouse_last_y >  my and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
   	game.draw_y = game.draw_y-game.scroll_speed
   elseif game.mouse_last_y <  my and love.mouse.isDown("l") and game.give_direction == "Scrolling" then
   	game.draw_y = game.draw_y+game.scroll_speed
   end
   if love.keyboard.isDown("up") then
   	game.draw_y = game.draw_y+game.scroll_speed
   elseif love.keyboard.isDown("down") then
   	game.draw_y = game.draw_y-game.scroll_speed
   elseif love.keyboard.isDown("left") then
   	game.draw_x = game.draw_x+game.scroll_speed
   elseif love.keyboard.isDown("right") then
   	game.draw_x = game.draw_x-game.scroll_speed
   end
end

function update_run_daytimer()
	if game.day_time < 24000 then
		game.day_time = game.day_time+1
		if math.random(1,240) == 1 then
			love.audio.play(sound_light_breeze)
		end
		--kingdom_inventory.villagers = table.getn(game_v
		if game.day_time == 12000 then
			villagers_eat_food(table.getn(game_villagers))
		elseif game.day_time == 11000 then
			week_update_map()
		elseif game.day_time == 21000 then
			villagers_seek_shelter(table.getn(game_villagers))
		end
	else -- reset timer
		game.day_time = 0
		game.day_count = game.day_count+1
	end
end
function update_job_que() -- new code, not implented the "job que" will allow for multiple jobs
	for i,v in ipairs(game_job_que) do
		if game_job_que[i].game_directives.timer > 0 then
			game_job_que[i].game_directives.timer = game_job_que[i].game_directives.timer -1
		else
			--game_job_que[i].game_directives.timer
			table.remove(game_job_que[i])
		end
	end
end
function update_directives()
	local successful = math.random(1,100)
	--game.give_direction = "Research Economy"
	--you finished researching
	--game.research_timer = game.research_timer -1
	--research_topics = { agriculture = 0, economy = 0, culture = 0, security = 0, industry = 0}
	if game.research_timer <= 0 then
		game.research_timer = 0
		if game_directives.research_type == "Research economy" then
			game_directives.research_type = "None"
			research_topics.economy = research_topics.economy+1 --level up econ
			game.event_text = "You have reached economy Level "..research_topics.economy.."!"
			if research_topics.economy == 1 then
				game.event_text2 = "You have unlocked the Trade post."
				game.message_box_icon = 114
			end
			game.message_box_timer = game.message_box_timer+ 200
		elseif game_directives.research_type == "Research security" then
			game_directives.research_type = "None"
			research_topics.security = research_topics.security+1 --level up econ
			game.event_text = "You have reached security Level "..research_topics.security.."!"
			if research_topics.security == 1 then
				game.event_text2 = "You have unlocked the sheriff's office."
				game.message_box_icon = 115
			end
			game.message_box_timer = game.message_box_timer+ 200
		elseif game_directives.research_type == "Research agriculture" then
			game_directives.research_type = "None"
			research_topics.agriculture = research_topics.agriculture+1 --level up econ
			game.event_text = "You have reached agriculture Level "..research_topics.agriculture.."!"
			game.message_box_timer = game.message_box_timer+ 100
		elseif game_directives.research_type == "Research civics" then
			game_directives.research_type = "None"
			research_topics.civics = research_topics.civics+1 --level up econ
			game.event_text = "You have reached civics Level "..research_topics.civics.."!"
			game.message_box_timer = game.message_box_timer+ 100
		elseif game_directives.research_type == "Research industry" then
			game_directives.research_type = "None"
			research_topics.industry = research_topics.industry+1 --level up econ
			game.event_text = "You have reached industry Level "..research_topics.industry.."!"
			if research_topics.industry == 1 then
				game.event_text2 = "You have unlocked the fishing hut"
				game.message_box_icon = 22
			end
			game.message_box_timer = game.message_box_timer+ 200
		end
	else
		game.research_timer = game.research_timer - 1 - kingdom_inventory.dark_elves
	end
	if game_directives.timer > 0 then
		game_directives.timer = game_directives.timer -1
		if successful == 1 then
			if game_directives.job_type == "Cut trees" then
				kingdom_inventory.wood = kingdom_inventory.wood+1
				bonus = math.random(1,100)
				if bonus == 1 then
					kingdom_inventory.cherries = kingdom_inventory.cherries+1
				end
			elseif game_directives.job_type == "Cut sakura" then
				kingdom_inventory.sakura = kingdom_inventory.sakura+1
				bonus = math.random(1,100)
				if bonus == 1 then
					kingdom_inventory.cherries = kingdom_inventory.cherries+1
				end
			elseif game_directives.job_type == "Cut bamboo" then
				kingdom_inventory.bamboo = kingdom_inventory.bamboo+1
				bonus = math.random(1,100)
				if bonus == 1 then
					kingdom_inventory.cherries = kingdom_inventory.cherries+1
				end
			elseif game_directives.job_type == "Gather Food" then
				kingdom_inventory.carrots = kingdom_inventory.carrots+1
			elseif game_directives.job_type == "Dig hole" then
				kingdom_inventory.rocks = kingdom_inventory.rocks+1
			elseif game_directives.job_type == "Fishing" then
				kingdom_inventory.fish = kingdom_inventory.fish+1
			end--endif
		elseif successfull == 2 then
			if game_directives.job_type == "Gather Food" then
				kingdom_inventory.mushrooms = kingdom_inventory.mushrooms+1
			elseif game_directives.job_type == "Dig hole" then
				kingdom_inventory.carrots = kingdom_inventory.carrots+1
			end
		end
	else --if game_directives.timer > 0 then Building Complete
		if game_directives.job_type == "Build house" then
			if game.house_to_build == 51 then 
				kingdom_inventory.wood = kingdom_inventory.wood -15
      		kingdom_inventory.rocks = kingdom_inventory.rocks -15
				kingdom_inventory.schools = kingdom_inventory.schools+1
			elseif game.house_to_build == 52 then
				kingdom_inventory.wood = kingdom_inventory.wood -8
				kingdom_inventory.barns = kingdom_inventory.barns+1 
			elseif game.house_to_build == 65 then
				kingdom_inventory.sakura = kingdom_inventory.sakura -8
				kingdom_inventory.barns = kingdom_inventory.barns+1 
			elseif game.house_to_build == 53 then 
				kingdom_inventory.graveyards = kingdom_inventory.graveyards+1 
			elseif game.house_to_build == 27 then
				if game.biome == "japan" then
					kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
				elseif game.biome == "forest" then
					kingdom_inventory.wood = kingdom_inventory.wood -5
				end
      		kingdom_inventory.rocks = kingdom_inventory.rocks -5
				kingdom_inventory.mine = kingdom_inventory.mine +1
			elseif game.house_to_build >= 61 and game.house_to_build <= 64 then
				kingdom_inventory.sakura = kingdom_inventory.sakura -5
      		kingdom_inventory.rocks = kingdom_inventory.bamboo -5
				kingdom_inventory.homes = kingdom_inventory.homes+1
				update_villager_assign_house(game_directives.location_x, game_directives.location_y)
			elseif game.house_to_build == 67 then
				if game.biome == "japan" then
					kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
				elseif game.biome == "forest" then
					kingdom_inventory.wood = kingdom_inventory.wood -5
				end
				kingdom_inventory.tradepost = kingdom_inventory.tradepost+1
			elseif game.house_to_build == 68 then
				kingdom_inventory.rocls = kingdom_inventory.rocks -35
				kingdom_inventory.sheriff = kingdom_inventory.sheriff+1
			elseif game.house_to_build == 70 then
				if game.biome == "japan" then
					kingdom_inventory.bamboo = kingdom_inventory.bamboo -5
				elseif game.biome == "forest" then
					kingdom_inventory.wood = kingdom_inventory.wood -5
				end
				kingdom_inventory.fishinghut = kingdom_inventory.fishinghut+1
			elseif game.house_to_build >= 23 and game.house_to_build <= 26 then 
				kingdom_inventory.wood = kingdom_inventory.wood -5
      		kingdom_inventory.rocks = kingdom_inventory.rocks -5
				kingdom_inventory.homes = kingdom_inventory.homes+1
				update_villager_assign_house(game_directives.location_x, game_directives.location_y)
			end
			game_map[game_directives.location_y][game_directives.location_x] = game.house_to_build
		elseif game_directives.job_type == "Build bridge" then  --GARDEN
			kingdom_inventory.wood = kingdom_inventory.wood -5
			game_map[game_directives.location_y][game_directives.location_x] = game.house_to_build
		elseif game_directives.job_type == "Make garden" then  --GARDEN
			game_map[game_directives.location_y][game_directives.location_x] = 42 
			kingdom_inventory.farmplot = kingdom_inventory.farmplot+1
		elseif game_directives.job_type == "Make bonfire" then
			game_map[game_directives.location_y][game_directives.location_x] = 47
			game_fire_map[game_directives.location_y][game_directives.location_x] = 1
			kingdom_inventory.bonfire = kingdom_inventory.bonfire+1
		elseif game_directives.job_type == "Build road" then
			--change the map ERROR HERE! game.house_to_build is 0?
			game_map[game_directives.location_y][game_directives.location_x] = game.road_to_build --math.random(24,27)
		elseif game_directives.job_type == "Dig hole" then
			game_map[game_directives.location_y][game_directives.location_x] = game.hole_tile --math.random(24,27)
			instant_update_map()
		elseif game_directives.job_type == "Cut trees" then
			--change the map
			game_map[game_directives.location_y][game_directives.location_x] = math.random(1,2)
		elseif game_directives.job_type == "Cut bamboo" or game_directives.job_type == "Cut sakura"  then
			game_map[game_directives.location_y][game_directives.location_x] = math.random(55,56) --change the map
		end
		game_directives.job_type = "None"
		game_directives.active = 0
		game_directives.location_x = 0
		game_directives.location_y = 0
	end--endif
end--end function update_directives

function update_villager_killedby_werewolf(i, j)
	if villager_touched(i, j) == 1 and i.villager_type == "werewolf" and is_night()==1 then
		if i.villager_type == "werewolf" and j.villager_type == "werewolf" then
			i.alive = 1
			i.alive = 1
		elseif i.villager_type == "werewolf" and j.villager_type ~= "werewolf" then
			if j.alive == 1 then
				j.alive = 0
				if j.sex == 0 then
					game.event_text = "You hear a blood curtling scream..."..j.name.."!"
					j.died_x = j.x
					j.died_y = j.y
					kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
				else
					game.event_text = "You hear a horrible scream..."..j.name.."!"
					kingdom_inventory.unrest = kingdom_inventory.unrest+5
				end
			end --game_villagers[j].alive == 1 then
			game.message_box_timer = 300
		end --if game_villagers[i].villager_type == "werewolf" and game_villagers[j].villager_type == "werewolf" then
	end--end if villager_touched(game_villagers[i], game_villagers[j]) 
end

function update_villager_talking(i)
	if game_villagers[i].villager_type == "werewolf" and is_night() == 1 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_werewolf))
	elseif kingdom_inventory.unrest < 10 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_happy))
	elseif kingdom_inventory.unrest < 20 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_happy))
	elseif kingdom_inventory.unrest < 30 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_ok))
	elseif kingdom_inventory.unrest < 40 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_grumbling))
	elseif kingdom_inventory.unrest < 50 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_angry))
	elseif kingdom_inventory.unrest < 69 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_angry))
	elseif kingdom_inventory.unrest >= 70 then 
		game_villagers[i].speak = math.random(1,table.getn(talk_topics_riot))	
	end
	game_villagers[i].talk_timer = 1000
end
--TODO: Here.
function update_villager_new_destination(i, dt, custom_speed)
	--if i.x < i.dx
	if i.x < i.dx then
		i.x = i.x + (game.actor_speed+custom_speed)*dt
		if i.x > i.dx then 
			i.x = i.dx 
		end
	elseif i.x > i.dx then 
		i.x = i.x - (game.actor_speed+custom_speed)*dt
		if i.x < i.dx then 
			i.x = i.dx 
		end
	end
	if i.y < i.dy then 
		i.y = i.y + (game.actor_speed+custom_speed)*dt
		if i.y > i.dy then 
			i.y = i.dy 
		end
	elseif i.y > i.dy then 
		i.y = i.y - (game.actor_speed+custom_speed)*dt
		if i.y < i.dy then 
			i.y = i.dy 
		end
	else
		i.job = 0 
	end
end

function update_villager_jobs(dt)
------- Now loop through villagers
	for i, v in ipairs(game_villagers) do --loop through villagers
		for j, w in ipairs(game_villagers) do --loop through villagers
			update_villager_killedby_werewolf(game_villagers[i], game_villagers[j])--- WEREWOLF COLLISION
			-- GHOSTS !-------------------------------------
			if game_villagers[i].alive == 0 and game_villagers[i].job == 0 and kingdom_inventory.graveyards < 0 and is_night() == 1 then
				game_villagers[i].job = math.random(1, 1000) --ghosts!
				if game_villagers[i].job < 10 then -- movment
					game_villagers[i].dx = game_villagers[i].dx + math.random(-30,30)
					game_villagers[i].dy = game_villagers[i].dy + math.random(-30,30)
				end
			-- The LIVING!-------------------------------------
			elseif game_villagers[i].job == 0 and game_villagers[i].alive == 1 then -- The living!
				game_villagers[i].job = math.random(1, 1000)
				if game_villagers[i].job < 10 then -- movment
					if game_directives.active == 1 then --job active BUGGED CODE?
						game_villagers[i].dx = game_villagers[i].dx + math.random(-30,30) --temp workaround
						game_villagers[i].dy = game_villagers[i].dy + math.random(-30,30)
					elseif game.day_time >= 21000 then --Time based!
						update_villager_gohome(game_villagers[i])
					else
						game_villagers[i].dx = game_villagers[i].dx + math.random(-30,30)
						game_villagers[i].dy = game_villagers[i].dy + math.random(-30,30)
					end--endif		
				elseif game_villagers[i].job == 50 and game_villagers[i].alive == 1 then -- talk!
					update_villager_talking(i)
				else
					if game_villagers[i].talk_timer == 0 then
						game_villagers[i].speak = 0
					end--endif
				end--endif game_villagers[i].job < 10 then -- movment
				if game_villagers[i].talk_timer > 0 then
					game_villagers[i].talk_timer = game_villagers[i].talk_timer - 1
				end --game_villagers[i].talk_timer > 0 then
			end --game_villagers[i].job == 0 and game_villagers[i].alive == 1 then -- The living!
		if game_villagers[i].alive == 0 then 
			game_villagers[i].talk_timer = 0 -- stop dead villagers from talking 
		end -- endif
		update_villager_new_destination(game_villagers[i], dt, 0) --why are they moving so fast?	
		end-- for j, w in ipairs(game_villagers) do
	end--for i, v in ipairs(game_villagers) do
end

function draw_game_ui()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(game_icons[107], 0, 0)
	love.graphics.print(game.printx.."X"..game.printy, 10, font_row_1)
	if kingdom_inventory.unrest < 10 then vunrest = "very happy"
		love.graphics.setColor(255,255,255,255)
	elseif kingdom_inventory.unrest < 20 then 
		vunrest = "happy"
	elseif kingdom_inventory.unrest < 30 then 
		vunrest = "ok"
		love.graphics.setColor(255, 255, 0, 255)
	elseif kingdom_inventory.unrest < 40 then 
		vunrest = "grumbling"
	elseif kingdom_inventory.unrest < 50 then 
		vunrest = "angry"
		love.graphics.setColor(180, 0, 0, 255)
	elseif kingdom_inventory.unrest < 69 then 
		vunrest = "enraged!"
		love.graphics.setColor(255, 0, 0, 255)
	elseif kingdom_inventory.unrest >= 70 then 
		love.graphics.setColor(255, 0, 0, 255) 
		vunrest = "rioting!" 	
	end--end if kingdom_inventory.unrest < 10 then vunrest
	love.graphics.print("Population: "..table.getn(game_villagers).."/"..kingdom_inventory.families.."   Village Happiness: "..vunrest.."(-"..kingdom_inventory.unrest..")", 10, font_row_2) 
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Mines: "..kingdom_inventory.mine.."  Farms: "..kingdom_inventory.farmplot.."  Homes: "
		..kingdom_inventory.homes, 10, font_row_3)
	if kingdom_inventory.hunger > 0 then  love.graphics.setColor(255, 255, 0, 255)
		love.graphics.print("Villagers went hungry today!("..kingdom_inventory.hunger..")", 200, font_row_3)  love.graphics.setColor(255, 255,255, 255)
	end
	if kingdom_inventory.homeless > 0 then
		love.graphics.print(kingdom_inventory.homeless.." villagers are homeless!", 400, font_row_3)
	end
	love.graphics.print(game.give_direction, 100, font_row_1)
	love.graphics.print(game_directives.job_type.."("..game_directives.timer..")", 250, font_row_1)
	love.graphics.print("Time:"..math.floor(game.day_time/1000).." hrs", 400, font_row_1 )
	love.graphics.print("Day "..game.day_count, 550, font_row_1 )
	
	love.graphics.draw(game_icons[104], game.screen_width -16, 10)
	love.graphics.draw(game_icons[105], game.screen_width -32, 10)
	love.graphics.draw(game_icons[106], game.screen_width -48, 10)
	
	if game.message_box_timer > 0 then
		display_game_event(game.event_text)
	end
	if game.game_paused == 1 then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.setFont( big_font )
		love.graphics.print("GAME PAUSED", 350, 300)
	end
end

function draw_inventory_icon_xy( item, item_name, item_xcount, icon_num, x, y)
	if item > 0 then
		love.graphics.draw(game_icons[icon_num], x, y)
		if item_xcount > 0 then
			love.graphics.print(item_name.."("..item_xcount..")", x, y)
		else
			love.graphics.print(item_name.."("..item..")", x, y)
		end
		item_lister = item_lister+1
		return item_lister
	else
		return item_lister
	end
end

function draw_inventory_icons()
	item_lister = 1
	if kingdom_inventory.barns < 1 then
		item_lister = draw_inventory_icon_xy( kingdom_inventory.carrots,   "carrots", 0, 34, game.screen_width-64, 64*item_lister, item_lister ) 
		item_lister = draw_inventory_icon_xy( kingdom_inventory.mushrooms, "shrooms", 0, 61, game.screen_width-64, 64*item_lister, item_lister )
		item_lister = draw_inventory_icon_xy( kingdom_inventory.mushrooms, "fish",    0, game.fish_icon, game.screen_width-64, 64*item_lister, item_lister ) 
	else
		item_lister = draw_inventory_icon_xy( kingdom_inventory.barns, "Food",
				kingdom_inventory.carrots+kingdom_inventory.mushrooms+kingdom_inventory.fish+kingdom_inventory.grain+kingdom_inventory.cherries,
				103, game.screen_width-64, 64*item_lister, item_lister)
	end
	item_lister = draw_inventory_icon_xy( kingdom_inventory.wood, "wood", 0, 55, game.screen_width-64, 64*item_lister, item_lister ) 
	item_lister = draw_inventory_icon_xy( kingdom_inventory.sakura, "sakura", 0, 108, game.screen_width-64, 64*item_lister, item_lister )
	item_lister = draw_inventory_icon_xy( kingdom_inventory.bamboo, "bamboo", 0, 109, game.screen_width-64, 64*item_lister, item_lister )
	item_lister = draw_inventory_icon_xy( kingdom_inventory.rocks, "stone", 0, 23, game.screen_width-64, 64*item_lister, item_lister )	
	item_lister = draw_inventory_icon_xy( kingdom_inventory.grain, "grain", 0, 51, game.screen_width-64, 64*item_lister, item_lister )
	item_lister = draw_inventory_icon_xy( kingdom_inventory.grain, "cherry", 0, 36, game.screen_width-64, 64*item_lister, item_lister )
end--draw_inventory_icons()


function draw_research_icons()
	if get_kingdom_researchable() == 1 then
		love.graphics.draw(game_icons[44],  0, 64*5) --research!
		if game.research_timer == 0 then
			love.graphics.print("Research", 5, 64*5  )
		else
			love.graphics.print("Researching".."("..game.research_timer..")", 5, 64*5  )
		end
	end
	if game.give_direction == "Research" then
		local ybutton_level = 64*5+40
		love.graphics.draw(game_icons[110],  0+64, 64*5) --research economy!
		love.graphics.print("Economy", 5+64, 64*5  )
		love.graphics.print("Lv "..research_topics.economy, 64+5, ybutton_level  )
		love.graphics.draw(game_icons[111],  64*2, 64*5) --research Security!
		love.graphics.print("Security", 5+64+64, 64*5  )
		love.graphics.print("Lv "..research_topics.security, 64+64+5, ybutton_level  )
		love.graphics.draw(game_icons[112],  64*3, 64*5) --research Agriculture!
		love.graphics.print("Agriculture", 64*3+5, 64*5  )
		love.graphics.print("Lv "..research_topics.agriculture, 64+64+64+5, ybutton_level  )
		love.graphics.draw(game_icons[113], 64*4, 64*5) --research civics!		
		love.graphics.print("Civics", 64*4+5, 64*5  )
		love.graphics.print("Lv "..research_topics.agriculture, 64*4+5, ybutton_level  ) 
		love.graphics.draw(game_icons[113], 64*5, 64*5) --research industry!		
		love.graphics.print("Industry", 64*5+5, 64*5  )
		love.graphics.print("Lv "..research_topics.agriculture, 64*5+5, ybutton_level  ) 
	end
end
function draw_night(y, x)  --code for night and fire glow
	if game_fire_map[y][x] == 0 then
		love.graphics.setColor(50,50,50,255)
	end
	if x+1 < game.tilecount and game_fire_map[y][x+1] == 1 then
		love.graphics.setColor(200,200,200,255)
	elseif  x-1 > 0         and game_fire_map[y][x-1] == 1  then
		love.graphics.setColor(200,200,200,255)
	elseif  y+1 < game.tilecount and game_fire_map[y+1][x] == 1  then
		love.graphics.setColor(200,200,200,255)
	elseif y-1 > 0          and game_fire_map[y-1][x] == 1 then
		love.graphics.setColor(200,200,200,255)
	elseif y-1 > 0 and x-1 >0 and game_fire_map[y-1][x-1] == 1 then
		love.graphics.setColor(200,200,200,255)
	elseif y+1 < game.tilecount and x+1 < game.tilecount and game_fire_map[y+1][x+1] == 1  then
		love.graphics.setColor(200,200,200,255)
	elseif y+1 < game.tilecount and x-1 > 0 and game_fire_map[y+1][x-1] == 1  then
		love.graphics.setColor(200,200,200,255)
	elseif y-1 > 0 and x+1 < game.tilecount and game_fire_map[y-1][x+1] == 1  then
		love.graphics.setColor(200,200,200,255)
	elseif x+2 < game.tilecount and game_fire_map[y][x+2] == 1 then
		love.graphics.setColor(150,150,150,255)
	elseif  x-2 > 0         and game_fire_map[y][x-2] == 1  then
		love.graphics.setColor(150,150,150,255)
	elseif  y+2 < game.tilecount and game_fire_map[y+2][x] == 1  then
		love.graphics.setColor(150,150,150,255)
	elseif y-2 > 0          and game_fire_map[y-2][x] == 1 then
		love.graphics.setColor(150,150,150,255)
	elseif x+3 < game.tilecount and game_fire_map[y][x+3] == 1 then
		love.graphics.setColor(100,100,100,255)
	elseif  x-3 > 0         and game_fire_map[y][x-3] == 1  then
		love.graphics.setColor(150,150,100,255)
	elseif  y+3 < game.tilecount and game_fire_map[y+3][x] == 1  then
		love.graphics.setColor(100,100,100,255)
	elseif y-3 > 0          and game_fire_map[y-3][x] == 1 then
		love.graphics.setColor(100,100,100,255)		
	elseif game_fire_map[y][x] == 1 then
		love.graphics.setColor(255,255,255,255)
	end
end
function draw_villagers()
	for i,v in ipairs(game_villagers) do
		if game_villagers[i].alive == 1 then
			dead_flag = 0
		else
			dead_flag = 1
		end
		local blitx = 0
		local blity = 0
		if game_villagers[i].alive == 0 then
			blit_x = game_villagers[i].died_x+game.draw_x
			blit_y = game_villagers[i].died_y+game.draw_y
		else
			blit_x = game_villagers[i].x+game.draw_x
			blit_y = game_villagers[i].y+game.draw_y
		end
		if game_villagers[i].alive == 0 and is_night() and kingdom_inventory.graveyards < 0 then
			local ghost_flip = random(1,5)
			if ghost_flip == 1 then
				love.graphics.draw(game_sprites[13], game_villagers[i].x+game.draw_x, game_villagers[i].y)
			else
				love.graphics.draw(game_sprites[14], game_villagers[i].x+game.draw_x, game_villagers[i].y)
			end
		end
		if game_villagers[i].villager_type == "dark elf" then
			love.graphics.draw(game_sprites[7+dead_flag], blit_x, blit_y)
		elseif game_villagers[i].villager_type == "werewolf" and is_night() == 1 then
			love.graphics.draw(game_sprites[11+dead_flag], blit_x, blit_y)
		elseif game_villagers[i].villager_type == "bandit" then
			love.graphics.draw(game_sprites[9+dead_flag], blit_x, blit_y)
		elseif game_villagers[i].villager_type == "holyman" then
			love.graphics.draw(game_sprites[15+dead_flag], blit_x, blit_y)
		elseif game_villagers[i].age < 18 then
			love.graphics.draw(game_sprites[5+dead_flag], blit_x, blit_y)
		elseif game_villagers[i].sex == 0 then
			love.graphics.draw(game_sprites[3+dead_flag], blit_x, blit_y)
		else
			love.graphics.draw(game_sprites[1+dead_flag], blit_x, blit_y)
		end
		if game_villagers[i].talk_timer > 0 then
			--Need to setup this.
			love.graphics.setColor(255,255,255,255)
			if game_villagers[i].villager_type == "werewolf" and is_night() == 1 then 
				love.graphics.printf("???"..": "..talk_topics_werewolf[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")
					--game_villagers[i].speak = math.random(1,table.getn(talk_topics_werewolf))
			elseif game_villagers[i].villager_type == "holyman" then
				love.graphics.printf("Holyman "..game_villagers[i].name..": "..talk_topics_holyman[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 400, "left")
			elseif kingdom_inventory.unrest < 10 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_happy[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")
			elseif kingdom_inventory.unrest < 20 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_happy[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")
			elseif kingdom_inventory.unrest < 30 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_ok[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")--bad argument error
			elseif kingdom_inventory.unrest < 40 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_grumbling[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")
			elseif kingdom_inventory.unrest < 50 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_angry[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20 -20, 250, "left")
			elseif kingdom_inventory.unrest < 69 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_angry[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")
			elseif kingdom_inventory.unrest >= 70 then love.graphics.printf(game_villagers[i].name..": "..talk_topics_riot[game_villagers[i].speak], game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20, 250, "left")	end
			--love.graphics.printf(talk_topics_happy[game_villagers[i].speak], game_villagers[i].x- 10, game_villagers[i].y -20, 150, "left")
		end--endif
	end--endfor
end

function draw_select_house_to_build()
	if game.give_direction == "Select house to build" then
		local xi = 1
		local row_2 = 64*4
		local row_2_xi = 1
		if game.biome == "japan" then
			love.graphics.draw(game_tiles[61],  64*xi, 54*3) xi=xi+1
			love.graphics.draw(game_tiles[62],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[63],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[64],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[27],  64*xi, 54*3)
			love.graphics.print("Mine", 64*xi+10, 54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[51],  64*xi, 54*3)
			love.graphics.print("School",64*xi+10,54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[65],  64*xi, 54*3)
			love.graphics.print("Barn",64*xi+10,54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[53],  64*xi, 54*3)
			love.graphics.print("Graveyard",64*xi+10,54*3 + 48)xi=xi+1
			--Advanced structures.  These structures have a fixed location on the icon
			--list in order to avoid problems on clicking
			if research_topics.economy >= 1 then
				love.graphics.draw(game_tiles[67],  64*row_2_xi, row_2)
				love.graphics.print("Tradepost",64*row_2_xi, row_2+64) row_2_xi=row_2_xi+1
			else
				row_2_xi=row_2_xi+1 --advance anyways so we know what we are clicking on
			end
			if research_topics.security >= 1 then
				love.graphics.draw(game_tiles[68],  64*row_2_xi, row_2)
				love.graphics.print("Shariff Office",64*row_2_xi, row_2+64) row_2_xi=row_2_xi+1
			else
				row_2_xi=row_2_xi+1 --advance anyways so we know what we are clicking on
			end
			row_2_xi=row_2_xi+1 -- agriculture
			row_2_xi=row_2_xi+1 -- civics
			if research_topics.industry >= 1 then
				love.graphics.draw(game_tiles[70],  64*row_2_xi, row_2)
				love.graphics.print("Fishing hut",64*row_2_xi, row_2+64) row_2_xi=row_2_xi+1
			else
				row_2_xi=row_2_xi+1 --advance anyways so we know what we are clicking on
			end
			
		else
			love.graphics.draw(game_tiles[23],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[24],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[25],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[26],  64*xi, 54*3)xi=xi+1
			love.graphics.draw(game_tiles[27],  64*xi, 54*3)
			love.graphics.print("Mine", 64*xi+10, 54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[51],  64*xi, 54*3)
			love.graphics.print("School",64*xi+10, 54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[52],  64*xi, 54*3)
			love.graphics.print("Barn",64*xi+10,54*3 + 48)xi=xi+1
			love.graphics.draw(game_tiles[53],  64*xi, 54*3)
			love.graphics.print("Graveyard",64*xi+10,54*3 + 48)xi=xi+1
			
			if research_topics.economy >= 1 then
				love.graphics.draw(game_tiles[67],  64*row_2_xi, row_2)
				love.graphics.print("Tradepost",64*row_2_xi, row_2+64)row_2_xi=row_2_xi+1
			end
			if research_topics.security >= 1 then
				love.graphics.draw(game_tiles[68],  64*row_2_xi, row_2)
				love.graphics.print("Sheriff Office",64*row_2_xi, row_2+64)row_2_xi=row_2_xi+1
			end
			row_2_xi=row_2_xi+1
			row_2_xi=row_2_xi+1
			row_2_xi=row_2_xi+1
			row_2_xi=row_2_xi+1
			if research_topics.industry >= 1 then
				love.graphics.draw(game_tiles[70],  64*row_2_xi, row_2)
				love.graphics.print("Fishing hut",64*row_2_xi, row_2+64)row_2_xi=row_2_xi+1
			end
		end
	end
end

function mouse_left_icons_pressed(x, y, button)
	
   return game.givedirection
end
---------------------------------------
-- the love.functions!
---------------------------------------
function love.load()
	local tile_dir = "data/images/"
	local icon_dir = "data/icons/"
	local sprite_dir = "data/sprites/"
	local tile_files = nil
	local icon_files = nil
	local sprite_files = nil
	if version == "0.9.0" then
		tile_files = love.filesystem.getDirectoryItems(tile_dir)
		icon_files = love.filesystem.getDirectoryItems(icon_dir)
		sprite_files = love.filesystem.getDirectoryItems(sprite_dir)
	else --lower than 0.9.0
		tile_files = love.filesystem.enumerate(tile_dir)
		icon_files = love.filesystem.enumerate(icon_dir)
		sprite_files = love.filesystem.enumerate(sprite_dir)
	end
	for k, file in ipairs(tile_files) do
		table.insert(game_tiles, love.graphics.newImage(tile_dir..file) )
	end--end44
	
	for k, file in ipairs(icon_files) do
		table.insert(game_icons, love.graphics.newImage(icon_dir..file) )
	end
	
	for k, file in ipairs(sprite_files) do
		table.insert(game_sprites, love.graphics.newImage(sprite_dir..file))
	end
	
	--if save file exists then
	--load save file
	--else
	local biome_random = math.random(1,2)
	if biome_random == 2 then game.biome = "japan" end --it was set to forest before
	create_new_scene(file)
	--end
	if fullscreen_hack == "yes" then
		if version == "0.8.0" then 
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

function get_kingdom_researchable()
	if kingdom_inventory.schools > 0 or kingdom_inventory.dark_elves > 0 then
		return 1
	else
		return 0
	end
end
---------------------------------------
function love.keypressed(key)
   if key == "escape" then
   	love_crude_save() --save/quit autosave feature
      love.event.quit()
   elseif key == "f2" then
   	go_fullscreen()
   elseif key == "s" then
   	love_crude_save() -- crude saving
   elseif key == "c" then
   	game.draw_x = 0--center the field of view
   	game.draw_y = 0
   elseif key == "l" then
   	love_crude_load()
   elseif key == " " then
   	if game.game_paused == 0 then
   		game.game_paused = 1
   	else
   		game.game_paused = 0
   	end   	
   end
end

function love.mousereleased(x, y, button)
   if button == "l" then
      if game.give_direction == "Scrolling" then
      	game.give_direction = "None"
      end
   end
end

function love.mousepressed(x, y, button)
   if button == "l" then
      game.printx = x		--game.printx = 0 -- 0  -62
      game.printy = y      --game.printy = 0 -- 536-600 --0, 64
      
      if x >= game.screen_width -48 and x <= game.screen_width -32 and y >= 10 and y <= 10+16 then
      	love_crude_load()
      end
      if x >= game.screen_width -32 and x <= game.screen_width -16 and y >= 10 and y <= 10+16 then
      	love.event.quit()
      end
      if x >= game.screen_width -16 and x <= game.screen_width and y >= 10 and y <= 10+16 then
      	love_crude_save() --save/quit autosave feature
      	love.event.quit()
      end
      
      --mouse_left_icons_pressed(x, y, button)
      --game.give_direction = mouse_left_icons_pressed(x, y, button)
      function mouse_clicked_in64(x, y, icon_x, icon_y)
      	if y >= icon_y and y <= icon_y +64 and x >= icon_x and x <= icon_x+64 then
      		return 1
      	else 
      	 return 0
      	end
      end
      if mouse_clicked_in64(x, y, 0, 64*1) == 1 and game.give_direction == "None" then
   		game.give_direction = "Select job" -- if select job, check if job buttons pushed.
   	elseif mouse_clicked_in64(x, y, 0, 64*2) == 1 and game.give_direction == "None" then
     		game.give_direction = "Gather Food"
     	elseif mouse_clicked_in64(x, y, 0, 64*3) == 1 and game.give_direction == "None" then
     		game.give_direction = "Select house to build" --"Build house"
     	elseif mouse_clicked_in64(x, y, 0, 64*4) == 1 and game.give_direction == "None" then
     		game.give_direction = "Select road to build" 
     	elseif mouse_clicked_in64(x, y, 0, 64*5) == 1 and game.give_direction == "None" then
     		if get_kingdom_researchable() == 1 then
     			game.give_direction = "Research" -- check for researchables
     		end
     	elseif game.give_direction == "Research" then
     		if x >= 0 and x <= 64*1 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     			game.give_direction = "None"
     	elseif x >= 64*1 and x <= 64*2 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
    		game.give_direction = "Research economy"
     		game_directives.research_type = "Research economy"
     		game.research_timer = 5000
     	elseif x >= 64*2 and x <= 64*3 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research security"
     		game_directives.research_type = "Research security"
     		game.research_timer = 5000
     	elseif x >= 64*3 and x <= 64*4 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research agriculture"
     		game_directives.research_type = "Research agriculture"
     		game.research_timer = 5000
     	elseif x >= 64*4 and x <= 64*5 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research civics"
     		game_directives.research_type = "Research civics"
     		game.research_timer = 5000
     	elseif x >= 64*5 and x <= 64*6 and y >=64*5 and y <= 64*5+64 and game.give_direction == "Research" then
     		game.give_direction = "Research industry"
     		game_directives.research_type = "Research industry"
     		game.research_timer = 5000
     	end
      elseif game.give_direction == "Gather Food" then
      	if game.tile_selected_y > 1 and game.tile_selected_x > 1 and game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      		game_directives.job_type = "Fishing"
      	else
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      	end-- if game.tile_selected_y > 1
      elseif game.give_direction == "Cut where?" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] >= 3 and game_map[game.tile_selected_y][game.tile_selected_x] <= 20 then
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Cut trees"
      		game.give_direction = "None"
      	elseif game_map[game.tile_selected_y][game.tile_selected_x] == 57 or game_map[game.tile_selected_y][game.tile_selected_x] == 58 then
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Cut sakura"
      		game.give_direction = "None"
      	elseif game_map[game.tile_selected_y][game.tile_selected_x] == 59 or game_map[game.tile_selected_y][game.tile_selected_x] == 60 then
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Cut bamboo"
      		game.give_direction = "None"
      	else
      		game_directives.job_type = "No Trees here" --error you cant find any wood here.
      		game_directives.active = 0
      		game.give_direction = "No Trees here"
      	end -- game_map[game.tile_selected_y][game.tile_selected_x] 
      elseif game.give_direction == "Plow where?" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      		game_directives.job_type = "None."
      		game_directives.active = 0
      		game.give_direction = "Clear this area first"
      	else
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Make garden"
      		game.give_direction = "None"
      	end -- game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      elseif game.give_direction == "Make fire where?" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      		game_directives.job_type = "None."
      		game_directives.active = 0
      		game.give_direction = "Clear this area first"
      	else
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Make bonfire"
      		game.give_direction = "None"
      	end -- game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      elseif game.give_direction == "Dig where?" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] > 2 and game_map[game.tile_selected_y][game.tile_selected_x] ~= 55 and game_map[game.tile_selected_y][game.tile_selected_x] ~= 56 then
      		game_directives.job_type = "None."
      		game_directives.active = 0
      		game.give_direction = "Clear this area first"
      	else
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = "Dig hole"
      		game.give_direction = "None"
      	end -- if game_map[game.tile_selected_y][game.tile_selected_x] > 2 then
      elseif game.give_direction == "Select job" then
      	if x >= 64*0 and x <= 64*1 and y >=64 and y <= 64+64 then
      		game.give_direction = "None"
      	elseif x >= 64*1 and x <= 64*2 and y >=64 and y <= 64+64 then 
      		game.give_direction = "Cut where?" --pressed axe
      	elseif x >= 64*2 and x <= 64*3 and y >=64 and y <= 64+64 then
      		game.give_direction = "Dig where?" --spressed shovel
      	elseif x >= 64*3 and x <= 64*4 and y >=64 and y <= 64+64 then
      		game.give_direction = "Plow where?" --farming!
      	elseif x >= 64*4 and x <= 64*5 and y >=64 and y <= 64+64 then
      		game.give_direction = "Make fire where?"
      	end --if x >= 64*0 and x <= 64*1 and y >=64 and y <= 64+64 then
      -------------- SELECT HOUSE TO BUILD ------------------------
      elseif game.give_direction == "Select house to build" then
      	for i = 0, 8 do
      		if x >= 64*i and x <= 64*(i+1) and y >=64*3 and y <= 64*3+64 then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			elseif x >= 64*5 and x <= 64*(5+1) and y >=64*3 and y <= 64*3+64 then --mine
      				build_house_directive("Build house", 27, 27)
      			elseif x >= 64*6 and x <= 64*(6+1) and y >=64*3 and y <= 64*3+64 then --school
      				build_house_directive("Build house", 51, 51)
      			elseif x >= 64*7 and x <= 64*(7+1) and y >=64*3 and y <= 64*3+64 then --barn
      				build_house_directive("Build house", 65, 52)
      			elseif x >= 64*8 and x <= 64*(8+1) and y >=64*3 and y <= 64*3+64 then --graveyard
      				build_house_directive("Build house", 53, 53)
      			else
      				build_house_directive("Build house", 60+i, 22+i)
      			end -- if i*64 == 0 then
      		end -- if x >= 64*i and x <= 64*(i+1) and y >=64*3 and y <= 64*3+64 then
      	end -- for i = 0, 7 do
      	--if x >= 64 and x <= 64*(2) and y >=288 and y <= 288+64 then --row 2, if research completed
      	if mouse_clicked_in64(x, y, 64*1, 288) == 1 then
      		if research_topics.economy >= 1 then
      			build_house_directive("Build house", 67, 67)
      		end
      	elseif mouse_clicked_in64(x, y, 64*2, 288) == 1 then
      		if research_topics.security >= 1 then
      			build_house_directive("Build house", 68, 68)
      		end
      	elseif mouse_clicked_in64(x, y, 63*5, 288) == 1 then
      		if research_topics.industry >= 1 then
      			build_house_directive("Build house", 70, 70)
      		end
      	end
      ------------------SELCT ROAD TO BUILD -----------------------
      elseif game.give_direction == "Select road to build" then --28,36
      	for i = 0, 10 do
      		if y >= 64*4 and y <= 64*4+64 and x >= 64*i and x <= 64*(i+1) then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			else
      				game.give_direction = "Build road"
      				game.road_to_build = 27+i --1 or higher because of if
      			end
      		end--endif
      	end --endfor
      	for i = 0, 2 do
      		if y >= 64*5 and y <= 64*5+64 and x >= 64*i and x <= 64*(i+1) then
      			if i*64 == 0 then
      				game.give_direction = "None"
      			else
      				game.give_direction = "Build bridge"
      				game.house_to_build = 20+i
      			end --endif
      		end-- endif
      	end--endfor
      ------------------MAKE GARDEN-----------------------------
      elseif game.give_direction == "Make garden" then --Garden
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
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.house_to_build = 42
      		game.give_direction = "None"
      		love.audio.play(sound_build_house)
      	end
      ------------------MAKE BONFIRE-----------------------------
      elseif game.give_direction == "Make bonfire" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      		game_directives.job_type = "Cant build on water"
      		game_directives.active = 0
      		game.give_direction = "None"
      	elseif kingdom_inventory.wood < 5 then
      		game_directives.job_type = "Not Resources(wood 1)"
      		game_directives.active = 0
      		game.give_direction = "None"
      	else
      		kingdom_inventory.wood = kingdom_inventory.wood -5
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.house_to_build = 47
      		game.give_direction = "None"
      		--love.audio.play(sound_build_house)
      	end
      ----------- PLACE HOUSE ON MAP - CHECK RESOURCES--------------
      elseif game.give_direction == "Build house" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      		game_directives.job_type = "Cant build on water"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Cant build on water"
      		game.message_box_timer = 80
      	elseif game.biome == "forest" and game.house_to_build == 52 and kingdom_inventory.wood < 8 then --barn(forest)
      		game_directives.job_type = "Not Resources(wood 8)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a barn (wood 8)"
      		game.message_box_timer = 80
      	elseif game.biome == "japan" and game.house_to_build == 65 and kingdom_inventory.sakura < 8 then --barn(japan)
      		game_directives.job_type = "Not Resources(sakura 8)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a barn (sakura 8)"
      		game.message_box_timer = 80
      	elseif game.house_to_build == 51 and (kingdom_inventory.wood < 15 or kingdom_inventory.rocks < 15) then --school
      		game_directives.job_type = "Not Resources(wood 15, stone 15)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a school (wood 15, stone 15)"
      		game.message_box_timer = 80
      	elseif game.biome == "japan" and game.house_to_build >= 61 and game.house_to_build <= 64 and (kingdom_inventory.sakura < 5 or kingdom_inventory.bamboo < 5) then --house
      		game_directives.job_type = "Not Resources(sakura 5, bamboo 5)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a house(sakura 5, bamboo 5)"
      		game.message_box_timer = 80
      	elseif game.biome == "japan" and game.house_to_build == 27 and (kingdom_inventory.rocks < 5 or kingdom_inventory.bamboo < 5) then --mine
      		game_directives.job_type = "Not Resources(stone 5, bamboo 5)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a mine(stone 5, bamboo 5)"
      		game.message_box_timer = 80
      	--This is becoming a catchall for everything including mines! eeek!
      	elseif game.biome == "forest" and game.house_to_build >= 23 and game.house_to_build <= 26 and (kingdom_inventory.wood < 5 or kingdom_inventory.rocks < 5) then --house
      		game_directives.job_type = "Not Resources(wood 5, stone 5)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a house(wood 5, stone 5)"
      		game.message_box_timer = 80
      	elseif game.house_to_build == 27 and game_map[game.tile_selected_y][game.tile_selected_x] ~= 37 then --mine
      		game_directives.job_type = "Must build at a dig site"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Must build a mine at a dig site"
      		game.message_box_timer = 80
      	--Advanced buildings
      	elseif game.house_to_build == 67 then
      		if game.biome == "japan" and kingdom_inventory.bamboo < 10 then
      			game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
      		elseif   game.biome == "forrest" and kingdom_inventory.wood < 10 then
      			game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
      		end
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a trade post(bamboo 10 or wood 10)"
      		game.message_box_timer = 80
      	elseif game.house_to_build == 70 then
      		if game.biome == "japan" and kingdom_inventory.bamboo < 10 then
      			game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
      			game.event_text = "Not Resources for a fishing hut(bamboo 10 or wood 10)"
      			game.message_box_timer = 80
      		elseif  game.biome == "forrest" and kingdom_inventory.wood < 10 then
      			game_directives.job_type = "Not Resources(bamboo 10 or wood 10)" --Trade Post
      			game.event_text = "Not Resources for a fishing hut(bamboo 10 or wood 10)"
      			game.message_box_timer = 80
      		elseif tile_near_water( game.tile_selected_y, game.tile_selected_x ) == 0 then
      			game_directives.job_type = "Must build near water."
      			game.event_text = "Must build near water."
      			game.message_box_timer = 80
      			game.event_text = "Must build near water."
      			game.message_box_timer = 80
      		else
      			game_directives.active = 1
      			game_directives.timer = 300
      			game_directives.location_x = game.tile_selected_x
      			game_directives.location_y = game.tile_selected_y
      			game_directives.job_type = game.give_direction
      			game.give_direction = "None"
      			love.audio.play(sound_build_house)
      		end
      		game_directives.active = 0
      		game.give_direction = "None"
      	elseif game.house_to_build == 68 and kingdom_inventory.rocks < 35  then --jail/sheriff office
      		game_directives.job_type = "Not Resources(stone 35)"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not Resources for a Sheriff office (stone 35)"
      		game.message_box_timer = 80
      	elseif game.house_to_build == 27 and game_map[game.tile_selected_y][game.tile_selected_x] == 37 then
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      		love.audio.play(sound_build_house)
      	else
      		game_directives.active = 1
      		game_directives.timer = 300
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      		love.audio.play(sound_build_house)
      	end
      elseif game.give_direction == "Build bridge" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] ~= game.water_tile then
      		game_directives.job_type = "Must build on water"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "You must build bridges on water"
      		game.message_box_timer = 80
      	elseif kingdom_inventory.wood < 5 then
      		game_directives.job_type = "Not enough wood." --stone?
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not enough wood to build a bridge.(5 Wood)"
      		game.message_box_timer = 80
      	else
      		--kingdom_inventory.rocks = kingdom_inventory.wood -1 --stone
      		game_directives.active = 1
      		game_directives.timer = 100
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      	end--if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      elseif game.give_direction == "Build road" then
      	if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      		game_directives.job_type = "Cant build on water"
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "You cannot build roads on water"
      		game.message_box_timer = 80
      	elseif kingdom_inventory.rocks < 1 then
      		game_directives.job_type = "Not enough stone." --stone?
      		game_directives.active = 0
      		game.give_direction = "None"
      		game.event_text = "Not enough stone to build a road.(1 Stone)"
      		game.message_box_timer = 80
      	else
      		kingdom_inventory.rocks = kingdom_inventory.rocks -1 --stone
      		game_directives.active = 1
      		game_directives.timer = 100
      		game_directives.location_x = game.tile_selected_x
      		game_directives.location_y = game.tile_selected_y
      		game_directives.job_type = game.give_direction
      		game.give_direction = "None"
      	end--if game_map[game.tile_selected_y][game.tile_selected_x] == game.water_tile then
      else
      	game.mouse_last_x =  love.mouse.getX()
      	game.mouse_last_y =  love.mouse.getY()
      	game.give_direction = "Scrolling" 
      end--elseif game.give_direction == "Build road" then
   end
end
---------------------------------------
function love.update(dt)
	--lets try some map dragging
   local mx = love.mouse.getX()
   local my = love.mouse.getY()
   --game.give_direction = "Scrolling"
   update_checkscrolling(mx, my)
	if game.game_paused == 0 then
		if game.message_box_timer > 0 then 
			game.message_box_timer = game.message_box_timer -1
		elseif game.message_box_timer == 0 then
			game.event_text2 = "None"
			game.message_box_icon = 9
		end
		mouse_x, mouse_y = love.mouse.getPosition()
		update_run_daytimer() -- run the clock
		update_directives()
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
end -- function()
---------------------------------------
function love.draw()
	game.screen_height = love.graphics.getHeight()
	game.screen_width  = love.graphics.getWidth()
	local xdraw = math.random(1, 20)
	love.graphics.setFont( base_font )
	for y = 1, game.tilecount do
		for x = 1, game.tilecount do
			lx = 300+(y - x) * 32 + 64
			ly = -100+(y + x) * 32 / 2 + 50
			---------- DRAWING TILES ----------------------------------------------
			if is_night() == 1 then
				draw_night(y,x)
			end
			-- function -----  game tiles map table ---- isometric loc
			if game_map[y][x] == game.bridge_tile1 or game_map[y][x] == game.bridge_tile2 then
				if xdraw == 1 then --draw_x, draw_y,
					--love.graphics.draw(game_tiles[54], lx+game.draw_x, ly+game.draw_y)
					love.graphics.draw(game_tiles[game.water_tile], lx+game.draw_x, ly+game.draw_y)
				else
					love.graphics.draw(game_tiles[game.water_tile], lx+game.draw_x, ly+game.draw_y) --draw water first, under bridge
				end
			end

			if game_map[y][x] == 68 or game_map[y][x] == 70 then
				love.graphics.draw(game_tiles[ 32 ], lx+game.draw_x, ly+game.draw_y)
			end
			love.graphics.draw(game_tiles[ game_map[y][x] ], lx+game.draw_x, ly+game.draw_y)
			if research_topics.agriculture > 0 and game_map[y][x] >= 42 and game_map[y][x] <= 46 then
				love.graphics.draw(game_tiles[ 69 ], lx+game.draw_x, ly+game.draw_y)
			end

			if game_fire_map[y][x] == 1 then 
				love.graphics.draw(game_tiles[math.random(48,50)], lx+game.draw_x, ly+game.draw_y)
			end
			if x == game.tile_selected_x and y == game.tile_selected_y then
				love.graphics.draw(game_tiles[game.green_selected], lx+game.draw_x, ly+game.draw_y)
			end --endif
			if x == game_directives.location_x and y == game_directives.location_y then
				love.graphics.draw(game_tiles[game.yellow_selected],lx+game.draw_x, ly+game.draw_y )
			end --endif
		end --endfor x
	end --endfor y
	----------------------------------- END DRAWING TILES
	draw_villagers() -- draw villagers
	--draw wildlife
	for i,v in ipairs(game_wildlife) do
		if game_wildlife[i].alive == 1 then
			dead_flag = 0
		else
			dead_flag = 1
		end
		--default rabbits only
		love.graphics.draw(game_sprites[17], game_wildlife[i].x +game.draw_x, game_wildlife[i].y +game.draw_y )
		--love.graphics.print("("..game_wildlife[i].dx.."x"..game_wildlife[i].dx..")", game_wildlife[i].x +game.draw_x, game_wildlife[i].y +game.draw_y)
	end--endfor
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(game_icons[11], 0, 64) --new labor icon
	love.graphics.draw(game_icons[58], 0, 64*2) --bag, gather food
	love.graphics.print("Gather Food", 5, 64*2  )
	love.graphics.draw(game_icons[2],  0, 64*3) -- build house
	
	draw_select_house_to_build()
	if game.give_direction == "Select job" then
		love.graphics.draw(game_icons[game.axe_icon], 64*1, 64) --axe, cut wood
		love.graphics.draw(game_icons[game.shovel_icon], 64*2, 64*1)
		love.graphics.draw(game_icons[39], 64*3, 64*1)--garden?
		love.graphics.draw(game_icons[102], 64*4, 64*1) --fire placeholder
		love.graphics.print("Cut trees", 5+64, 64  )
		love.graphics.print("Dig hole", 5+64*2, 64 )
		love.graphics.print("Garden", 5+64*3, 64 )
		love.graphics.print("Fire",   5+64*4, 64 )
	else
		love.graphics.print("Labor", 5, 64  )
	end
	love.graphics.print("Build", 5, 64*3  )
	love.graphics.draw(game_icons[101],  0, 64*4) --build roads
	love.graphics.print("Build Roads", 5, 64*4  )
	if game.give_direction == "Select road to build" then
		love.graphics.draw(game_tiles[28],  64*1, 64*3)
		love.graphics.draw(game_tiles[29],  64*2, 64*3)
		love.graphics.draw(game_tiles[30],  64*3, 64*3)
		love.graphics.draw(game_tiles[31],  64*4, 64*3)
		love.graphics.draw(game_tiles[32],  64*5, 64*3)
		love.graphics.draw(game_tiles[33],  64*6, 64*3)
		love.graphics.draw(game_tiles[34],  64*7, 64*3)
		love.graphics.draw(game_tiles[35],  64*8, 64*3)
		love.graphics.draw(game_tiles[36],  64*9, 64*3)
		love.graphics.draw(game_tiles[21],  64*1, 64*4)
		love.graphics.draw(game_tiles[22],  64*2, 64*4)
	end
	
	draw_research_icons()
	------------------- TOP UI Drawing ---------------------------------
	draw_inventory_icons()
	draw_game_ui()	
	----------------------- END TOP UI Drawing ------------------------
end--end function
