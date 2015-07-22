-- file for animals, wildlife and pets.

function new_villager_pet(pet_type, pet_owner)
   local wildlife_types = {"bunny", "donkey",
			   "llama", "sheep", 
			   "shittzu dog", "pitbull dog", "mongrel dog", "dalmation dog",
			   "tabby cat", "black cat", "ferret",
			   "cow", "bull","parrot"
   } --added donkey art...
   a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
	died_x = 0, died_y = 0, direction = 0, job = 0, speak = 0, 
	talk_timer = 0, alive=1, --always start alive 
	domesticated = 0,
	sex = math.random(0,1), --1 male, 0 female
	age = 1, --TBD pet ages.
	wildlife_type = pet_type,
	owner = pet_owner,
	speed = 0}
   if a.wildlife_type == "bunny" then a.speed = 15 a.sprite = 17
   elseif a.wildlife_type == "donkey" then	a.speed = 3	a.sprite = 23
   elseif a.wildlife_type == "llama" then  a.speed = 3 a.sprite = 30
   elseif a.wildlife_type == "sheep" then a.speed = 3 a.sprite = 28
   elseif a.wildlife_type == "shittzu dog" then a.speed = 3 a.sprite = 31
   elseif a.wildlife_type == "pitbull dog" then a.speed = 3 a.sprite = 32
   elseif a.wildlife_type == "mongrel dog" then a.speed = 3 a.sprite = 32
   elseif a.wildlife_type == "dalmation dog" then a.speed = 3 a.sprite = 32
   elseif a.wildlife_type == "tabby cat" then a.speed = 4 a.sprite = 35
   elseif a.wildlife_type == "black cat" then a.speed = 4 a.sprite = 35
   elseif a.wildlife_type == "ferret" then a.speed = 4 a.sprite = 35
   elseif a.wildlife_type == "cow" then a.speed = 4 a.sprite = 35
   elseif a.wildlife_type == "bull" then a.speed = 4 a.sprite = 35
   elseif a.wildlife_type == "parrot" then a.speed = 4 a.sprite = 17
   end
   return a
end

function new_wildlife(migration, name)
   local start_x = math.random(100,900)
   local start_y = math.random(100,900)
   local randtype = math.random(1,2)
   local wildlife_types = {"rabbit", "wild donkey",
			   "wild llama", "wild sheep", "fox", 
			   "wild dog", "bear", "black bear",
			   "lynx","copperhead"} --added donkey art...
   local randtype = math.random(1,table.getn(wildlife_types) )
   
   a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
	died_x = 0, died_y = 0, direction = 0, job = 0, speak = 0, 
	talk_timer = 0, alive=1, --always start alive 
	domesticated = 0,
	sex = math.random(0,1), --1 male, 0 female
	age = nil, --math.random 18,65
	wildlife_type = wildlife_types[randtype],-- 1, normal, 2, dark elf, 3 bandit, 4 light elf
	speed = 0
   }
	if name == "random" then
	   --nothing
	else
		a.wildlife_type = name
	end
	if migration == 0 then
		a.age = math.random(18,50)
		--a.wildlife_type = "rabbit"
	else
		a.age = math.random(1,70)
	end --if migration == 0 then
	if a.wildlife_type == "rabbit" then a.speed = 15 a.sprite = 17
	elseif a.wildlife_type == "wild donkey" then	a.speed = 3	a.sprite = 23
	elseif a.wildlife_type == "wild llama" then  a.speed = 3 a.sprite = 30
	elseif a.wildlife_type == "wild sheep" then a.speed = 3 a.sprite = 28
	elseif a.wildlife_type == "fox" then a.speed = 3 a.sprite = 31
	elseif a.wildlife_type == "wild dog" then a.speed = 3 a.sprite = 32
	elseif a.wildlife_type == "bear" then a.speed = 3 a.sprite = 33
	elseif a.wildlife_type == "black bear" then a.speed = 3 a.sprite = 34
	elseif a.wildlife_type == "lynx" then a.speed = 4 a.sprite = 35
	elseif a.wildlife_type == "copperhead" then a.speed = 4 a.sprite = 36
	elseif a.wildlife_type == "donkey" then a.speed = 4 a.sprite = 24
	elseif a.wildlife_type == "night wolf" then a.speed = 4 a.sprite = 42
	end
	return a
end

function spawn_nightwolves() --put night wolves into game_nightwolves = {}
	table.insert(game_nightwolves, new_wildlife(0, "night wolf") ) --need to set x,y based on screen edge.
	table.insert(game_nightwolves, new_wildlife(0, "night wolf") )
	table.insert(game_nightwolves, new_wildlife(0, "night wolf") )
	table.insert(game_nightwolves, new_wildlife(0, "night wolf") )
	table.insert(game_nightwolves, new_wildlife(0, "night wolf") )
	--game_nightwolves = {}
end
function drop_nightwolves() --nights over wolves are gone.
	for i,v in ipairs(game_nightwolves) do
		table.remove(game_nightwolves)
	end
end

function wildlife_proliferation() --disabled because of memory bug
   --loop through current wildlife, and add wildlife based on type. some wildlife breed faster than others.
   for i,v in ipairs(game_wildlife) do
      local pop = math.random(1,5)
      local name = "none"
      if game_wildlife[i].wildlife_type == "rabbit" then
	 for t = 1, pop do
	    table.insert(game_wildlife,  new_wildlife(0, "rabbit") )
	 end
      elseif game_wildlife[i].wildlife_type == "wild donkey" or
	 game_wildlife[i].wildlife_type == "wild llama" or
	 game_wildlife[i].wildlife_type == "wild sheep" then
	 name = game_wildlife[i].wildlife_type
	   if pop == 1 then
	      table.insert(game_wildlife,  new_wildlife(0, name) )
	   end
      elseif game_wildlife[i].wildlife_type == "fox" or game_wildlife[i].wildlife_type == "wild dog" then
	 pop = math.random(1,3)
	 if pop == 1 then
	    name = game_wildlife[i].wildlife_type
	    table.insert(game_wildlife,  new_wildlife(0, name) )
	 end
      elseif game_wildlife[i].wildlife_type == "bear" or game_wildlife[i].wildlife_type == "black bear" then
	 pop = math.random(1,20)
	 if pop == 1 then
	    name = game_wildlife[i].wildlife_type
	    table.insert(game_wildlife,  new_wildlife(0, name) )
	 end
      elseif game_wildlife[i].wildlife_type == "lynx" or game_wildlife[i].wildlife_type == "copperhead" then
	 pop = math.random(1,5)
	 if pop == 1 then
	    name = game_wildlife[i].wildlife_type
	    table.insert(game_wildlife,  new_wildlife(0, name) )
	 end
      end
   end
   --notes, bears break into store houses with fish
   --coperhead's can bite fishermen! (1,1000 chance to attack a fisherman)
   --more than  7 rabbits can devistate crops!
   --wild dogs have (1,1000) chance of biting children
end

