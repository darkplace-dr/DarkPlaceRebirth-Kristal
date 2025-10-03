---@class DarkPartyMenu : Object
---@overload fun(...) : DarkPartyMenu
local DarkPartyMenu, super = Class(Object)

function DarkPartyMenu:init(selected)
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
	self.ui_cancel = Assets.newSound("ui_cancel")
	self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Sprite("player/heart")
	self.heart_sprite:setOrigin(0.5, 0.5)

    self.up = Assets.getTexture("ui/page_arrow_up")
    self.down = Assets.getTexture("ui/page_arrow_down")

    self.bg = UIBox(100, 100, 440, 300)
    self.bg.layer = -1

    self:addChild(self.bg)

	self.slot_selected = selected or 1

	self.char = Game.party[selected]

	self.unlocked = Game:getFlag("_unlockedPartyMembers")

	--these are the pages, for organization

	self.deltarune = {"kris", "susie", "ralsei", "noelle", "berdly", "ostarwalker"}

	self.dark_place = {"hero", "dess", "brenda", "jamm", "bor", "suzy", "apm"}

	self.fangames = {"ceroba", "pauling"}

	self.misc = {"mario"}

	self.character_menus = {
		["DELTARUNE"] = self.deltarune,
		["[color:#7F00FF]Dark Place"] = self.dark_place,
		["Fangames"] = self.fangames,
		["Miscellaneous"] = self.misc,
	}

	if Noel:loadNoel() then -- oh ho ho! secret character!
		table.insert(self.unlocked, "noel")
	end

	-- This removes all menus that contain no unlocked characters
	for i, menu in pairs(self.character_menus) do
		local has_unlocked = false
		for _, character in ipairs(menu) do
			if table.concat(self.unlocked, " "):find(character) then
				has_unlocked = true
				break
			end
		end
		if not has_unlocked then
			self.character_menus[i] = nil
		end
	end

	-- This is the text for the menu/page titles.
	self.text = Text("")
	self:addChild(self.text)
	self.text.x = 240
	self.text.y = 80

	self.selected_menu = 1

	self.state = "menu_select"

	self.character_index = {}
	self:selection(0)

	self.party_selected = 1

end

function DarkPartyMenu:selection(num)
	if self.state == "menu_select" then --this basically loads a new page

		-- this removes all sprites when a new page is made
		for i, sprite in ipairs(self.character_index) do
			sprite:remove()
		end

		self.character_index = {} -- this holds all party member sprites currently visible.

		self.selected_menu = self.selected_menu + num
	
		local menus = {}

		for k in pairs(self.character_menus) do
			table.insert(menus, k)
		end
		local noeltitle = "[shake:1]"..(" "):rep(26)
		if Noel:loadNoel() and self.slot_selected > 1 then --SECRET MENU!
			table.insert(menus, noeltitle)
		end
		
		local max = #menus
	
		if self.selected_menu > max then
			self.selected_menu = 1
		elseif self.selected_menu <= 0 then
			self.selected_menu = max
		end
	
		self.text:setText(menus[self.selected_menu])

		local menu_name = menus[self.selected_menu] 

		local table
		
		if menu_name == noeltitle then
			table = {"noel"} --SECRET TABLE DO NOT POST IN #SPAMROOM
		else
			table = self.character_menus[menu_name] 
		end
		
		-- this adds all the party icon sprites, if you want to add data to sprites do it here
		for i, party in ipairs(table) do

			local unlocked = false
	
			for _, key in ipairs(self.unlocked) do
				if key == party then
					unlocked = true
					break
				end
			end
			
			local path = "ui/menu/party/"
			local sprite = Sprite(path.."unknown")
			
			local icon = unlocked and party or "unknown" --just learned about this
			sprite:setSprite(path..icon)
			sprite.icon_path = path..icon --you can use this like: sprite:setSprite(sprite.icon_path.."_h")
			
			local offset = 40
			local x = 270 - offset + (i * offset)
	
			sprite.x = x
	
			sprite.y = 130
	
			sprite:setOrigin(0.5, 0.5)

			if unlocked then
			    sprite.char = Game:getPartyMember(party)

				if sprite.char.id == "noel" then
					sprite.x, sprite.y = 390, 250
				end
			end

	
			self:addChild(sprite)
			self.character_index[i] = sprite

		end
	end
	
end

function DarkPartyMenu:update()
	super.update(self)

	if self.state == "menu_select" then
		if Input.pressed("left", true) then
			self:selection(-1)
			self.ui_move:stop()
			self.ui_move:play()
		elseif Input.pressed("right", true) then
			self:selection(1)
			self.ui_move:stop()
			self.ui_move:play()
		elseif Input.pressed("cancel") then
			Game.world:openMenu(DarkCharacterMenu(self.slot_selected))
			self.ui_cancel_small:stop()
			self.ui_cancel_small:play()
		elseif Input.pressed("confirm") then
			if self.ready then
				self.ui_select:stop()
				self.ui_select:play()
				Input.clear()
				self.party_selected = 1
				self.state = "party_select"
				self:iconSelect(0, false)
			else
				self.ready = true
			end
		elseif Input.pressed("menu") then
		end
	else
		if Input.pressed("left", true) then
			self:iconSelect(-1)
		elseif Input.pressed("right", true) then
			self:iconSelect(1)
		elseif Input.pressed("cancel") then
			self.state = "menu_select"

			if self.selected_sprite then
				self.selected_sprite:remove()
			end

			self.selected:setSprite(self.selected.icon_path)

			self.ui_cancel_small:stop()
			self.ui_cancel_small:play()
		elseif Input.pressed("confirm") then
			local selectable = true
			if self.selected.char then
				selectable = self.slot_selected ~= 1 or self.selected.char:canLead()
				for i, v in ipairs(Game.party) do
					if v.id == self.selected.char.id then
						selectable = false
					end
				end
			else
				selectable = false
			end

			if selectable then
				self.ui_select:stop()
				self.ui_select:play()
				local party = self.selected.char.id
				local party_member = Game:getPartyMember(party)
				if Game.party[self.slot_selected] then
					Game.party[self.slot_selected] = party_member
					if self.slot_selected > 1 then
						Game.world.followers[self.slot_selected - 1]:setActor(Game.party[self.slot_selected]:getActor())
					else
						Game.world.player:setActor(Game.party[1]:getActor())
					end
				else
					Game:addPartyMember(party)
					if self.slot_selected > 1 then
						if Game.world.followers[self.slot_selected - 1] then
							Game.world.followers[self.slot_selected - 1]:setActor(Game.party[self.slot_selected]:getActor())
						else
							local follower = Game.world:spawnFollower(party)
							follower:setActor(Game.party[self.slot_selected]:getActor())
							follower:setFacing("down")
						end
					end
				end
	
				Game.world:openMenu(DarkCharacterMenu(self.slot_selected))
			else
				self.ui_cant_select:stop()
				self.ui_cant_select:play()
			end
		end
	end
end

function DarkPartyMenu:iconSelect(number, playsound)

	if playsound == false then
	else
		self.ui_move:stop()
		self.ui_move:play()
	end

	if self.selected then
		self.selected:setSprite(self.selected.icon_path)
	end

	self.party_selected = self.party_selected + number

	if self.party_selected > #self.character_index then
		self.party_selected = 1
	elseif self.party_selected <= 0 then
		self.party_selected = #self.character_index
    end

    self.selected = self.character_index[self.party_selected]

    self.selected:setSprite(self.selected.icon_path.."_h")

	if self.selected_sprite then
		self.selected_sprite:remove()
	end

	if self.selected.char then
		local party = self.selected.char


                local sprite = NPC(party:getActor().id)
                sprite.world = Game.world
                sprite:setFacing("down")
		self.selected_sprite = sprite

		local x = 154
		self.selected_sprite:setOrigin(0.5, 0.5)
		local y = 154
	
		self.selected_sprite:setScale(2)
		self.selected_sprite.x = x
		self.selected_sprite.y = y
	
		self:addChild(self.selected_sprite)

		if party.actor.menu_anim then
			self.selected_sprite:setSprite(party.actor.menu_anim)
		end
	end
end

function DarkPartyMenu:unused()

		if Input.pressed("left", true) then
			self:iconSelect(-1)
		elseif Input.pressed("right", true) then
			self:iconSelect(1)
		end
end

function DarkPartyMenu:draw()
    super.draw(self)

	love.graphic.setFont(self.font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(6)
    local x = 230
	love.graphics.line(x, 80, x, 420)
	love.graphics.line(self.bg.x - 20, 220, self.bg.x + (230 - self.bg.x), 220)

	if self.selected and self.selected.char and self.state ~= "menu_select" then
		local party = self.selected.char
		x = self.bg.x - 10
		love.graphics.print(party:getName(), x, 220)
		love.graphics.print("HP "..party.health.."/"..party.stats["health"], x, 245)
		love.graphics.print("ATK "..party.stats["attack"], x, 270)

		if party.id == "noel" and self.state == "party_select" then
			love.graphics.print("PAIN x10", x, 295)
		else
			love.graphics.print("DEF "..party.stats["defense"], x, 295)
		end

		love.graphics.print("MAG "..party.stats["magic"], x, 320)
		love.graphics.print("LOVE "..party.love, x, 345)
		love.graphics.print("KILLS "..party.kills, x, 370)
	elseif self.state ~= "menu_select" then
		x = self.bg.x - 10
		love.graphics.print("???", x, 220)

		love.graphics.scale(3, 3)
		love.graphics.print("?", 45, 33)
	end
end

return DarkPartyMenu
