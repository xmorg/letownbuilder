-- Saving and loading functions

function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end


function love_crude_load()
   --to avoid errors check to see if there are files???
   e = love.filesystem.exists( "game.lua" )
   if e == true then
      load_game_res() --create new scene dupes villagers and maybe other stuff.
      
      chunk = love.filesystem.load( "game.lua" )
      chunk()
      --note you can still get errors if files are missing
      chunk = love.filesystem.load( "game_directives.lua" )
      chunk()
      chunk = love.filesystem.load( "kingdom_inventory.lua" )
      chunk()
      chunk = love.filesystem.load( "research_topics.lua" )
      chunk()  -- research_topics

      --game_villagers = {} -- clear it out.
      --for k,v in pairs(game_villagers) do game_villagers[k]=nil end
      chunk = love.filesystem.load( "game_villagers.lua" )
      chunk()  --
      chunk = love.filesystem.load( "game_map.lua" )
      chunk()  -- 
      chunk = love.filesystem.load( "game_fire_map.lua" )
      chunk()  -- 
      
      chunk = love.filesystem.load( "game_road_map.lua" )
      chunk()
      
      chunk = love.filesystem.load( "game_wildlife.lua" )
      chunk()
      
      a = love.filesystem.exists( "achivements.lua" )
      if a == true then --we have a saved file
      	chunk = love.filesystem.load( "achivements.lua" )
      	chunk()
      else
      	load_new_achivements() --achivements.lua --use a blank file.
      end
      
      --now make sure that resources are properly reloaded!
      
   else
      game.message_box_text = "No file to load! (missing game.lua)"
      game.message_box_timer = 80
   end
end

function love_crude_save()
	love.filesystem.write( "game.lua", 
		table.show(game, "game")) 
	love.filesystem.write( "game_directives.lua", 
		table.show(game_directives, "game_directives")) 
	love.filesystem.write( "kingdom_inventory.lua", 
		table.show(kingdom_inventory, "kingdom_inventory"))
	love.filesystem.write( "research_topics.lua", 
		table.show(research_topics, "research_topics"))
	--research_topics
	love.filesystem.write( "game_villagers.lua", 
		table.show(game_villagers, "game_villagers"))
	love.filesystem.write( "game_map.lua", 
		table.show(game_map, "game_map"))
	love.filesystem.write( "game_fire_map.lua", 
		table.show(game_fire_map, "game_fire_map"))
	love.filesystem.write( "game_road_map.lua", 
		table.show(game_road_map, "game_road_map"))
		
	love.filesystem.write( "game_wildlife.lua", 
		table.show(game_wildlife, "game_wildlife"))
		
	game_families = get_villager_famgroups()
	love.filesystem.write( "game_families.lua", 
		table.show(game_families, "game_families"))
	love.filesystem.write( "achivements.lua", 
		table.show(achivements, "achivements"))
end
