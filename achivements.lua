--stuff
achivements = {
  {"Tree Puncher.", "Cut down your first tree.", score=0, win=1},
  {"Food horder.", "Collect 100 food.", score = 0, win=100 },
  {"Nice buffet", "Have more than 5 types of food", score=0, win=5},
  {"Worlds biggest BBQ.", "Barn catches on fire.", score = 0, win=1 },
  {"Everybody's dead", "Let everyone die.", score = 0, win=1 },
  {"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0, win=1 },
  {"Who took my food!?", "Catch a bandit stealing your food.", score = 0, win=1 }, --villagers.lua,350+
  {"The howling.", "Survive a night with nightwolves", score = 0, win=1 },
  {"Nightwolf slayer", "Hunter kills a nightwolf", score = 0, win=1 },
  {"Now you make me mad.","Decend into rioting.", score = 0, win=1 },
  {"Thriller night", "Everyone becomes a zombie", score = 0, win=1 },
  {"Epic Hunter", "Hunter kills 5 nightwolves", score = 0, win=5},
  {"Snake Eater", "Hunter kills 5 snakes", score=0, win=5}
  }

--achivements = {}

function load_new_achivements()--old code
  table.insert( achivements,   {"Tree Puncher.", "Cut down your first tree.", score=0} )
  table.insert( achivements,    {"Food horder.", "Collect 100 food.", score = 0 } )
  table.insert( achivements,    {"Nice buffet", "Have more than 5 types of food", score=0} )
  table.insert( achivements,    {"Worlds biggest BBQ.", "Barn catches on fire.", score = 0 } )
  table.insert( achivements,    {"Everybody's dead", "Let everyone die.", score = 0 } )
  table.insert( achivements,    {"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0 } )
  table.insert( achivements,    {"Who took my food!?", "Catch a bandit stealing your food.", score = 0 } ) --villagers.lua,350+
  table.insert( achivements,    {"The howling.", "Survive a night with nightwolves", score = 0 } )
  table.insert( achivements,    {"Nightwolf slayer", "Hunter kills a nightwolf", score = 0 } )
  table.insert( achivements,    {"Now you make me mad.","Decend into rioting.", score = 0 } )
  table.insert( achivements,    {"Thriller night", "Everyone becomes a zombie", score = 0 } )
  table.insert( achivements,    {"Epic Hunter", "Hunter kills a nightwolf", score = 0} )
  
end

function check_achivements(a, score) --add to the scrore of a, and if it meants the required score set teh achievement
   
end
