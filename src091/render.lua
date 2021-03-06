--move pure drawing functions here :)
require( "achivements" ) --stop the bugs!

--function draw_buttoni(inum, x, y)   
--   love.graphics.draw(game_icons[inum], x, y,
--		      0,
--		      game.button_size / 64,
--		      game.button_size / 64
--   )
--end


function game_achivements_draw() --draw the achivements
   local row = 45
   local col1 = 100
   local acol = 0
   local brow = 0
   love.graphics.setColor(0,0,0)--bg black
   love.graphics.clear( )
   	love.graphics.push()
   love.graphics.setColor(0,5,5,255)--white lettering
   love.graphics.setFont( huge_font )
   --love.graphics.print("LeTown Builder", col1-2+150, 10-2 )
   love.graphics.setColor(255,255,255,255)--outside white
   love.graphics.setFont( base_font )
   love.graphics.draw(ach_button,love.graphics.getWidth( )-64,0) --,0 )--, 0,0 ) -- achivements button
   for i,v in ipairs(achivements) do
   	if i > 7 then acol = 300 brow = -7*65 else acol = 0 brow = 0 end
      if achivements[i].score < achivements[i].win then
	 love.graphics.setColor(80,80,80,255)
      else
	 love.graphics.setColor(255,255,255,255)
      end
      love.graphics.draw(game_icons[achivements[i].icon], 45+acol, i*65+brow) --put the icon
	 love.graphics.setColor(255,255,255,255) --make text white
      love.graphics.print(achivements[i][1], 45+64+5+acol, i*65+brow) --achivement title
      love.graphics.print(achivements[i][2], 45+64+5+acol, i*65+16+brow) --achivement description
   end 
   
   love.graphics.setColor(255,255,255,255)
   love.graphics.pop()
end

function show_tooltop_message()--text, x,y) -- show text on mouseover
   love.graphics.push("all")
   mx = love.mouse.getX()
   my = love.mouse.getY()
   if game.tooltip_text == "NONE" then
      --nothing
      game.tooltip_text = "NONE"
   else
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", mx-100,my, 90, 26) --white rectangle
      love.graphics.setColor(80,80,80,80) --set to gray
      love.graphics.rectangle("fill", mx-100+2,my+2, 90-4, 26-4) --gray rectangle
      love.graphics.push()
      love.graphics.setColor(255,255,255,255)
      love.graphics.print(game.tooltip_text, mx-95,my+3) --print the text on mouse over.
      love.graphics.pop()
      --love.graphics.setColor(255,255,255,255)   
   end
   love.graphics.pop()
end

function display_game_event(mque) --puts a messagebox with a game event of "text"
   --sets a game timer for the messagebox
   love.graphics.setColor(50, 50, 50, 255)
   love.graphics.rectangle("fill", 20, love.graphics.getHeight()-120, 500, 150)
   love.graphics.setColor(150, 150, 150, 255)
   love.graphics.rectangle("fill", 23, love.graphics.getHeight()-117, 494, 144)
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.printf(mque.mtext, 53+64, love.graphics.getHeight()-110 +25, 380, "left")
   --put an icon! (thats really a tile! because we dont know... we need tiles!
   love.graphics.draw(game_icons[mque.micon], 45, love.graphics.getHeight()-110)
end

function set_villager_unrest()
   if get_town_unrest() < 10 then vunrest = "very happy"
      love.graphics.setColor(255,255,255,255)
   elseif get_town_unrest() < 20 then 
      vunrest = "happy"
   elseif get_town_unrest() < 30 then 
      vunrest = "ok"
      love.graphics.setColor(255, 255, 0, 255)
   elseif get_town_unrest() < 40 then 
      vunrest = "grumbling"
   elseif get_town_unrest() < 50 then 
      vunrest = "angry"
      love.graphics.setColor(180, 0, 0, 255)
   elseif get_town_unrest() < 69 then 
      vunrest = "enraged!"
      love.graphics.setColor(255, 0, 0, 255)
   elseif get_town_unrest() >= 70 then 
      love.graphics.setColor(255, 0, 0, 255) 
      vunrest = "rioting!"
   end
   return vunrest
end

function print_talk_text(text, x,y)
   love.graphics.setColor(0,0,0,255) --black
   love.graphics.printf(text, x-1, y+1, 250, "left")
   love.graphics.setColor(255,255,255,255)
   love.graphics.printf(text, x,y,250, "left")   
end

function get_discription_by_directive() --whatever the game.give_direction is, provide an explanation
   if game.give_direction == "Hunt what?" then
      return "find a roaming animal and kill it for food"
   elseif game.give_direction == "Dig where?" then
      return "digs a trench for mine building and stone gathering"
   elseif game.give_direction == "Gather Food" then
      return "Clear tile of vegetation, storing edibles"
   elseif game.give_direction == "Cut where?" then
      return "cut down wooded areas to yield differnt kinds of wood"
   elseif game.give_direction == "Make fire where?" then
      return "provide light, warmth and meat smoking"
   elseif game.give_direction == "Build house" then
      return "Structures provide shelter, and other functions"
   elseif game.give_direction == "Demolish what?" then
      return "Something in your way?"
   else return "none"
      
   end
end

--do squares
function show_job_que()
   love.graphics.push()
   love.graphics.print("Job Queue Debug:", 5, 400 )
   for i,v in ipairs(game_job_que) do
      love.graphics.print(game_job_que[i].job_type.."("..game_job_que[i].timer..")", 5, 400 + (i*20))
   end
   love.graphics.pop()
end

function draw_game_ui()
   local font_row_1 = 3
   local font_row_2 = 20
   local font_row_3 = 37
   love.graphics.setColor(255,255,255,255) --white
   love.graphics.draw(game_icons[60], 0, 0) --?
   love.graphics.print(game.printx.."X"..game.printy, 10, font_row_1)--legacy printxy
   vunrest = set_villager_unrest()
   love.graphics.print("Population: "..table.getn(game_villagers).."/"..kingdom_inventory.families..
   	"   Village Happiness: "..vunrest.."("..(get_town_unrest()*-1)..")", 10, font_row_2) 
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.print(get_discription_by_directive(), 10, 37)
   if kingdom_inventory.hunger > 0 then  love.graphics.setColor(255, 255, 0, 255)
      love.graphics.print("Villagers went hungry today!("..kingdom_inventory.hunger..")", 200, font_row_3)  love.graphics.setColor(255, 255,255, 255)
   end
   if kingdom_inventory.homeless > 0 then
      love.graphics.print(kingdom_inventory.homeless.." villagers are homeless!", 400, font_row_3)
   end
   love.graphics.print(game.give_direction, 100, font_row_1)
   love.graphics.print("Jobs".."("..get_job_count()..")", 250, font_row_1)
   love.graphics.print("Time: "..game.day_count.." D "..math.floor(game.day_time/1000).." hrs", 400, font_row_1 )
   --love.graphics.print("Day "..game.day_count, 550, font_row_1 )
   
   for i,v in ipairs(game_message_que) do -- play messages in order
      if game_message_que[i].mtimer > 0 then
	 display_game_event(game_message_que[i])
	 break -- stop the first time you see one with a timer >0
      end
   end

   --show_job_que()
   if game.show_menu == 99 then
   	love.graphics.setColor(255, 0, 0, 255)
      love.graphics.setFont( big_font )
      love.graphics.print("GAME OVER", 350, 300)
   end
   
   if game.game_paused == 1 then
      love.graphics.setColor(255, 0, 0, 255)
      love.graphics.setFont( big_font )
      love.graphics.print("GAME PAUSED", 350, 300)
   end
   love.graphics.draw(records_button, 600-64, 0) -- QUICK BUTTONS, quick buttons
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

function draw_message_que()
   local mh = 128
   love.graphics.setColor(80,80,80,255)
   love.graphics.rectangle("fill", 64, 64, game.screen_width-128, game.screen_height-54 )
   love.graphics.setColor(100,100,100,255)
   love.graphics.rectangle("fill", 64, 64, game.screen_width-128, 4 ) --top border
   love.graphics.rectangle("fill", 64, 64, 4, game.screen_height-54 ) --leftborder
   love.graphics.rectangle("fill", game.screen_width-68, 64, 4, game.screen_height-54 )--right border
   love.graphics.rectangle("fill", 64, game.screen_height-4, game.screen_width-128, 4 )
   --for i,v in ipairs(game_message_que) do
   for i = 1, table.getn(game_message_que) do -- in reverse!
      love.graphics.printf(game_message_que[table.getn(game_message_que)+1-i].mtime.."      "..game_message_que[i].mtext,
			   73,
			   64+(i*30),
			   600,
			   "left")
   end
end

function draw_farm_garden_additions(x,y, garden_type)
   if research_topics.agriculture > 0 and game_map[y][x] >= 42 and game_map[y][x] <= 46 then
      if research_topics.fences == 1 then
	 love.graphics.draw(tiles_image,game_tiles[ 41], lx+game.draw_x, ly+game.draw_y)--fences
      end
      if research_topics.scarecrow == 1 then
	 love.graphics.draw(tiles_image,game_tiles[ 59 ], lx+game.draw_x, ly+game.draw_y)--scarcrows
      end
   end	
end  --function draw_farm_garden_additions()

function draw_bridge_tiles(x,y)
   if game_map[y][x] == game.bridge_tile1 or game_map[y][x] == game.bridge_tile2 then
      if xdraw == 1 then --draw_x, draw_y,
	 love.graphics.draw(tiles_image,game_tiles[game.water_tile], lx+game.draw_x, ly+game.draw_y, 0, game.zoom_level, game.zoom_level)
      else
	 love.graphics.draw(tiles_image,game_tiles[game.water_tile], lx+game.draw_x, ly+game.draw_y, 0, game.zoom_level, game.zoom_level) 
	 --draw water first, under bridge
      end
   end
end

function draw_mayor_statue(x,y) --statue is 62 male and 63 female
   if game_road_map[y][x] == 68 then --what if its vandalized?
      --first draw the statue (the tile will be drawn later)
      love.graphics.draw(tiles_image,game_tiles[ game.mayor_sex ], lx+game.draw_x, ly+game.draw_y) 
   end
end
function draw_tile_selectors(x,y, lx, ly)
   if x == game.tile_selected_x and y == game.tile_selected_y then
      love.graphics.draw(tiles_image,game_tiles[game.green_selected], lx, ly)
   end --endif
   if x == game_directives.location_x and y == game_directives.location_y then
      love.graphics.draw(tiles_image,game_tiles[game.yellow_selected],lx, ly)
   end --endif
   for i,v in ipairs(game_job_que) do
      if x == game_job_que[i].location_x and y == game_job_que[i].location_y then
	 love.graphics.setColor(0,0,0,255)
	 love.graphics.rectangle("fill",lx, ly, 52,6)
	 love.graphics.setColor(0,255,0,255)
	 love.graphics.rectangle("fill", lx+1, ly+1, ((game_job_que[i].timer_max-game_job_que[i].timer)/game_job_que[i].timer_max)*50, 4 )
	 love.graphics.setColor(255,255,255,255)
	 --love.graphics.rectangle("fill",game_job_que[i].draw_x , game_job_que[i].draw_y+20, 52, 6 )
	 --love.graphics.setColor(0,255,0,255)
	 --love.graphics.rectangle("fill", game_job_que[i].draw_x+1 , game_job_que[i].draw_y+1+20, 
	 ---- lx+game.draw_x+1, ly+game.draw_y-49, 
	 --((game_job_que[i].timer_max-game_job_que[i].timer)/game_job_que[i].timer_max)*50, 4 )
	 --love.graphics.setColor(255,255,255,255)
      end
   end
end

---------------------- DRAW GAME TILES!!!! --------------------------------------
function draw_game_tiles()
   for y = 1, game.tilecount do       --loop y
      for x = 1, game.tilecount do     --loop x
	 local w = game.tilewidth_fx -- width and height of the tiles
	 local h = 100-68	 -- minus dead air
	 local lx = (x - y) * w/2 + game.draw_x
	 local ly = (y + x) * h/2  + game.draw_y
	 ---------- DRAWING TILES ----------------------------------------------
	 if is_night() == 1 then
	    draw_night(y,x)
	 end
	 -- function -----  game tiles map table ---- isometric loc
	 draw_bridge_tiles(x,y) 
	 if game_road_map[y][x] == 1046 and game_map[y][x] == 46 then --tomatoes are full grown
	    love.graphics.draw(tiles_image,game_tiles[ 69 ],  lx, ly) --draw tomatoes not wheat
	 else
	    love.graphics.draw(tiles_image,game_tiles[ game_map[y][x] ], lx, ly) --draw ground tiles
	 end
	 if game_road_map[y][x] > 0 then
	    draw_mayor_statue(x,y)
	    --draw road_map additions
	    if game_road_map[y][x] < 999 then --unrealistic numbers!
	       love.graphics.draw(tiles_image,game_tiles[ game_road_map[y][x] ], lx, ly)
	    end
	 end
	 for i,v in ipairs(game_job_que) do
	    if x == game_job_que[i].location_x and y == game_job_que[i].location_y then
	       love.graphics.draw(tiles_image,game_tiles[game.yellow_selected],lx, ly)
	    end
	 end
	 
	 draw_tile_selectors(x,y,lx,ly) --lx/ly

	 draw_farm_garden_additions(x,y,"wheat") --add zoom
	 if game_fire_map[y][x] == 1 then --FIRE!
	    love.graphics.draw(tiles_image,game_tiles[math.random(48,50)], lx+game.draw_x, ly+game.draw_y)
	 end
	 for i,v in ipairs(game_job_que) do
	    --	love.graphics.print(game_job_que[i].job_type.."("..game_job_que[i].timer..")", 5, 400 + (i*20))
	    if game_job_que[i].location_x == x and game_job_que[i].location_y == y then
	       game_job_que[i].draw_x = lx+game.draw_x
	       game_job_que[i].draw_y = ly+game.draw_y-30 --set the locs
	    end
	 end
      end --endfor x
   end --endfor y

--   function new_job()
--      a = {
--	 timer = game_directives.timer,
--	 timer_max = game_directives.timer,
--	 location_x = game_directives.location_x, --tile loc x/y
--	 location_y = game_directives.location_y,
--	 draw_x = 0,
--	 draw_y = 0,
--	 job_type = game_directives.job_type
   --}
   --   return a
   --end
   
   
   --draw the job status bars.
   --love.graphics.push()
   --for i,v in ipairs(game_job_que) do
  -- 	love.graphics.setColor(0,0,0,255)
--	love.graphics.rectangle("fill",game_job_que[i].draw_x , game_job_que[i].draw_y+20, 52, 6 )
--	love.graphics.setColor(0,255,0,255)
--	love.graphics.rectangle("fill", game_job_que[i].draw_x+1 , game_job_que[i].draw_y+1+20, 
--		-- lx+game.draw_x+1, ly+game.draw_y-49, 
--		((game_job_que[i].timer_max-game_job_que[i].timer)/game_job_que[i].timer_max)*50, 4 )
--	love.graphics.setColor(255,255,255,255)
  -- end
   --love.graphics.pop()
end --end draw_game_tiles()

function draw_roster_list_food()
   love.graphics.setFont( base_font )
   love.graphics.print("Food       Type           Stored in         Disease Chance", col_one, 20+88)
   row_num = row_num + 1
   love.graphics.print("---------------------------------------------------------------------------", col_one, 20+95)
   love.graphics.print("Seeds ("..kingdom_inventory.seeds..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Carrots ("..kingdom_inventory.carrots..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Sansai ("..kingdom_inventory.sansai..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Mushrooms ("..kingdom_inventory.mushrooms..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Fish ("..kingdom_inventory.fish..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Smoked Fish ("..kingdom_inventory.smoked_fish..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Grain ("..kingdom_inventory.grain..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Cherries ("..kingdom_inventory.cherries..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Raw Meat ("..kingdom_inventory.raw_meat..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Smoked Meat ("..kingdom_inventory.smoked_meat..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Desert Onions ("..kingdom_inventory.desert_onions..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Apples ("..kingdom_inventory.apples..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Tomatos ("..kingdom_inventory.tomatoes..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Saltwort ("..kingdom_inventory.saltwort..")", col_one, row_num *20+88)row_num = row_num + 1
end

--new code to put message list in roster/records
function draw_roster_list_mque()
   love.graphics.setFont( base_font )
   love.graphics.print("Messages", col_one, 20+88)
   row_num = row_num + 1
   love.graphics.print("------------------------------------------------", col_one, 20+95)
   love.graphics.setColor(255,255,255,255)
   for i,v in ipairs(game_message_que) do
      for i = 1, table.getn(game_message_que) do -- in reverse!
	 love.graphics.printf(game_message_que[table.getn(game_message_que)+1-i].mtime.."      "..game_message_que[i].mtext, 73, 120+(i*30), 600, "left")
      end
   end
end

function draw_policies_list() --draw mayors policies
	
end
function draw_roster_list_resources()
   love.graphics.setFont( base_font )
   love.graphics.print("Resource       Type           Stored in        Value", col_one, 20+88)
   row_num = row_num + 1
   love.graphics.print("----------------------------------------------------------------", col_one, 20+95)
   row_num = row_num + 1
   love.graphics.print("Wood ("..kingdom_inventory.wood..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Sakura ("..kingdom_inventory.sakura..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Bamboo ("..kingdom_inventory.bamboo..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Stone ("..kingdom_inventory.rocks..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Sandstone ("..kingdom_inventory.sandstone..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Iron Ore ("..kingdom_inventory.iron_ore..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Iron Ingots ("..kingdom_inventory.iron_ingots..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Gold Ore ("..kingdom_inventory.gold_ore..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Gold Ingots ("..kingdom_inventory.gold_ingots..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Pelts ("..kingdom_inventory.pelts..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Weapons ("..kingdom_inventory.weapons..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Tools ("..kingdom_inventory.tools..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Gold Treasures ("..kingdom_inventory.gold_treasures..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Iron Treasures ("..kingdom_inventory.iron_treasures..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Gold Coins ("..kingdom_inventory.gold_coins..")", col_one, row_num *20+88)row_num = row_num + 1
   love.graphics.print("Iron Coins ("..kingdom_inventory.iron_coins..")", col_one, row_num *20+88)row_num = row_num + 1
end

function draw_roster_list_villagers()
   love.graphics.setFont( base_font )
   love.graphics.print("Villager       Gender           Type             Occupation       Opinion", col_one, 20+88)
   row_num = row_num + 1
   love.graphics.print("---------------------------------------------------------------------------------------------------", col_one, 20+95)
   row_num = row_num + 1
   for i, v in ipairs(game_villagers) do
      draw_small_sprite(game_villagers[i].sprite, col_one, row_num * 20+88) --draw the villager
      love.graphics.print(game_villagers[i].name, col_one+20, row_num * 20+84) --print their name
      if game_villagers[i].sex == 0 then  --print the sex
	 love.graphics.print("female".."("..game_villagers[i].age..")", col_two, row_num * 20+84)
      else
	 love.graphics.print("male".."("..game_villagers[i].age..")", col_two,  row_num * 20+84)
      end
      if game_villagers[i].villager_type == "werewolf" then
	 love.graphics.print("normal", col_three, row_num * 20+84)
      else
	 love.graphics.print(game_villagers[i].villager_type, col_three, row_num * 20+84)
      end
      love.graphics.print(game_villagers[i].position, col_four, row_num * 20+84)
      love.graphics.print(game_villagers[i].opinion, col_five, row_num * 20+84)
      row_num = row_num+1   
   end
end

function draw_roster_list()
   --love.graphics.draw(game_icons[icon_num], x, y)
   love.graphics.setColor(80,80,80,255)
   love.graphics.rectangle("fill", 64, 64, game.screen_width-128, game.screen_height-54 )
   love.graphics.setColor(100,100,100,255)
   love.graphics.rectangle("fill", 64, 64, game.screen_width-128, 4 ) --top border
   love.graphics.rectangle("fill", 64, 64, 4, game.screen_height-54 ) --leftborder
   love.graphics.rectangle("fill", game.screen_width-68, 64, 4, game.screen_height-54 )--right border
   love.graphics.rectangle("fill", 64, game.screen_height-4, game.screen_width-128, 4 )
   col_one = 80
   col_two = 160
   col_three = 240
   col_four = 328
   col_five = 428
   row_num = 1
	if game.records_tab == 1 then b_villagers = 100 else b_villagers = 0 end
	if game.records_tab == 2 then b_food = 100 else b_food = 0 end
	if game.records_tab == 3 then b_resources = 100 else b_resources = 0	end	
	if game.records_tab == 4 then b_messages = 100 else b_messages = 0 end
	
	love.graphics.setColor(50+b_villagers,80,80,255)
	love.graphics.rectangle("fill", col_one-3, 20+68, 60, 23 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Villagers", col_one, 20+68)
	
	love.graphics.setColor(50+b_food,80,80,255)
	love.graphics.rectangle("fill", col_two-3, 20+68, 60, 23 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Food", col_two, 20+68)
	
	love.graphics.setColor(50+b_resources,80,80,255)
	love.graphics.rectangle("fill", col_three-3, 20+68, 60, 23 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Resources", col_three, 20+68)

	love.graphics.setColor(50+b_messages,80,80,255)
	love.graphics.rectangle("fill", col_four-3, 20+68, 60, 23 )
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Messages", col_four, 20+68)
	
	--set font size
	--base_font
	if game.records_tab == 1 then 
	   draw_roster_list_villagers()
	elseif game.records_tab == 2 then
	   draw_roster_list_food()
	elseif game.records_tab == 3 then 
	   draw_roster_list_resources()
	elseif game.records_tab == 4 then
	   draw_roster_list_mque()
	end
end

function draw_inventory_numbers() --erased lot of code
   --draw numbers only.
   love.graphics.print(kingdom_inventory.wood, love.graphics.getWidth()-50, 16)
   love.graphics.print(kingdom_inventory.sakura, love.graphics.getWidth()-24, 16)

   love.graphics.print(kingdom_inventory.bamboo, love.graphics.getWidth()-24, 32+16)
   love.graphics.print(kingdom_inventory.rocks, love.graphics.getWidth()-50, 32+16)

   love.graphics.print(kingdom_inventory.fish+kingdom_inventory.smoked_fish, love.graphics.getWidth()-50, 64+16)
   love.graphics.print(kingdom_inventory.iron_ore, love.graphics.getWidth()-24, 64+16)

   love.graphics.print(kingdom_inventory.cherries, love.graphics.getWidth()-50, 96+16)
   love.graphics.print(kingdom_inventory.gold_ore, love.graphics.getWidth()-24, 96+16)

   love.graphics.print(kingdom_inventory.carrots, love.graphics.getWidth()-50, 128+16)
   love.graphics.print(kingdom_inventory.iron_ingots, love.graphics.getWidth()-24, 128+16)

   --love.graphics.print(kingdom_inventory.carrots, love.graphics.getWidth()-50, 160+16)
   --love.graphics.print(kingdom_inventory.iron_ingots, love.graphics.getWidth()-24, 160+16)

   love.graphics.print(kingdom_inventory.tomatoes, love.graphics.getWidth()-50, 160+16)
   love.graphics.print(kingdom_inventory.gold_ingots, love.graphics.getWidth()-24, 160+16)

   love.graphics.print(kingdom_inventory.raw_meat+kingdom_inventory.smoked_meat, love.graphics.getWidth()-50, 192+16)
   love.graphics.print(kingdom_inventory.grain, love.graphics.getWidth()-24, 192+16)

   love.graphics.print(kingdom_inventory.sansai+kingdom_inventory.smoked_meat, love.graphics.getWidth()-50, 224+16)
   love.graphics.print(kingdom_inventory.apples, love.graphics.getWidth()-24, 224+16)

   love.graphics.print(kingdom_inventory.fishwine, love.graphics.getWidth()-50, 256+16)
   love.graphics.print(kingdom_inventory.paleale, love.graphics.getWidth()-24, 256+16)

   love.graphics.print(kingdom_inventory.sandstone, love.graphics.getWidth()-50, 256+16+32)
   love.graphics.print(kingdom_inventory.desert_onions, love.graphics.getWidth()-24, 256+16+32)
   
   love.graphics.print(kingdom_inventory.seeds, love.graphics.getWidth()-50, 256+16+64)
   love.graphics.print(kingdom_inventory.pelts, love.graphics.getWidth()-24, 256+16+64)
   
   love.graphics.print(kingdom_inventory.tools, love.graphics.getWidth()-50, 256+16+64+32)
   love.graphics.print(kingdom_inventory.weapons, love.graphics.getWidth()-24, 256+16+64+32)
   
   love.graphics.print(kingdom_inventory.gold_treasures+kingdom_inventory.iron_treasures, love.graphics.getWidth()-50, 256+16+64+64)
   love.graphics.print(kingdom_inventory.gold_coins+kingdom_inventory.iron_coins, love.graphics.getWidth()-24, 256+16+64+64)
   
   love.graphics.print(kingdom_inventory.mushrooms, love.graphics.getWidth()-50, 256+16+64+64+32)
   --love.graphics.print(kingdom_inventory.coinds, love.graphics.getWidth()-24, 256+16+64+64)
   
end--draw_inventory_icons()
function draw_resource_bar() --replace draw_inventory_icons()
   love.graphics.draw(resource_bar, love.graphics.getWidth()-64, 0)
   --love.graphics.draw(records_button, 300, 0)
   draw_inventory_numbers()
end



function draw_research_icons()
   local bs = 92 --game.button_size
   if get_kingdom_researchable() == 1 then
      if game.research_timer == 0 then
	 quick_task_icon64(0, bs*5, 30, "Research", 0, "game_icons")
      else
	 love.graphics.print("Researching".."("..game.research_timer..")", 5, bs*5  )
      end
   end
   --quick_task_icon64(x, y, icon, text, blankicon, tileset)
   --quick_task_icon64(bs*3,bs, 27, "Garden", 0, "game_icons")
   if game.give_direction == "Research" then
      local ybutton_level = bs*5+40
      --love.graphics.draw(game_icons[63],  0+bs, bs*5) --research economy!
      quick_task_icon64(0+bs, bs*5, 63, "Economy("..research_topics.economy..")", 0, "game_icons")
      quick_task_icon64(0+bs*2, bs*5, 64, "Security("..research_topics.security..")", 0, "game_icons")
      quick_task_icon64(0+bs*3, bs*5, 65, "Agriculture("..research_topics.agriculture..")", 0, "game_icons")
      quick_task_icon64(0+bs*4, bs*5, 66, "Civics("..research_topics.civics..")", 0, "game_icons")
      quick_task_icon64(0+bs*5, bs*5, 28, "Industry("..research_topics.industry..")", 0, "game_icons")
      --love.graphics.print("Lv "..research_topics.economy, bs+5, ybutton_level  )
      --love.graphics.draw(game_icons[64],  bs*2, bs*5) --research Security!
      --love.graphics.print("Security", 5+bs+bs, bs*5  )
      --love.graphics.print("Lv "..research_topics.security, bs+bs+5, ybutton_level  )
      --love.graphics.draw(game_icons[65],  bs*3, bs*5) --research Agriculture!
      --love.graphics.print("Agriculture", bs*3+5, bs*5  )
      --love.graphics.print("Lv "..research_topics.agriculture, bs*3+5, ybutton_level  )
      --love.graphics.draw(game_icons[66], bs*4, bs*5) --research civics!		
      --love.graphics.print("Civics", bs*4+5, bs*5  )
      --love.graphics.print("Lv "..research_topics.civics, bs*4+5, ybutton_level  ) 
      --love.graphics.draw(game_icons[66], bs*5, bs*5) --research industry!		
      --love.graphics.print("Industry", bs*5+5, bs*5  )
      --love.graphics.print("Lv "..research_topics.industry, bs*5+5, ybutton_level  ) 
   end
end

function draw_small_sprite(spritenum, x,y)
   if g_version == "0.9.0" then
      love.graphics.draw(sprite_files, game_sprites_table[spritenum], x, y)
   else
      love.graphics.drawq(sprite_files, game_sprites_table[spritenum], x, y)
   end
end
function draw_projectile_sprite(spritenum, x,y)
   if g_version == "0.9.0" then
      love.graphics.draw(projectile_files, game_psrites_table[spritenum], x, y)
   else
      love.graphics.drawq(projectile_files, game_psrites_table[spritenum], x, y)
   end
end

function draw_wildlife()
   for i,v in ipairs(game_wildlife) do
      if game_wildlife[i].alive == 1 then
	 dead_flag = 0
      else
	 dead_flag = 1
      end
      -------INSERT NEW CODE HERE.
      draw_small_sprite(game_wildlife[i].sprite, game_wildlife[i].x +game.draw_x, game_wildlife[i].y +game.draw_y)
      if game_wildlife[i].alive == 0 then
      	--fixed zombie bug, in the future each wl should have their own dead sprite.
	 draw_small_sprite(game_wildlife[i].dead_sprite, game_wildlife[i].x +game.draw_x,game_wildlife[i].y +game.draw_y)
      end
      if kingdom_inventory.watchtower > 0 then
	 if game_wildlife[i].wildlife_type == "copperhead" or
	    game_wildlife[i].wildlife_type == "bear" or
	 game_wildlife[i].wildlife_type == "black bear" then
	    love.graphics.setColor(200, 0, 0, 255)
	 else
	    love.graphics.setColor(170,170,0,255)
	 end
	 love.graphics.printf("-"..game_wildlife[i].wildlife_type.."-",
			 game_wildlife[i].x+game.draw_x- 10,
			 game_wildlife[i] .y+game.draw_y -20,
			 250, "left")
	 love.graphics.setColor(255,255,255,255)
      end--endif
   end--endfor
   --if is_night() == 1 then
   	draw_nightwolves() --draw them at night?
   --end
end

function draw_night(y, x)  --code for night and fire glow
   function is_lighted(lighty,lightx)
      if (lighty > 0 and lighty < game.tilecount and lightx > 0 and lightx < game.tilecount) and
	 (game_fire_map[lighty][lightx] == 1 or
	  game_road_map[lighty][lightx] == 65 ) then
	 return 1
      end
   end
      
   if is_lighted(y,x) == 1 then
      love.graphics.setColor(255,255,255,255)
   elseif is_lighted(y,x+1)  == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y,x-1)  == 1 then
      love.graphics.setColor(200,200,200,255)      
   elseif is_lighted(y+1, x) == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y-1, x)  == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y-1,x-1) == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y+1,x+1) == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y+1,x-1) == 1 then 
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y-1,x+1) == 1 then
      love.graphics.setColor(200,200,200,255)
   elseif is_lighted(y,x+2) == 1 then
      love.graphics.setColor(150,150,150,255)
   elseif is_lighted(y,x-2) == 1 then 
      love.graphics.setColor(150,150,150,255)
   elseif is_lighted(y+2,x) == 1 then 
      love.graphics.setColor(150,150,150,255)
   elseif is_lighted(y-2,x) == 1 then
      love.graphics.setColor(150,150,150,255)
   elseif is_lighted(y,x+3) == 1 then
      love.graphics.setColor(100,100,100,255)
   elseif is_lighted(y,x-3) == 1 then
      love.graphics.setColor(150,150,100,255)
   elseif is_lighted(y+3,x) == 1 then
      love.graphics.setColor(100,100,100,255)
   elseif is_lighted(y-3,x) == 1 then
      love.graphics.setColor(100,100,100,255)		
   else
      love.graphics.setColor(50,50,50,255)
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
	 ghostblit_x = game_villagers[i].x+game.draw_x
	 ghostblit_y = game_villagers[i].y+game.draw_y
      else
	 blit_x = game_villagers[i].x+game.draw_x
	 blit_y = game_villagers[i].y+game.draw_y
	end

	if game_villagers[i].selected == 1 then
		love.graphics.setColor(0,0,255,100)
		love.graphics.circle("fill", game_villagers[i].x+5+game.draw_x, 
			game_villagers[i].y+5+game.draw_y, 12, 8); 
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(game_villagers[i].name, game_villagers[i].x+game.draw_x, 
			game_villagers[i].y+game.draw_y-70)
	end
      if game_villagers[i].alive == 0 and is_night() == 1 and (kingdom_inventory.graveyards < 1 
      	or (kingdom_inventory.deadvillagers > kingdom_inventory.graveyards *3 ) )then -- no graveyards or 2 few graveyards.
	 --{"G-g-g-ghost!", "Spot a departed loved one at night.", score = 0, win=1, icon=6 },
	 update_achivements("G-g-g-ghost!", 1)
	 local ghost_flip = math.random(1,5)
	 love.graphics.setColor(150,255,255,255)
	 if ghost_flip == 1 then
	    draw_small_sprite(13, ghostblit_x, ghostblit_y)
	 else
	    draw_small_sprite(14, ghostblit_x, ghostblit_y)
	 end
	 love.graphics.setColor(0,0,0,255)
      end
      if game_villagers[i].alive == -1 then --zombie?
	 draw_small_sprite(37, blit_x, blit_y)
      elseif game_villagers[i].villager_type == "werewolf" and is_night() == 1 then
	 if game_villagers[i].alive == 1 then
	    draw_small_sprite(11, blit_x, blit_y)
	 else
	    draw_small_sprite(12, blit_x, blit_y)
	 end
      elseif game_villagers[i].position == "sheriff" and game_villagers[i].alive == 1 then
	 draw_small_sprite(25, blit_x, blit_y)
      elseif game_villagers[i].position == "militia captain" and game_villagers[i].alive == 1 then
	 draw_small_sprite(19, blit_x, blit_y)
      elseif game_villagers[i].alive == 0 then --draw a dead.
	 draw_small_sprite(game_villagers[i].dead_sprite, blit_x, blit_y)
      else
	 draw_small_sprite(game_villagers[i].sprite, blit_x, blit_y)
      end
      if game_villagers[i].talk_timer > 0 then --Need to setup this.
	 love.graphics.setColor(255,255,255,255)
	 if game_villagers[i].villager_type == "werewolf" and is_night() == 1 then
	    print_talk_text("???"..": "..talk_topics_werewolf[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif game.earthquake == 1 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_earthquake[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x -10, game_villagers[i].y+game.draw_y -20)
	 elseif game_villagers[i].disease ~= "healthy" then
	    print_talk_text(game_villagers[i].name..": "..plague_topics_allday[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif game_villagers[i].alive == 0 and kingdom_inventory.graveyards < 1 and is_night() == 1 then
	    print_talk_text(game_villagers[i].name..": "..ghost_topics_allnight[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif game_villagers[i].position == "sheriff" then
	    print_talk_text("Sheriff "..game_villagers[i].name..": "..sheriff_topics_allday[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif game_villagers[i].villager_type == "holyman" then
	    print_talk_text("Holyman "..game_villagers[i].name..": "..talk_topics_holyman[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -2)
	 elseif get_town_unrest() < 10 and is_night() == 0 then 
	    print_talk_text(game_villagers[i].name..": "..talk_topics_happy[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif get_town_unrest() < 10 and is_night() == 1 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_happynight[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -2)
	 elseif get_town_unrest() < 20 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_happy[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif get_town_unrest() < 30 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_ok[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif get_town_unrest() < 40 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_grumbling[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif get_town_unrest() < 50 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_angry[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20 -20)
	 elseif get_town_unrest() < 69 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_angry[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 elseif get_town_unrest() >= 70 then
	    print_talk_text(game_villagers[i].name..": "..talk_topics_riot[game_villagers[i].speak], 
			    game_villagers[i].x+game.draw_x- 10, game_villagers[i].y+game.draw_y -20)
	 end
      elseif kingdom_inventory.watchtower > 0 then
	 print_talk_text(">"..game_villagers[i].name.."<", game_villagers[i].x+game.draw_x- 10, 
			 game_villagers[i].y+game.draw_y -20)
      end--endif
   end--endfor
end

function quick_task_icon64(x, y, icon, text, blankicon, tileset)
   if blankicon == 1 then
      love.graphics.draw(game_icons[blank_icon], x, y, 0,game.button_size / 64, game.button_size / 64)
   end
   if tileset == "game_tiles" then
      love.graphics.draw(tiles_image, game_tiles[icon], x, y-32, 0,game.button_size / 64, game.button_size / 64)
   else
      love.graphics.draw(game_icons[icon], x, y, 0, game.button_size / 64, game.button_size / 64)
   end
   love.graphics.print(text, x+3, y+ (game.button_size/ (game.button_size/4)))
end

function draw_select_house_to_build()
   local bs = game.button_size
   if game.give_direction == "Select house to build" then
      local xi = 1
      local row_2 = bs * 4 --game.button_size*4
      local row_3 = bs * 5 --game.button_size*5
      local row_2_xi = 1
      
      quick_task_icon64(bs*1,bs*3, 23, "house", 1, "game_tiles")
      quick_task_icon64(bs*2,bs*3, 24, "house", 1, "game_tiles")
      quick_task_icon64(bs*3,bs*3, 25, "house", 1, "game_tiles")
      quick_task_icon64(bs*4,bs*3, 26, "house", 1, "game_tiles")
      quick_task_icon64(bs*5,bs*3, 27, "mine", 1, "game_tiles")
      quick_task_icon64(bs*6,bs*3, 51, "school", 1, "game_tiles")
      quick_task_icon64(bs*7,bs*3, 52, "barn", 1, "game_tiles")
      quick_task_icon64(bs*8,bs*3, 53, "graveyard", 1, "game_tiles")
      
      --row 2
      if research_topics.economy >= 1 then quick_task_icon64(         bs*1,bs*4, 66, "trade post", 1, "game_tiles") end
      if research_topics.security >= 1 then quick_task_icon64(        bs*2,bs*4, 67, "sheriff", 1, "game_tiles") end
      if research_topics.industry >= 1 then quick_task_icon64(        bs*3,bs*4, 55, "fish hut", 1, "game_tiles") end
      if research_topics.militia_house >= 1 then quick_task_icon64(   bs*4,bs*4, 60, "militia", 1, "game_tiles") end
      if research_topics.mayors_monument >= 1 then quick_task_icon64( bs*5,bs*4, game.mayor_sex, "monument", 1, "game_tiles") end
      if research_topics.watchtower >= 1 then quick_task_icon64(      bs*6,bs*4, 65, "watchtower", 1, "game_tiles") end
      if research_topics.smelter >= 1 then quick_task_icon64(         bs*7,bs*4, 70, "smelter", 1, "game_tiles") end
      if research_topics.brewery >= 1 then quick_task_icon64(         bs*8,bs*4, 71, "brewery", 1, "game_tiles") end
      --row 3 ---
      if research_topics.smithy >= 1 then quick_task_icon64(          bs*1,bs*5, 64, "smithy", 1, "game_tiles") end
      if research_topics.church >= 1 then quick_task_icon64(          bs*2,bs*5, 72, "church", 1, "game_tiles") end --TODO change icon
   end
end

function draw_task_icons()
   bs = game.button_size
   love.graphics.setColor(255,255,255,255)
   quick_task_icon64(0,bs*1, 9, "Labor", 0, "game_icons")
   quick_task_icon64(0,bs*2, 40, "Gather Food", 40, "game_icons")
   quick_task_icon64(0,bs*3,  2, "Build", 0, "game_icons")
   if game.give_direction == "Select job" then
      quick_task_icon64(bs*1,bs, game.axe_icon, "Cut trees", 0, "game_icons")
      quick_task_icon64(bs*2,bs, game.shovel_icon, "Dig hole", 0, "game_icons")
      quick_task_icon64(bs*3,bs, 27, "Garden", 0, "game_icons")
      quick_task_icon64(bs*4,bs, 73, "Hunt", 0, "game_icons")
      quick_task_icon64(bs*5,bs, 55, "Fire", 0, "game_icons")
      quick_task_icon64(bs*6,bs, 69, "Demolish", 0, "game_icons")
      if research_topics.militia_house > 0 then
	 quick_task_icon64(bs*7,bs, 88, "Militia", 0, "game_icons")
      end
      if research_topics.tomatoes == 1 then
	 quick_task_icon64(bs*7,bs, 4, "Tomatoes", 0, "game_icons")    -- change mouse click.
      end
   end
   --love.graphics.print("Build", 5, bs*3  )
   draw_select_house_to_build()
   quick_task_icon64(0, bs*4, 54, "Build Roads", 0, "game_icons")--love.graphics.draw(game_icons[54],  0, bs*4) --build roads
   --love.graphics.print("Build Roads", 5, bs*4  )
   if game.give_direction == "Select road to build" then
      quick_task_icon64(bs*1,bs*3+40, 28, "road", 1, "game_tiles")
      quick_task_icon64(bs*2,bs*3+40, 29, "road", 1, "game_tiles")
      quick_task_icon64(bs*3,bs*3+40, 30, "road", 1, "game_tiles")
      quick_task_icon64(bs*4,bs*3+40, 31, "road", 1, "game_tiles")
      quick_task_icon64(bs*5,bs*3+40, 32, "road", 1, "game_tiles")
      quick_task_icon64(bs*6,bs*3+40, 33, "road", 1, "game_tiles")
      quick_task_icon64(bs*7,bs*3+40, 34, "road", 1, "game_tiles")
      quick_task_icon64(bs*8,bs*3+40, 35, "road", 1, "game_tiles")
      quick_task_icon64(bs*9,bs*3+40, 36, "road", 1, "game_tiles")
      quick_task_icon64(bs*1,bs*4+40, 21, "road", 1, "game_tiles")
      quick_task_icon64(bs*2,bs*4+40, 22, "road", 1, "game_tiles")
   end
end

function draw_weather(w)
   --love.graphics.getWidth(), love.graphics.getHeight()
   sw = love.graphics.getWidth()
   sh = love.graphics.getHeight()
   if w == 1 then
      f = math.random(180,185)
      love.graphics.setColor(f,f,f,100)
      love.graphics.rectangle("fill", 0, 0, sw, sh ) --top border
   end
   if w > 10 and w < 14 then
      love.graphics.draw(weather_image,weather_quads[1],  math.random(1,sw), math.random(1, sh) )
   end
   if w > 11 and w < 14 then 
      love.graphics.draw(weather_image,weather_quads[1],  math.random(1,sw), math.random(1, sh) )
      love.graphics.draw(weather_image,weather_quads[1],  math.random(1,sw), math.random(1, sh) )
   end
   if w > 12 and w < 14 then
      love.graphics.draw(weather_image,weather_quads[1],  math.random(1,sw), math.random(1, sh) )
      love.graphics.draw(weather_image,weather_quads[1],  math.random(1,sw), math.random(1, sh) )
   end
   if w >= 14 then
      love.graphics.draw(weather_image,weather_quads[2],  math.random(1,sw), math.random(1, sh) )
   end
   if w == 15 then
      love.graphics.draw(weather_image,weather_quads[2],  math.random(1,sw), math.random(1, sh) )
      love.graphics.draw(weather_image,weather_quads[2],  math.random(1,sw), math.random(1, sh) )
      love.graphics.draw(weather_image,weather_quads[2],  math.random(1,sw), math.random(1, sh) )
   end
   --sweltering color? 255,216,34
   if w == 8 then
      love.graphics.setColor(255,216,34,100)
      love.graphics.rectangle("fill", 0, 0, sw, sh ) --top border
   end
end



