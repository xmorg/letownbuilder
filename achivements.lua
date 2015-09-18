--stuff
achivements = {
  {"Tree Puncher.", "Cut down your first tree.", score=0},
  {"Food horder.", "Collect 100 food.", score = 0 },
  {"Nice buffet", "Have more than 5 types of food", score=0},
  {"Worlds biggest BBQ.", "Barn catches on fire.", score = 0 },
  {"Everybody's dead", "Let everyone die.", score = 0 },
  {"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0 },
  {"Who took my food!?", "Catch a bandit stealing your food.", score = 0 }, --villagers.lua,350+
  {"The howling.", "Survive a night with nightwolves", score = 0 },
  {"Nightwolf slayer", "Hunter kills a nightwolf", score = 0 },
  {"Now you make me mad.","Decend into rioting.", score = 0 },
  {"Thriller night", "Everyone becomes a zombie", score = 0 },
  {"Epic Hunter", "Hunter kills a nightwolf", score = 0}
  }

--achivements = {}

function load_new_achivements()
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

