--stuff
achivements = {
  {"Tree Puncher", "Cut down your first tree.", score=0, win=1, icon=76}, --done
  {"Food horder", "Collect 100 food.", score = 0, win=100 , icon=77}, --done
  {"Nice buffet", "Have more than 5 types of food", score=0, win=5, icon=78}, 
  {"Worlds biggest BBQ", "Barn catches on fire.", score = 0, win=1 , icon=79}, --done
  {"Everybody's dead", "Let everyone die.", score = 0, win=1 , icon=80}, --done
  {"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0, win=1, icon=81 }, --done
  {"Who took my food!?", "Catch a bandit stealing your food.", score = 0, win=1 , icon=82}, --villagers.lua,350+
  {"The howling", "Survive a night with nightwolves", score = 0, win=1 , icon=83},
  {"Nightwolf slayer", "Hunter kills a nightwolf", score = 0, win=1 , icon=84},
  {"Now you make me mad","Decend into rioting.", score = 0, win=1 , icon=85},
  {"Thriller night", "Everyone becomes a zombie", score = 0, win=1 , icon=11},
  {"Epic Hunter", "Hunter kills 5 nightwolves", score = 0, win=5, icon=12},
  {"Snake Eater", "Hunter kills 5 snakes", score=0, win=5, icon=13},
  {"Pro logger", "Cut down 100 trees", score=0, win=100, icon=38}
  }

--achivements = {}

function load_new_achivements()--old code  
end

function update_achivements(a, score) --add to the scrore of a, and if it meants the required score set teh achievement
   for i,v in ipairs(achivements) do
      if achivements[i][1] == a and achivements[i].score < achivements[i].win then
	 achivements[i].score = achivements[i].score+1
	 -- now check if we got the achivement
	 if achivements[i].score >= achivements[i].win then -- we won
	    message_que_add("Achivement: "..achivements[i][1], 300, achivements[i].icon)
	 end
      end
   end --end loop through.
end


