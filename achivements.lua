--stuff
achivements = {
  {"Tree Puncher", "Cut down your first tree.", score=0, win=1, icon=76},
  {"Food horder", "Collect 100 food.", score = 0, win=100 , icon=77},
  {"Nice buffet", "Have more than 5 types of food", score=0, win=5, icon=78},
  {"Worlds biggest BBQ", "Barn catches on fire.", score = 0, win=1 , icon=4},
  {"Everybody's dead", "Let everyone die.", score = 0, win=1 , icon=5},
  {"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0, win=1, icon=6 },
  {"Who took my food!?", "Catch a bandit stealing your food.", score = 0, win=1 , icon=7}, --villagers.lua,350+
  {"The howling", "Survive a night with nightwolves", score = 0, win=1 , icon=8},
  {"Nightwolf slayer", "Hunter kills a nightwolf", score = 0, win=1 , icon=9},
  {"Now you make me mad","Decend into rioting.", score = 0, win=1 , icon=10},
  {"Thriller night", "Everyone becomes a zombie", score = 0, win=1 , icon=11},
  {"Epic Hunter", "Hunter kills 5 nightwolves", score = 0, win=5, icon=12},
  {"Snake Eater", "Hunter kills 5 snakes", score=0, win=5, icon=13},
  {"Pro logger", "Cut down 100 trees", score=0, win=100, icon=14}
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

function game_achivements_draw() --draw the achivements
   local row = 45
   local col1 = 100
   --big_font = love.graphics.newFont("data/newscycle-bold.ttf", 24 )
   --love.graphics.setFont( big_font )
   love.graphics.setColor(255,255,255,255)--outside white
   love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )
   love.graphics.setColor(30,30,60,255)--inside black
   --love.graphics.rectangle( "fill", 5, 5, love.graphics.getWidth()-10, love.graphics.getHeight()-10 )
   love.graphics.draw(title3,0,0,0, love.graphics.getWidth( )/title3:getWidth(),love.graphics.getHeight( )/title3:getHeight() )
   love.graphics.setColor(255,255,255,255)--white lettering
   love.graphics.setFont( huge_font )
   love.graphics.print("LeTown Builder", col1-2+150, 10-2 )
   love.graphics.setColor(255,255,255,255)--outside white
   love.graphics.setFont( base_font )
   for i,v in ipairs(achivements) do
      if achivements[i].score < achivements[i].win then
	 love.graphics.setColor(80,80,80,255)
      else
	 love.graphics.setColor(255,255,255,255)
      end
      love.graphics.draw(game_icons[achivements[i].icon], 45, i*65) --put the icon
	 love.graphics.setColor(255,255,255,255) --make text white
      love.graphics.print(achivements[i][1], 45+64+5, i*65) --achivement title
      love.graphics.print(achivements[i][2], 45+64+5, i*65+16) --achivement description
   end 
   love.graphics.setColor(255,255,255,255)
end
