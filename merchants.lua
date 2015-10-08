--merchant_arrived = 0, --if to draw merchants
--trading_timer = 0, -- how long they stay at the post
--merchant_spawn_x=0, merchant_spawn_y=0 --start location of current merchants(randomly set on arrival)

game_merchants = {}
lookup_table = {"wood", "sakura", "bamboo", "carrots", "sansai", 
	"raw_meat", "smoked_meat", "tomatoes", "saltwort",
	"mushrooms", "fish", "smoked_fish", "grain", "cherries", 
	"fishwine", "paleale", "apples", "desert onions", 
	"rocks", "iron_ore", "rocksalt", "sandstone", 
	"tools", "weapons", "pelts", "seeds", 
	"gold treasures", "iron treasures", "gold coins", "iron coins",
	"iron_ingots", "gold_ore", "gold_ingots",
	"women",
	"men" }
price_table = {1, 1, 1, 1, 1, 
	2, 3, 5, 2,
	2, 4, 7, 5, 7, 
	10, 9, 10, 1, 
	1, 4, 5, 1, 
	20, 25, 70, 1, 
	240, 25, 110, 20,
	10, 50, 100,
	1500,
	2500 }
merchant_inventory = { --only includes tradeable items.
	wood = 0, sakura = 0, bamboo = 0, carrots = 0, sansai = 0,
	raw_meat =0, smoked_meat = 0, tomatoes = 0, saltwort = 0,
	mushrooms = 0, fish = 0, smoked_fish = 0, grain = 0, cherries = 0,
	fishwine = 0, paleale=0, apples = 0, desert_onions = 0,
	rocks = 0, iron_ore = 0, rocksalt = 0, sandstone = 0,
	tools = 2, weapons = 0, pelts = 0, seeds = 0, 
	gold_treasures=0, iron_treasures=0, gold_coins=0, iron_coins=0,
	iron_ingots = 0, gold_ore = 0, gold_ingots = 0,
   women = 0,
   men = 0
}
function show_transaction_menu() --allows you to choose what you are selling.
	local tx = 64	local ty = 64
	local tsx = 500	local tsy = 400
	local townframe_x = 200 local townframe_y = 350
	local merchantframe_x = 200 local merchantframe_y = 350
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", tx, ty, tsx, tsy ) --make a white rectangle
	love.graphics.setColor(80,80,80,255)
	love.graphics.rectangle("fill", tx+2, ty+2, tsx-2, tsy-2 ) --make a grey rectangle
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill", tx+10, ty+10, townframe_x, townframe_y) --town window
	love.graphics.rectangle("fill", tx+10+townframe_x+10, ty+10, townframe_x, townframe_y) --merchants window
	--now list the town items at tx+10
	for i,v in ipairs(lookup_table) do
		love.graphics.print(lookup_table[i].." (", --..kingdom_inventory[i]..")",
			tx+10,ty+10)
	end
	for i,v in ipairs(lookup_table) do
		love.graphics.print(lookup_table[i].." ("..merchant_inventory[i]..")",
			tx+10+townframe_x+10,ty+10) --merchants window
	end	--now list the merchant items at x+10+townframe_x+10
end
function add_merchant_inventory()
   merchant_inventory.wood = math.random(0,50)
   merchant_inventory.sakura = math.random(0,50)
   merchant_inventory.bamboo = math.random(0,50)
   merchant_inventory.carrots = math.random(0,50)
   merchant_inventory.sansai = math.random(0,50)
   merchant_inventory.raw_meat = math.random(0,50)
   merchant_inventory.smoked_meat = math.random(0,50)
   merchant_inventory.tomatoes = math.random(0,50)
   merchant_inventory.mushrooms = math.random(0,50)
   merchant_inventory.fish = math.random(0,50)
   merchant_inventory.smoked_fish = math.random(0,50)
   merchant_inventory.grain = math.random(0,50)
   merchant_inventory.cherries = math.random(0,50)
   merchant_inventory.fishwine = math.random(0,50)
   merchant_inventory.paleale=math.random(0,50)
   merchant_inventory.rocks = math.random(0,50)
   merchant_inventory.iron_ore = math.random(0,50)
   merchant_inventory.iron_ingots = math.random(0,50)
   merchant_inventory.gold_ore = math.random(0,50)
   merchant_inventory.gold_ingots = math.random(0,50)
   merchant_inventory.women = math.random(0,50)
   merchant_inventory.men = math.random(0,50)
end
function remove_merchant_inventory()
   merchant_inventory.wood = 0
   merchant_inventory.sakura = 0
   merchant_inventory.bamboo = 0
   merchant_inventory.carrots = 0
   merchant_inventory.sansai = 0
   merchant_inventory.raw_meat = 0
   merchant_inventory.smoked_meat = 0
   merchant_inventory.tomatoes = 0
   merchant_inventory.mushrooms = 0
   merchant_inventory.fish = 0
   merchant_inventory.smoked_fish = 0
   merchant_inventory.grain = 0
   merchant_inventory.cherries = 0
   merchant_inventory.fishwine = 0
   merchant_inventory.paleale=0
   merchant_inventory.rocks = 0
   merchant_inventory.iron_ore = 0
   merchant_inventory.iron_ingots = 0
   merchant_inventory.gold_ore = 0
   merchant_inventory.gold_ingots = 0
   merchant_inventory.women = 0
   merchant_inventory.men = 0
end

function report_trading_done()
   --random trades!  t["foo"]
   local towntrade1 = lookup_table[math.random(1,20)]
   local towntrade2 = lookup_table[math.random(1,20)]
   local towntrade3 = lookup_table[math.random(1,20)]
   local merchanttrade1 = lookup_table[math.random(1,20)]
   local merchanttrade2 = lookup_table[math.random(1,20)]
   local merchanttrade3 = lookup_table[math.random(1,20)] --Should have fixed the nil bug.
   
   if kingdom_inventory[towntrade1] > 0 and merchant_inventory[merchanttrade1] > 0 then
      --do a trade.
      local k = kingdom_inventory[towntrade1]
      local m = merchant_inventory[merchanttrade1]
      kingdom_inventory[towntrade1] = kingdom_inventory[towntrade1]- math.random(1,k) --remove items
      kingdom_inventory[merchanttrade1] = kingdom_inventory[merchanttrade1]+math.random(1,m)--add items
      message_que_add("Your merchants traded ".. k .. " units of " .. towntrade1 .. " for "..m.." units of "..merchanttrade1, 100, 1)
   end
   if kingdom_inventory[towntrade2] > 0 and merchant_inventory[merchanttrade2] > 0 then
      --do a trade.
      local k = kingdom_inventory[towntrade2]
      local m = merchant_inventory[merchanttrade2]
      kingdom_inventory[towntrade2] = kingdom_inventory[towntrade2]- math.random(1,k) --remove items
      kingdom_inventory[merchanttrade2] = kingdom_inventory[merchanttrade2]+math.random(1,m)--add items
      message_que_add("Your merchants traded ".. k .. " units of " .. towntrade2 .. " for "..m.." units of "..merchanttrade2, 100, 1)
   end
   if kingdom_inventory[towntrade3] > 0 and merchant_inventory[merchanttrade3] > 0 then --BUG compare number with nil
      --do a trade.
      local k = kingdom_inventory[towntrade3]
      local m = merchant_inventory[merchanttrade3]
      kingdom_inventory[towntrade3] = kingdom_inventory[towntrade3]- math.random(1,k) --remove items
      kingdom_inventory[merchanttrade3] = kingdom_inventory[merchanttrade3]+math.random(1,m)--add items
      message_que_add("Your merchants traded ".. k .. " units of " .. towntrade3 .. " for "..m.." units of "..merchanttrade3, 100, 1)
   end
   --what do i have to trade?
   --lets only trade thrice
end

function spawn_merchants()
   --create x ammount of merchants and donkey's and add them to the merchant group
   local merchants_count = math.random(6,14)
   local donkeys_count = math.random(3,7) --no longer used.
   local nesw = math.random(1,4)
   --select a random tile on the edge of the map to place them
   --note code, try spawn offscreen.
   if nesw == 1 then --north
      game.merchant_spawn_x = 2000 --math.random(1,game.tilecount) --tiles
      game.merchant_spawn_y = -1000 --math.random(1,game.tilecount) --tiles
   elseif nesw == 2 then --east
      game.merchant_spawn_x = 2000 --game.tilecount
      game.merchant_spawn_y = 1000 --math.random(1,game.tilecount)
   elseif newsw == 3 then --south
      game.merchant_spawn_x = -2000 --math.random(1,game.tilecount) --tiles
      game.merchant_spawn_y = 1000 --game.tilecount --math.random(1,game.tilecount) --tiles
   else --west
      game.merchant_spawn_x = -1000 --0 --tiles
      game.merchant_spawn_y = -2000 --math.random(1,game.tilecount) --math.random(1,game.tilecount) --tiles
   end

   for y = 1, game.tilecount do 
      for x = 1, game.tilecount do
	 if y == game.merchant_spawn_y and x == game.merchant_spawn_y then
	    lx = 300+(y - x) * 32 + 64      --create isometric
	    ly = -100+(y + x) * 32 / 2 + 50  --tile blit locations
	    game.merchant_spawn_x = lx
	    game.merchant_spawn_y = ly
	 end
	 if game_road_map[y][x] == 66 and game.merchant_target_x == 0 and game.merchant_target_y == 0 then
	    lx = 300+(y - x) * 32 + 64      --create isometric
	    ly = -100+(y + x) * 32 / 2 + 50  --tile blit locations
	    game.merchant_target_x = lx
	    game.merchant_target_y = ly
	 end
      end
   end --endfor
   for y = 1, game.tilecount do --check for bonfire if there is no trade post
      for x = 1, game.tilecount do
	 if game_road_map[y][x] == 47 and game.merchant_target_x == 0 and game.merchant_target_y == 0 then
	    lx = 300+(y - x) * 32 + 64      --create isometric
	    ly = -100+(y + x) * 32 / 2 + 50  --tile blit locations
	    game.merchant_target_x = lx
	    game.merchant_target_y = ly
	 end
      end
   end

   for i=1,merchants_count do --create new villagers and insert into merchant caravan
      mt = math.random(1,2)
      if mt == 1 then
	 table.insert(game_merchants, new_villager(0) )
      else
	 table.insert(game_merchants, new_wildlife(0, "donkey") )
      end
   end
   for i,v in ipairs(game_merchants) do
      game_merchants[i].x = game.merchant_spawn_x+math.random(1,64) --set locations
      game_merchants[i].y = game.merchant_spawn_y+math.random(1,64) --make them semi random
   end
   add_merchant_inventory() -- give them an inventory
end

function despawn_merchants() --once they have reached the edge of the map
   for i,v in ipairs(game_merchants) do
      table.remove(game_merchants,i)
   end
   remove_merchant_inventory() --remove their inventory
   game.merchant_target_x = 0 --reset all values
   game.merchant_target_y = 0
   game.merchant_spawn_x = 0
   game.merchant_spawn_y = 0
   game.merchant_arrived = 0
end

function update_merchant_location()
   --update the merchants location, they are traveling to your trade post(if availible) or your bon,fire
   --if they arrive at their destination, set game.trading_timer to 1000 (merchants are trading)
   --once the timer is complete, return the merchants to their spawn location.
   if game.merchant_arrived == 1 then --they are arriving and going to the trade post.
      for i,v in ipairs(game_merchants) do
	 if game_merchants[i].x > game.merchant_target_x then
	    game_merchants[i].x = game_merchants[i].x-1
	 elseif game_merchants[i].x < game.merchant_target_x then
	    game_merchants[i].x = game_merchants[i].x+1
	 elseif game_merchants[i].y > game.merchant_target_y then
	    game_merchants[i].y = game_merchants[i].y-1
	 elseif game_merchants[i].y < game.merchant_target_y then
	    game_merchants[i].y = game_merchants[i].y+1
	 elseif game_merchants[i].y == game.merchant_target_y and game_merchants[i].x == game.merchant_target_x then
	    game.merchant_arrived = 2 -- they are here!
	    game.trading_timer = 3000
	 end --endif	    
      end --endfor (update loc)
   elseif game.merchant_arrived == 2 then --do the timer
      game.trading_timer = game.trading_timer-1
      if game.trading_timer <= 0 then
	 game.merchant_arrived = 3
	 --conclude trading
	 report_trading_done()
      end
   elseif game.merchant_arrived == 3 then
      --leave.
      for i,v in ipairs(game_merchants) do
      	if game_merchants[i].x > game.merchant_spawn_x then
		game_merchants[i].x = game_merchants[i].x-1
      	elseif game_merchants[i].x < game.merchant_spawn_x then
		game_merchants[i].x = game_merchants[i].x+1
      	elseif game_merchants[i].y > game.merchant_spawn_y then
		game_merchants[i].y = game.merchant_spawn_y-1
      	elseif game_merchants[i].y < game.merchant_spawn_y then
		game_merchants[i].y = game_merchants[i].y+1
      	elseif game_merchants[i].y == game.merchant_spawn_y and 
      		game_merchants[i].x == game.merchant_spawn_x then
		despawn_merchants()
      	end --endif
      end--endfor
   end--endif
end

function merchants_leave() -- merchants left
end

function merchants_arrive() -- done every 3rd day
   local arrive = math.random(1,10)
   if game.merchant_arrived == 0 then
      if game.day_count % 3 == 0 then
	 if kingdom_inventory.unrest > 60 then
	    --tales of your riotous villagers have scared away merchants
	    message_que_add("tales of your riotous villagers have scared away merchants!".."("..x.."X"..y..")", 300, 1)
	 elseif arrive < 2 then
	    message_que_add("no merchants arrived today", 300, 1) --merchants arrive on 3rd day, 80% chance.
	 else
	    game.merchant_arrived = 1 --set merchants arrived flag = 1
	    spawn_merchants()
	 end--endif
      end--endif
   else -- merchant already arrived, update location
      update_merchant_location()
   end--endif
end
function draw_merchants()
   for i,v in ipairs(game_merchants) do
      local dx = game_merchants[i].x + game.draw_x
      local dy = game_merchants[i].y + game.draw_y
      draw_small_sprite(game_merchants[i].sprite, dx,dy)
   	--love.graphics.draw(game_sprites[game_villagers[i].sprite], blit_x, blit_y)
      --local msprite = game_sprites[game_merchants[i].sprite]
      --love.graphics.draw(msprite, dx, dy)
   end
end
