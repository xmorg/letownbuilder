--file with villager functions

function new_villager(migration)
   local start_x = math.random(400,600)
   local start_y = math.random(400,600)
   a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
	died_x = 0, died_y = 0, direction = 0, 
	job = "idle", 
	speak = 0, 
	speed = 3,
	talk_timer = 0, alive=1, --always start alive 
	nodie_timer = 0,
	name = crude_names_front[math.random(1,26)]..crude_names_back[math.random(1,26)],  
	sex = math.random(0,1), --1 male, 0 female
	age = nil, --math.random 18,65
	villager_type = "normal", -- 1, normal, 2, dark elf, 3 bandit, 4 light elf
	house_x = -1, 
	house_y = -1,
	spouse_of = "None",
	scion_of  = "None",
	position = "peasant",
	mood = "very happy",
	opinion = "Excited about founding new town.",
	disease = "healthy",
	disease_timer = 0,
	sprite = 1, dead_sprite = 2,
	selected = 0
   }
   if migration == 0 then
      a.age = math.random(18,50)
   else
      a.age = math.random(1,70)
      if a.age < 12 then
	 a.opinion = "Running around wildly."
	 --assign child sprite.
	 a.sprite = 5
      else
	 a.opinion = "Excited about moving to a new town."
      end
      --TODO: Decrease the chances of getting these.
      troublemaker = math.random(1,10)
      if troublemaker == 1 then -- create a troublemaker
	 random_type = math.random(1, table.getn(villager_types))
	 a.villager_type = villager_types[random_type]
      end
   end

   --table.insert(game_villager_pets, new_villager_pet("tabby cat", a.name)) -- fix the pet to random
   if a.villager_type == "dark elf" and a.sex == 0 then
      a.sprite = 7
      a.dead_sprite = 8
   elseif a.villager_type == "dark elf" and a.sex == 1 then
      a.sprite = 21
      a.dead_sprite = 22
   elseif a.villager_type == "bandit" then
      a.sprite = 9
      a.dead_sprite = 10
   elseif a.villager_type == "dwarf" then
      a.sprite = 39
      a.dead_sprite = 6
   elseif a.villager_type == "holyman" then
      a.sprite = 15
      a.dead_sprite = 16
   elseif a.villager_type == "normal" and a.sex == 0 then
      a.sprite = 3
      a.dead_sprite = 4
   elseif a.villager_type == "normal" and a.sex == 1 then
      a.sprite = 1
      a.dead_sprite = 2
   end
   if a.age < 12 then
      a.sprite = 5
      a.dead_sprite = 6
   --else
   --   a.sprite = 5
   --   a.dead_sprite = 6
   end
   
   if a.villager_type == "werewolf" then
      kingdom_inventory.werewolves=kingdom_inventory.werewolves+1
      a.age = math.random(17,55) --no child werewolves
   elseif a.villager_type == "dark elf" then
      kingdom_inventory.dark_elves=kingdom_inventory.dark_elves+1
   elseif a.villager_type == "dwarf" then
      kingdom_inventory.dwarves = kingdom_inventory.dwarves+1
   elseif a.villager_type == "holyman" then
      kingdom_inventory.holyman=kingdom_inventory.holyman+1
   end
   return a
end

function villager_touched(v1, v2) --if villagers/animals colliding with each other.
   tx = v1.x +2
   ty = v1.y +10
   if tx >= v2.x and tx <= v2.x+5 and ty >= v2.y and ty <= v2.y+10 then
      return 1
   else 
      return 0
   end
end

function kill_villager_by_name(name, cause) --look up villager name and slay them.
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].name == name then
	 game_villagers[i].alive = 0 -- Just died of disease
	 if game_villagers[i].villager_type == "dark elf" then
	 	kingdom_inventory.dark_elves = kingdom_inventory.dark_elves -1 --for research
	 end
	 game_villagers[i].villager_type = "Dead"
	 kingdom_inventory.villagers = kingdom_inventory.villagers -1 --remove living villagers
	 --Is it game over?
	 if kingdom_inventory.villagers <= 0 then
	 	--GAME OVER!
	 	message_que_add("All of your villagers have died.", 100, 6)
	 	--{"Everybody's dead", "Let everyone die.", score = 0, win=1 , icon=5},
	 	update_achivements("Everybody's dead", 1) 
	 	--game.show_menu = 99
	 end
	 --game_villagers[i].opinion = "Died on Day"..game.day_count.." at "..game.day_time
	 game_villagers[i].opinion = "died from "..cause.." on day "..game.day_count
	 game_villagers[i].died_x = game_villagers[i].x
	 game_villagers[i].died_y = game_villagers[i].y
	 game.message_box_icons = 19
	 set_family_opionions(game_villagers[i]) --not yet tested
	 if game_villagers[i].sex == 0 then
	    message_que_add(game_villagers[i].name.." has died of"..cause.."! The horror!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
	 else
	    message_que_add(game_villagers[i].name.." has died of "..cause.."!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+5
	 end
      end
   end
end

function get_villager_famgroups()
   --loop through villagers and group villagers into families based on husband/wife/scion relationship
   a = {}
   for i,v in ipairs(game_villagers) do
      if game_villagers[i].sex == 1 and game_villagers[i].age >= 18 then --male adult
	 new_fam = {} -- start a new family
	 table.insert(new_fam, game_villagers[i]) -- insert male into families
	 if game_villagers[i].spouse_of ~= "None" then --are they married?
	    for i2,v2 in ipairs(game_villagers) do --loop through to check for spouse
	       if game_villagers[i].spouse_of == game_villagers[i2].name then
		  table.insert(new_fam, game_villagers[i2]) -- add spouse to family
	       end--endif
	    end--end loop to check for spouse
	 end--endif married
	 for i2,v2 in ipairs(game_villagers) do --check to see if they have any kids!
	    if game_villagers[i2].scion_of == game_villagers[i].name then
	       table.insert(new_fam, game_villagers[i2]) -- insert kids into current family
	    end
	 end
	 table.insert(a, new_fam)
	 --already checked to see if older than 18
	 -- check for orphaned children
      elseif game_villagers[i].age <= 18 and game_villagers[i].spouse_of == "None" and game_villagers[i].scion == "None" then
	 new_fam = {}
	 table.insert(new_fam, game_villagers[i]) -- insert as their own family
	 table.insert(a, new_fam)
      elseif game_villagers[i].sex == 0 and  game_villagers[i].age >= 18 and game_villagers[i].spouse_of == "None" then--unmarried females?
	 new_fam = {}
	 table.insert(new_fam, game_villagers[i])
	 table.insert(a, game_villagers[i]) -- insert as their own family
      end
   end
   return a
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


function set_villager_position(name, position, message, forced)
   --villager becomes a "position"
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].name == name then
	 if game_villagers[i].position == "peasant" and game_villagers[i].age > 17 then
	    game_villagers[i].position = position
	    message_que_add(message, 3, 7)
	    break
	 elseif forced == 1 then
	    game_villagers[i].position = position
	    message_que_add(message, 3, 7)
	    break
	 end
      end
   end
end
function new_village_mayor(game_villagers, otherpos, message)
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
	       game.mayor_sex = 62 --male
	    else mself = "herself"
	       game.mayor_sex = 63 --female
	       message_que_add(game_villagers[i].name.." has declared "..mself.." 'defacto' mayor for life!", 200, 7)
	    end
	 end --endif
      end--endif
   end--endfor
end -- endfunction

function contract_disease(villager, d_index, chance)
   --villager object, index of disease, chance to contract.
   c = math.random(1, chance)
   if c == 1 then
      villager.disease = plague_list[d_index]
      villager.disease_timer = 1000
      return true
   else
      return false
   end
end
function munch_food(villager)
   --we love our meat! even raw! but if there is a bonfire we shall smoke it first!
   if kingdom_inventory.fishwine > 0 then
      villager.opinion = "drank fish wine today!"
      kingdom_inventory.fishwine = kingdom_inventory.fishwine -1
      if kingdom_inventory.unrest > 0 then
	 kingdom_inventory.unrest = kingdom_inventory.unrest -1
      end
   elseif kingdom_inventory.paleale > 0 then
      villager.opinion = "had a pale ale today!"
      kingdom_inventory.paleale = kingdom_inventory.paleale -1
      if kingdom_inventory.unrest > 0 then
	 kingdom_inventory.unrest = kingdom_inventory.unrest -math.random(0,1)
      end
   elseif kingdom_inventory.raw_meat + kingdom_inventory.smoked_meat > 0 then
      --check for bonfires
      if kingdom_inventory.bonfire > 0 then 	 --smoke the meat
	 kingdom_inventory.smoked_meat = kingdom_inventory.smoked_meat + kingdom_inventory.raw_meat
	 kingdom_inventory.raw_meat=0
	 villager.opinion = "Ate smoked meat today."
	 kingdom_inventory.smoked_meat = kingdom_inventory.smoked_meat -1
      else
	 if contract_disease(villager, 1, 2) == false then --you are taking your life in your hands here!
	    villager.opinion = "Ate raw meat today."
	    kingdom_inventory.raw_meat=kingdom_inventory.raw_meat-1
	 else
	    villager.opinion = "Feels bad after eating raw meat!"
	    message_que_add(villager.name.."'s raw meat was contaminated!", 100, 9)
	    kingdom_inventory.raw_meat=kingdom_inventory.raw_meat-1
	 end
     end
   elseif kingdom_inventory.smoked_fish > 0 then 
   	kingdom_inventory.smoked_fish = kingdom_inventory.smoked_fish-1
   	kingdom_inventory.unrest = kingdom_inventory.unrest - math.random(0,1) --might be happy at eating fish.
   	if contract_disease(villager, 1, 20) == false then -- better chance if fish is cooked
	  villager.opinion = "Ate smoked fish today."
        else --if medical is higher you know what happend
	  villager.opinion = "Feels bad after eating smoked fish."
	  message_que_add(villager.name.."'s fish was contaminated!", 100, 9)
        end--endif contrac...
   elseif kingdom_inventory.fish > 0 then
      if kingdom_inventory.bonfire > 0 then
      	kingdom_inventory.smoked_fish = kingdom_inventory.smoked_fish+kingdom_inventory.fish
      	kingdom_inventory.fish = 0
      	kingdom_inventory.smoked_fish = kingdom_inventory.smoked_fish-1
      else
        kingdom_inventory.fish = kingdom_inventory.fish -1
        if contract_disease(villager, 1, 4) == false then
	  villager.opinion = "Ate fish today."
        else --if medical is higher you know what happend
	  villager.opinion = "Feels bad after eating fish."
	  message_que_add(villager.name.."'s fish was contaminated!", 100, 9)
        end--endif contrac...
       end--end if bonfire
      return 1
   elseif kingdom_inventory.mushrooms > 0 then kingdom_inventory.mushrooms = kingdom_inventory.mushrooms -1 
      villager.opinion = "Ate mushrooms today."
      return 1
   elseif kingdom_inventory.sansai > 0 then
      kingdom_inventory.sansai = kingdom_inventory.sansai-1
      if contract_disease(villager, 1, 10) == false then
	 villager.opinion = "Feels bad after eating Sansai."
	 message_que_add(villager.name.."'s sansai was contaminated!", 100, 9)
      else
	 villager.opinion = "Ate sansai today."
      end
      return 1
   elseif kingdom_inventory.tomatoes > 0 then 
   	kingdom_inventory.tomatoes = kingdom_inventory.tomatoes -1
   	villager.opinion = "Ate tomatoes today."
   elseif kingdom_inventory.carrots > 0 then 
      kingdom_inventory.carrots = kingdom_inventory.carrots -1
      if contract_disease(villager, 1, 10) == false then
	 villager.opinion = "Feels bad after eating carrots."
	 message_que_add(villager.name.."'s carrots were contaminated!", 100, 9)
      else
	 villager.opinion = "Ate carrots today."
      end
      return 1
   elseif kingdom_inventory.desert_onions > 0 then
      kingdom_inventory.desert_onions = kingdom_inventory.desert_onions -1
      if contract_disease(villager, 1, 10) == false then
	 villager.opinion = "Feels bad after eating onions."
	 message_que_add(villager.name.."'s onions were contaminated!", 100, 9)
      else
	 villager.opinion = "Ate wild onions today."
      end
      return 1
   elseif kingdom_inventory.grain > 0 then kingdom_inventory.grain = kingdom_inventory.grain -1
      villager.opinion = "Ate grain today."
      return 1
   elseif kingdom_inventory.cherries > 0 then kingdom_inventory.cherries = kingdom_inventory.cherries -1
      villager.opinion = "Ate cherries today."
      return 1
   else
      return 0 -- hungry!
   end
end

function villagers_eat_food(num_villagers) -- eat food
   local rot_flag = 0
   local munched = 0
   message_que_add("Its lunchtime!", 300, 46) --support the message_box_icon?
   game.message_box_icon  = 98
   kingdom_inventory.hunger=0
   --bandits steal food first!
   
   local sheriff_caught_bandit = math.random(1,10-research_topics.security) --did the sharif succeed?
   for i,v in ipairs(game_villagers) do --loop through villagers, if bandit is alive take food
      if game_villagers[i].alive == 1 and game_villagers[i].villager_type == "bandit" then
	 if kingdom_inventory.sheriff > 0 and sheriff_caught_bandit <= 1 then
	    message_que_add("The Sheriff caught "..game_villagers[i].name.." trying to steal food.", 300, 3)
	    --achivement
	    achivements[6].score = 1
	 elseif kingdom_inventory.sheriff > 0 then --this is a sheriff but he failed
	    message_que_add("The Sheriff failed to catch the thieves!", 300, 3)
	    munch_food(game_villagers[i])
	 else --- there is no sheriff
	    munch_food(game_villagers[i])
	    message_que_add(" Food has gone missing!", 300, 3)
	 end
      end
   end
   --change
   --for x = 1, num_villagers do
   for i,v in ipairs(game_villagers) do
      if munch_food(game_villagers[i]) == 0 then --munch_food removes the food already
	 kingdom_inventory.hunger = kingdom_inventory.hunger + 1 
	 kingdom_inventory.unrest = kingdom_inventory.unrest + kingdom_inventory.hunger
	 game_villagers[i].opinion = "Didn't eat today."
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
      message_que_add("Without proper storage, some of your food rotted!", 300, 9)
   end
end

function villager_goto_bonfire(villager)
   local lx = 0
   local ly = 0
   for y = 1, game.tilecount do --loopy
      for x = 1, game.tilecount do --loopx
	 if game_fire_map[y][x] == 1 and game_map[y][x] == 47 then -- found a fire(the top one)
	    lx = 300+(y - x) * 32 + 64
	    ly = -100+(y + x) * 32 / 2 + 50
	    villager.dx = lx + math.random(30,60) --(y*  --dx = start_x, dy = start_y, 
	    villager.dy = ly + math.random(30,60)
	    villager.job = 0
	    break
	 end
      end
   end
end

function villagers_seek_shelter(num_villagers)--check how many homes are availible
   local families = get_villager_families(game_villagers)
   kingdom_inventory.families = families
   message_que_add("It is night.", 300, 21)
   if kingdom_inventory.bonfire < 1 then
      message_que_add(" It is dark and cold!", 300, 21)
      -- + unrest if there is no bonfire
      kingdom_inventory.unrest = kingdom_inventory.unrest+ table.getn(game_villagers)
      for i,v in ipairs(game_villagers) do
	 game_villagers[i].opinion = "Trying to keep warm without a fire"
      end
   else
      for i,v in ipairs(game_villagers) do
	 --try to find bonfire
	 villager_goto_bonfire(game_villagers[i])
      end
   end
   --game.message_box_timer = 300
   -- TODO: instead of each villager, check for families
   -- TODO: now use game_families = 
   --end
   game_families = get_villager_famgroups() --update families list
   --loop through families
   local housecount = 1
   for i,v in ipairs(game_families) do
      --assign a house to family
      local f = game_families[i]
      if housecount > kingdom_inventory.homes then
	 for i2,v2 in ipairs(game_families[i]) do
	    game_families[i][i2].opinion = "Upset about being homeless"
	 end
      end
      housecount = housecount+1	--BUG, if there are no homes, and no fires what happens?
   end--endfor
   if kingdom_inventory.homes < families then
      kingdom_inventory.homeless = families - kingdom_inventory.homes
      kingdom_inventory.unrest = kingdom_inventory.unrest + kingdom_inventory.homeless
   elseif kingdom_inventory.homes >= table.getn(game_villagers) then --fixed bug where there is always 1 homeless
      kingdom_inventory.homeless = 0
      if kingdom_inventory.unrest > 0 then --general unrest decreases if all are housed
	 kingdom_inventory.unrest = kingdom_inventory.unrest - 1
      end
   end
end

function villagers_do_job(x, y, specialist)
   local found_worker = "false"
   local lx = 0
   local lx = 0
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].age > 14 and
	 game_villagers[i].position == specialist and
      game_villagers[i].alive == 1 then --can work
	 -------------------------
	 lx = 300+(y - x) * 32 + 64
	 ly = -100+(y + x) * 32 / 2 + 50
	 game_villagers[i].dx = lx+30
	 game_villagers[i].dy = ly+50
	 found_worker = "true"
	 return "true"
      else
	 found_worker = "false"
      end
   end
   if found_worker == "false" then
      for i, v in ipairs(game_villagers) do
	 if game_villagers[i].age > 14 and
	    game_villagers[i].position == "peasant" and
	 game_villagers[i].alive == 1 then --can work
	    lx = 300+(y - x) * 32 + 64
	    ly = -100+(y + x) * 32 / 2 + 50
	    game_villagers[i].dx = lx+30
	    game_villagers[i].dy = ly+50
	    game_villagers[i].position = specialist --testing
	    found_worker = "true"
	    return "true"
	 end--endif
      end--endfor
   end--endif
   if found_worker == "false" then
      message_que_add("Not enough workers to complete job!", 80, 2)
      return "false"
   end
end

function get_availible_worker(job_type) -- is a worker availible for the job?
   local found_worker = false
   for i, v in ipairs(game_villagers) do
      if job_type == "Build house" and game_villagers[i].position == "builder" then
	 return true
      elseif job_type == "Demolish building" and game_villagers[i].position == "builder" then
	 return true
      elseif (job_type == "Cut trees" or job_type == "Cut bamboo" or job_type == "Cut sakura") and game_villagers[i].position == "woodcutter" then
	 return true 
      elseif job_type == "Dig hole" and game_villagers[i].position == "miner" then
	 return true
      elseif job_type == "Gather Food" then
	 return true
      elseif  job_type == "Make garden" and game_villagers[i].position == "farmer" then
	 return true
      elseif  job_type == "Plant tomatoes" and game_villagers[i].position == "farmer" then
      	 return true
      end
   end --end for
   return false
end

function get_villager_specialist_name(s)
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].position == s then
	 return game_villagers[i].name
      end
   end
   return "None"
end


function set_family_opionions(j) --needs reworking to put what happened
   for i, v in ipairs(game_villagers) do
      if game_villagers[i].alive == 0 then
	 --game_villagers[i].opinion = "Dead"
	 game_villagers[i].villager_type = "Dead"
      elseif game_villagers[i].name == j.spouse_of and game_villagers[i].alive == 1 then
	 game_villagers[i].opinion = "Mourning the loss of "..j.name
      elseif game_villagers[i].name == j.scion_of and game_villagers[i].alive == 1 then
	 game_villagers[i].opinion = "Just lost child "..j.name
      elseif j.scion_of == game_villagers[i].name and game_villagers[i].alive == 1 then
	 game_villagers[i].opinion = "Just lost parent "..j.name
      end
   end
end
function update_villager_poisonedby_snake(i, j)
   local bitten = math.random(1,10)
   if villager_touched(i, j) == 1 and i.wildlife_type == "copperhead" then
      if j.alive == 1 and bitten == 1 then
	 j.disease = "Poisoned (copperhead)"
	 j.disease_timer = 200
	 game.message_box_icons = 19
	 --set_family_opionions(j) --not yet tested
	 message_que_add(j.name.." has been bitten by a copperhead snake!", 100, 1)
      end --if
   elseif villager_touched(i, j) == 1 and i.wildlife_type == "cobra" then
      if j.alive == 1 and bitten < 7 then
	 j.disease = "Poisoned (cobra)"
	 j.disease_timer = 50
	 game.message_box_icons = 19
	 --set_family_opionions(j) --not yet tested
	 message_que_add(j.name.." has been bitten by a cobra snake!", 100, 1)
      end --if
   end --if game_villagers[i].villager_type == "werewolf" and game_villagers[j].villager_type == "werewolf" then
end --function

function villager_combat(mob, villager)
	villager_dice = math.random(1,6)
	mob_dice = math.random(1,6)
	if villager.position == "militia captain" or villager.position =="militia" then
		if villager_dice >mob_dice then
			return 1
		else
			return 0
		end
	elseif villager.position == "dark elf" or villager.position == "dwarf" then
		if villager_dice >mob_dice then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

function update_villager_killedby_nightwolf(nightwolf, villager)
	if villager_touched(nightwolf, villager) == 1 and nightwolf.wildlife_type == "night wolf" and is_night()==1 then
		if villager.alive == 1 and villager_combat(nightwolf, villager) == 0 then
			villager.alive = 0 -- Just got killed by a werewolf init death sequence
			villager.villager_type = "Dead"
			villager.opinion = "Died on Day"..game.day_count.." at "..game.day_time
			villager.died_x = villager.x
			villager.died_y = villager.y
			game.message_box_icons = 19
			set_family_opionions(villager) --not yet tested
			if villager.sex == 0 then
				message_que_add("You hear a blood curtling scream..."..villager.name.."!", 100, 1)
				kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
			else
				message_que_add("You hear a horrible scream..."..villager.name.."!", 100, 1)
				kingdom_inventory.unrest = kingdom_inventory.unrest+5
			end
		else
			if nightwolf.alive == 1 then
				nightwolf.alive = 0
				villager.opinion = "Defeated a nightwolf in single combat"
				nightwolf.died_x = nightwolf.x
				nightwolf.died_y = nightwolf.y
				message_que_add(villager.name.." has fought a nightwolf and lived!", 100, 1)
			end
		end --game_villagers[j].alive == 1 then
	end--end if villager_touched(game_villagers[i], game_villagers[j]) 
end

function update_villager_killedby_werewolf(i, j)
	if villager_touched(i, j) == 1 and i.villager_type == "werewolf" and is_night()==1 then
		if i.villager_type == "werewolf" and j.villager_type == "werewolf" then
			i.alive = 1
			i.alive = 1
		elseif i.villager_type == "werewolf" and j.villager_type ~= "werewolf" then
			if j.alive == 1 and villager_combat(i, j) == 0 then
				j.alive = 0 -- Just got killed by a werewolf init death sequence
				j.villager_type = "Dead"
				j.opinion = "Died on Day"..game.day_count.." at "..game.day_time
				j.died_x = j.x
				j.died_y = j.y
				game.message_box_icons = 19
				set_family_opionions(j) --not yet tested
				if j.sex == 0 then
					message_que_add("You hear a blood curtling scream..."..j.name.."!", 100, 1)
					kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
				else
					message_que_add("You hear a horrible scream..."..j.name.."!", 100, 1)
					kingdom_inventory.unrest = kingdom_inventory.unrest+5
				end
			else
				if i.alive == 1 then
					i.alive = 0
					j.opinion = "Survived a werewolf attack."
					i.died_x = i.x
					i.died_y = i.y
					message_que_add(j.name.." has fought a werewolf and lived!", 100, 1)
				end
			end --game_villagers[j].alive == 1 then
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
   game_villagers[i].talk_timer = 100
end
--TODO: Here.

function update_villager_jobs(dt) -- here is where timers should go down?
   ------- Now loop through villagers
   --function villager_collision_event(game_villagers) --loop through villagers and check for collisions
   for i, v in ipairs(game_villagers) do --loop through villagers
      --update_villager_killedby_nightwolf(i, j)
      if game_villagers[i].position == "militia captain" or game_villagers[i].position == "militia" then
      	game_villagers[i].speed = 8
      end
      for n, m in ipairs(game_nightwolves) do
      	
	 update_villager_killedby_nightwolf(game_nightwolves[n], game_villagers[i]) --loop through nightwolves and check for colisions.
      end
      for j, w in ipairs(game_villagers) do --loop through villagers
	 update_villager_killedby_werewolf(game_villagers[i], game_villagers[j])--- WEREWOLF COLLISION
	 update_villager_zombiefied_by_zombie(game_villagers[i], game_villagers[j]) --zombie collision
	 --update_villager_bitby_snake(game_villagers[i], wildlife?) -- rework
	 -- GHOSTS !-------------------------------------
	 if game_villagers[i].alive == 0 and game_villagers[i].job == 0 and kingdom_inventory.graveyards < 1 and is_night() == 1 then
	    game_villagers[i].job = math.random(1, 1000) --ghosts!
	    if game_villagers[i].job < 10 then -- movment
	       game_villagers[i].dx = game_villagers[i].dx + math.random(-30,30) --ghost!
	       game_villagers[i].dy = game_villagers[i].dy + math.random(-30,30) --ghost!
	    elseif game_villagers[i].job == 50 then -- talk!
	       update_villager_talking(i)
	    end
	    
	    -- The LIVING!-------------------------------------
	 elseif game_villagers[i].position == "militia captain" and (game_villagers[i].alive == 1) then
	 	-- do militia captain stuff!
	 elseif game_villagers[i].job == 0 and (game_villagers[i].alive == 1 or game_villagers[i].alive == -1) then -- The living!
	    game_villagers[i].job = math.random(1, 1000)
	    if game_villagers[i].job < 10 then -- movment
	       if game_directives.active == 1 then --job active BUGGED CODE?
		  ---note only the tasked villagers should go
		  game_villagers[i].dx = game_villagers[i].dx + math.random(-30,30) --temp workaround
		  game_villagers[i].dy = game_villagers[i].dy + math.random(-30,30)
	       elseif game.day_time >= 22000 then --Time based!
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
	 update_villager_new_destination(game_villagers[i], dt, game_villagers[i].speed) --why are they moving so fast?	
      end-- for j, w in ipairs(game_villagers) do
   end--for i, v in ipairs(game_villagers) do
end

function on_hunt_something(x, y) --is there an animal in x/y
   local range = 64
   local found_wildlife = 0 --check if you found wildlife
   local m = math.random(1,10)
   local s = math.random(1,10)
   local peltdice = math.random(1,3)
   --local animal = nil
   --message_que_add("DEBUG: started hunting at "..x.."x"..y, 80, 44)
   villagers_do_job(x, y, "hunter") --assign a hunter to do the work.
   for i, v in ipairs(game_wildlife) do
      screenx = game_wildlife[i].x +game.draw_x
      screeny = game_wildlife[i].y +game.draw_y
      if ( x >= screenx -range and
	      x <= screenx +range and
	      y >= screeny -range and
	   y <= screeny +range and found_wildlife == 0 ) then
	 found_wildlife = 1
	 --on_hunt_found_wildlife(game_wildlife[i]) --why nil?
	 if found_wildlife == 1 and s > 4 and game_wildlife[i].alive == 1 then
	    message_que_add("You bagged a "..game_wildlife[i].wildlife_type.."!", 80, 44)
	    if game_wildlife[i].wildlife_type == "copperhead" then --snakeeater
	    	update_achivements("Snake Eater", 1)
	    end
	    if peltdice == 1 then kingdom_inventory.pelts = kingdom_inventory.pelts+1 end
	    kingdom_inventory.raw_meat = kingdom_inventory.raw_meat+ m
	    game_wildlife[i].alive = 0
	    game_wildlife[i].died_x = game_wildlife[i].x
	    game_wildlife[i].died_y = game_wildlife[i].y
	 else
	    if s == 1 then
	       if game_wildlife[i].wildlife_type == "copperhead" then
		  message_que_add(get_villager_specialist_name("hunter").." was bitten by a "..game_wildlife[i].wildlife_type.." and died of snake poison!", 80, 44)
		  kill_villager_by_name(get_villager_specialist_name("hunter"), "a hunting accident") --kill villager here.
	       elseif game_wildlife[i].wildlife_type == "bear" or game_wildlife[i].wildlife_type == "black bear" then
		  message_que_add(get_villager_specialist_name("hunter").." was mauled by a "..game_wildlife[i].wildlife_type.." and died of massive internal bleeding!",  80, 44)
		  kill_villager_by_name(get_villager_specialist_name("hunter"), "a hunting accident") --kill villager here.
	       end
	    else --if s ==1
	       message_que_add("You failed to killed a "..game_wildlife[i].wildlife_type, 80, 44)
	    end --if s ==1
	 end --if found_wildlife
      end --if screen
   end --end for
   for i, v in ipairs(game_nightwolves) do --hunt nightwolves and fail!(mostly)
      screenx = game_nightwolves[i].x +game.draw_x
      screeny = game_nightwolves[i].y +game.draw_y
      if ( x >= screenx -range and
	      x <= screenx +range and
	      y >= screeny -range and
	   y <= screeny +range  and found_wildlife == 0) then
	 found_wildlife = 1
	 if found_wildlife == 1 and s > 9 and game_nightwolves[i].alive == 1 then -- 10% chance of killing
	    message_que_add("Your brave hunter has bagged a "..game_nightwolves[i].wildlife_type.."!", 80, 44) --was wildlife_type
	    kingdom_inventory.raw_meat = kingdom_inventory.raw_meat+ m
	    game_nightwolves[i].alive = 0
	    game_nightwolves[i].died_x = game_nightwolves[i].x
	    game_nightwolves[i].died_y = game_nightwolves[i].y
	 else --why did you even try?
	    message_que_add(get_villager_specialist_name("hunter").." tried to kill a nightwolf and was torn to pieces. Foolish!", 80, 44)
	    --kill villager here.
	    kill_villager_by_name(get_villager_specialist_name("hunter"), "tried to kill a nightwolf.")
	 end
      end --endif
   end --endfor  
   if found_wildlife == 0 then
      message_que_add("You didnt find any game", 80, 2) --you didnt click on a wildlife?
   end
end --end function

function update_villager_gohome(v) --game_villagers[i])
   --this villager wants to go to his/her own house
   --given house_x, house_y make villager go to the location of this tile
   --set the dx/dy to the x/y of the location of the tile
   --local one = 1
   if v.house_x > 0 and v.house_y > 0 then -- if villager owns a house.
      lx = 300+(v.house_y - v.house_x) * 32 + 64 --calc location of the
      ly = -100+(v.house_y + v.house_x) * 32 / 2 + 50 --house
      v.dx = lx + math.random(30,60) --set destination to the calulated 
      v.dy = ly + math.random(30,60) --location of the house
      v.job = 0 -- set job to zero?
   end
end

function check_for_disease(i)
   if game_villagers[i].disease_timer > 0 and game_villagers[i].disease ~= "healthy" then
      game_villagers[i].disease_timer = game_villagers[i].disease_timer-1
      death = math.random(1,1024)
      if death == 1 then
	 --villager died from disease
	 game_villagers[i].alive = 0 -- Just died of disease
	 game_villagers[i].villager_type = "Dead"
			--game_villagers[i].opinion = "Died on Day"..game.day_count.." at "..game.day_time
	 game_villagers[i].opinion = "died from "..game_villagers[i].disease.." on day "..game.day_count
	 game_villagers[i].died_x = game_villagers[i].x
	 game_villagers[i].died_y = game_villagers[i].y
	 game.message_box_icons = 19
	 set_family_opionions(game_villagers[i]) --not yet tested
	 if game_villagers[i].sex == 0 then
	    message_que_add(game_villagers[i].name.." has died of disease!  The horror!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+6 --girls dying unerves us more!
	 else
	    message_que_add(game_villagers[i].name.." has died of disease!", 100, 6)
	    kingdom_inventory.unrest = kingdom_inventory.unrest+5
	 end
      end
   elseif game_villagers[i].disease_timer <= 0 and game_villagers[i].disease ~= "healthy" and
   game_villagers[i].alive == 1 then --villager recovered
      --game_villagers[i].disease_timer=0
      game_villagers[i].opinion = "recovered from "..game_villagers[i].disease
      game_villagers[i].disease = "healthy"
   elseif game_villagers[i].disease_timer <= 0 and game_villagers[i].disease ~= "healthy" and
   game_villagers[i].alive == 0 then --villager died from...
      game_villagers[i].opinion = "died from "..game_villagers[i].disease.." on day "..game.day_count
   end
end

riot_cod = {"Crushed in the press of the riot",
	"immolated while trying to set a house on fire",
	"beaten to death while trying to defend the mayor",
	"tried to attack a bear!",
	"Died in a riot",
	"was found dead after a stampeed"
	}
function assassinate_mayor(assassin)
   for i,v in ipairs(game_villagers) do
      if game_villagers[i].possition == "mayor" and game_villagers[i].alive == 1 then
	 local s = math.random(1,2+research_topics.security)
	 if s == 1 then
	    --kill mayor
	    kill_villager_by_name(game_villagers[i].name, "was assassinated!")
	 else
	    --kill assassin
	    kill_villager_by_name(assassin, "was killed while trying to assassinate the mayor!")
	 end
      end
   end
end
function villagers_rioting_report(vil)
   for i,v in ipairs(game_villagers) do
      --loop through villagers, analize job, pick random no of non-special for instadeath
      --sheriff can also die fighting rioters
      --bandits cannot die, but freely siphon supplies(1,2), especially gold, stone, wood, food
      --mayors can be assasinated chance(1,50) if darkelf-15, bandit(-15), shariff+(15) exist.
      --mayor assassination during a riot causes -30 to unrest.
      --possibility of a coup(1,100) if there is a militia house.  Sheriff, and Mayor both die. militia commander(TBD) becomes defactor mayor for life.
      --villager_type
      if game_villagers[i].position == "peasant" and game_villagers[i].alive == 1 then
	 local instadeath = math.random(1,20)
	 if instadeath == 1 then
	    kill_villager_by_name( game_villagers[i].name, 
				   riot_cod[math.random(1,6)] ) --look up villager name and slay them.
	 end
      end
      if game_villagers[i].villager_type == "bandit" and game_villagers[i].alive == 1 then
	 --siphon any food,gold,ore availible.
	 --attempt to assassinate mayor?(1,200)
	 local bandithired = math.random(1,200)
	 if bandithired == 1 then
	    assassinate_mayor(game_villagers[i].name)
	 end
      end
      if game_villagers[i].villager_type == "dark elf" and game_villagers[i].alive == 1 then
	 --attempt to assassinate bandit? (1,100)
	 --fail (1,2)
	 --1 mayor dies, 2 bandit dies
	 local bandithired = math.random(1,2)
	 if bandithired == 1 then
	    assassinate_mayor(game_villagers[i].name)
	 end
      end
      if game_villagers[i].position == "sheriff" and game_villagers[i].alive == 1 then
	 local died = math.random(1,100)
	 if died == 1 then
	    kill_villager_by_name( game_villagers[i].name, 
				   "died trying to quell the rioting.") --look up villager name and slay them.	
	 end
      end
   end --end loop through villagers
   --check if there is a militia house
   -- 1,10 chance of coupe.
end


