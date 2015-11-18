--game_invaders = {} --bandits, armies, vikings, zombies, etc.

function new_invader(ttype)
   local start_x = math.random(400,600)
   local start_y = math.random(400,600)
   a = {x = start_x, y = start_y, dx = start_x, dy = start_y, 
	died_x = 0, died_y = 0, direction = 0, 
	job = "idle", 
	speak = 0, 
	speed = 3,
	talk_timer = 0, alive=1, --always start alive 
	name = crude_names_front[math.random(1,26)]..crude_names_back[math.random(1,26)],  
	sex = math.random(0,1), --1 male, 0 female
	age = math.random(14,70), --math.random 18,65
	villager_type = ttype, -- 1, normal, 2, dark elf, 3 bandit, 4 light elf
	house_x = -1, 
	house_y = -1,
	spouse_of = "None",
	scion_of  = "None",
	position = "invader",
	mood = "very happy",
	opinion = "Excited about invading your town!",
	disease = "healthy",
	disease_timer = 0
   } 
   return a
end
function trigger_invasion(invasiontype) --love.update
	--set invasion flag on, populate invaders note, a merchant coming can also be "an invasion"
	--game.invasion_action = "none" 
	game.invasion_action = invasiontype
	--game_invaders = {}
	--if game.invasion_action == "goblins" then
		--add goblins and orcs
	--elseif game.invasion_action == "skeletons" then
	--elseif game.invasion_action == "pirates" then
	--elseif game.invasion_action == ""
	--end
end
function on_update_invasion() --love.update
	--check collions with villagers, 
	--do random things like captures, etc.
end
function trigger_invasion_terms() --love.update
	--you are given a choice (sometimes)
end
function trigger_invasion_over() --love.update
	--set invasion flag off, and clear game_invaders{}
end
function render_invasion()  --love.draw
	-- render invaders
	for i,v in ipairs(game_invaders) do
	end
end
