-----------------------------------------------
-- Levels of research
--
-----------------------------------------------

research_topics = { economy = 0, 
	security = 0, 
	agriculture = 0, 
	tomatoes = 0,
	brewery = 0,
	animal_taming = 0,
	civics = 0, 
	townhall = 0,
	elections = 0,
	propaganda = 0,
	industry = 0,
	scarecrow = 0,   --- 1 or 0
	holyplace = 0,
	militiahouse = 0,
	fisherboats = 0,
	waterforming = 0,
	restaurants = 0,
	mayors_monument = 0,
	smelter = 0,
	smithy = 0,
	militia_house = 0,
	watchtower = 0
}

function update_research_directives()
	if game_directives.research_type == "Research economy" then
		research_topics.economy = research_topics.economy+1 --level up econ
		message_que_add("You have reached economy Level "..research_topics.economy.."!", 100, 114)
		if research_topics.economy == 1 then
			message_que_add("You have unlocked the Trade post.", 100, 114)
		end
	elseif game_directives.research_type == "Research security" then
		research_topics.security = research_topics.security+1 --level up econ
		message_que_add("You have reached security Level "..research_topics.security.."!", 100, 115)
		if research_topics.security == 1 then
			message_que_add("You have unlocked the sheriff's office.", 100, 115)
		elseif research_topics.security == 2 then
			message_que_add("You have unlocked the watchtower.", 100, 115)
			research_topics.watchtower = 1	
		elseif research_topics.security == 3 then
			message_que_add("You have unlocked the militia house.", 100, 115)
			research_topics.militia_house = 1
		end
	elseif game_directives.research_type == "Research agriculture" then
		research_topics.agriculture = research_topics.agriculture+1 --level up econ
		message_que_add("You have reached agriculture Level "..research_topics.agriculture.."!", 100, 9)
		if research_topics.agriculture == 1 then
			message_que_add("You have unlocked tomatoes!", 100, 115)
			research_topics.tomatoes = 1
		elseif research_topics.agriculture == 2 then
			message_que_add("You have unlocked the brewery(TBD)", 100, 115)
			research_topics.brewery = 1
		elseif research_topics.agriculture == 3 then
			message_que_add("You have unlocked animal taming(TBD)", 100, 115)
			research_topics.animal_taming = 1
		end
	elseif game_directives.research_type == "Research civics" then
		research_topics.civics = research_topics.civics+1 --level up econ
		message_que_add("You have reached civics Level "..research_topics.civics.."!", 100, 9)
		if research_topics.civics == 1 then
			message_que_add("You have unlocked elections!"..research_topics.civics.."!", 100, 9)
			research_topics.elections = 1
			--held once a week, random new mayor, +happiness
		elseif research_topics.civics == 2 then
			message_que_add("You have unlocked the town hall!"..research_topics.civics.."!", 100, 9)
			research_topics.townhall = 1
		elseif research_topics.civics == 3 then
			message_que_add("You have unlocked propaganda!"..research_topics.civics.."!", 100, 9)
			research_topics.propaganda = 1
		end
	elseif game_directives.research_type == "Research industry" then
		research_topics.industry = research_topics.industry+1 --level up econ
		message_que_add("You have reached industry Level "..research_topics.industry.."!", 100, 22)
		if research_topics.industry == 1 then
			message_que_add(" You have unlocked the fishing hut", 100, 22)
		elseif research_topics.industry == 2 then
			message_que_add(" You have unlocked iron smelting", 100, 22)
			research_topics.smelter = 1
		elseif research_topics.industry == 3 then
			message_que_add(" You have unlocked iron smithing", 100, 22)
			research_topics.smithy = 1
		elseif research_topics.industry == 4 then
			message_que_add(" You have unlocked iron tools", 100, 22)
		--elseif research_topics.industry == 5 then
		--	message_que_add(" You have unlocked iron weapons", 100, 22)
		end
	end
	--------------- CHECK FOR COMBOS ------------------------------
	--* Agriculture(1), Security(1) (tbd) Scarecrow - Further reduce bird raids.
	--* Civics(2) Security(2) Militia House, a permanent place for your citizen army, reduces unrest and allows for a longer militia muster time.
	--* Industry(1) Economy(3) Fisherboats! Catch more fish out in the middle of a lake.
	--* Agriculture(4) Economy(5) Restaurants. Eat out in style.  Comfort food for massive unrest reduction.
	--* Agriculture(1) Industry(1) Civics(1) Waterforming.  Fill holes with water.
	if research_topics.security >=1 and research_topics.agriculture >= 1 and research_topics.scarecrow == 0 then
		message_que_add("You have unlocked scarecrows!", 100, 115)
		research_topics.scarecrow = 1
	elseif research_topics.civics >= 2 and research_topics.security >=2 and research_topics.militiahouse == 0 then
		message_que_add("You have unlocked the militia house!(Not Implemented)", 100, 115)
		research_topics.militiahouse = 1
	elseif research_topics.industry >= 1 and research_topics.economy >= 3 and research_topics.fisherboats == 0 then
		message_que_add("You have unlocked fisher boats!(Not Implemented)", 100, 115)
		research_topics.fisherboats = 1
	elseif research_topics.agriculture >= 4 and research_topics.economy >= 5 and research_topics.fisherboats == 0 then
		message_que_add("You have unlocked restaurants!(Not Implemented)", 100, 115)
		research_topics.restaurants = 1
	elseif research_topics.agriculture >= 1 and research_topics.industry >= 1 and 
		research_topics.civics >= 2 and research_topics.waterforming == 0 then
		message_que_add("You have unlocked waterforming!(Not Implemented)", 100, 115)
		research_topics.waterforming = 1
	elseif research_topics.civics >= 1 and research_topics.mayors_monument == 0 then
		research_topics.mayors_monument = 1
		message_que_add("You have unlocked the Mayor's Monument!", 100, 115)
	elseif research_topics.industry == 5 and research_topics.security >=3 then
		message_que_add(" You have unlocked iron weapons", 100, 22)
	end
	game_directives.research_type = "None"
end

--might not be needed (wasnt needed for scarecrow)
-- lets do a draw garden function!
function unlock_addition(unlock_string)
	if unlock_string == "scarecrow" then
		if research_topics.scarecrow == 1 then
			return true
		else
			return false
		end--endif
	end--endif
end
