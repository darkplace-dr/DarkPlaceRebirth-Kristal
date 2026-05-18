---@class DarkCharacterMenu : Object
---@overload fun(...) : DarkCharacterMenu
local DarkCharacterMenu, super = Class(Object)

function DarkCharacterMenu:init(selected)
    super.init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
	self.ui_cancel = Assets.newSound("ui_cancel")
	self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.heart_sprite = Sprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
	self.heart_sprite:setOrigin(0.5, 0.5)

    self.up = Assets.getTexture("ui/page_arrow_up")
    self.down = Assets.getTexture("ui/page_arrow_down")

    self.bg = UIBox(80, 100, 480, 300)
    self.bg.layer = -1

    self:addChild(self.bg)
	
	self.party = Game.party

	self.sprites = {}

	self:partySprites()

	self.index = 4

	self.selected = selected or 1

	self.text = Text("")
	self:addChild(self.text)
	self.text:setScale(0.5)
	self.text.x = 70
	self.text.y = 256
	
	self:addChild(self.heart_sprite)
	self.heart_sprite.y = self.bg.y + 125
	self.heart_sprite.x = self.bg.x + (self.selected) * 100
	self.target_x = self.bg.x + (self.selected) * 100
	self:selection(0)
end

function DarkCharacterMenu:removeParty()
	if (self.selected == 1 and #Game.party == 1) or (self.selected == 1 and not Game.party[2]:canLead()) or #Game.party == 1 or (self.selected > #Game.party) then
		self.ui_cant_select:stop()
		self.ui_cant_select:play()
		self.heart_sprite:shake(0, 5)
	else
		Game:removePartyMember(self.sprites[self.selected].party.id)
		if Game.world.followers[self.selected - 1] then
			Game.world.followers[self.selected - 1]:remove()
		end
		self:partySprites()
		self:selection(0)
	end
end

function DarkCharacterMenu:partySprites()

	for i, sprite in ipairs(self.sprites) do
		self.sprites[sprite] = nil
		sprite:remove()
	end

	self.sprites = {}

	for i, party in ipairs(Game.party) do
		--local sprite = Sprite(party.actor.path .. "/" .. party.actor.default .. "/down")


                local sprite = NPC(party:getActor().id)
                sprite.world = Game.world
                sprite:setFacing("down")

		local x = self.bg.x + 100 + (i - 1) * 100 
		--sprite:setOrigin(0.5, 0.5)
		local y = self.bg.y + 100
	
		sprite:setScale(2)
		sprite.x = x
		sprite.y = y

		sprite.party = party

		self.sprites[i] = sprite
	
		self:addChild(sprite)

        if party.actor.menu_anim then
			sprite:setSprite(party.actor.menu_anim)
		end



	end
end

function DarkCharacterMenu:selection(num)
	local chr = self.sprites[self.selected]

	if chr then
	    chr:removeFX("outline")
	end

	self.selected = self.selected + num

	self.ui_move:stop()
	self.ui_move:play()

	if self.selected > self.index then
		self.selected = 1
	end

	if self.selected <= 0 then
		self.selected = self.index
	end

	local chr = self.sprites[self.selected]

	if chr then 
		chr:addFX(OutlineFX(), "outline")
		chr:getFX("outline"):setColor(chr.party:getColor())

		self.heart_sprite:setColor(chr.party:getSoulColor())
		self.heart_sprite:setSprite("player/"..chr.party:getSoulFacing().."/heart")

		local text = chr.party:getTitleExtended() or chr.party:getTitle() or "* Placeholder~"
		self.text:setText(text)
	else
		self.text:setText("Empty")
		self.heart_sprite:setColor({1, 0, 0})
        self.heart_sprite:setSprite("player/up/heart")
	end

	self.target_x = self.bg.x + (self.selected) * 100
end

function DarkCharacterMenu:update()
	super.update(self)

    self.heart_sprite.x = self.heart_sprite.x + (self.target_x - self.heart_sprite.x) * 20 * DT

	if Input.pressed("left", true) then
		self:selection(-1)

	elseif Input.pressed("right", true) then
		self:selection(1)

	elseif Input.pressed("cancel") then
		if self.ready then
			self.ui_cancel:stop()
			self.ui_cancel:play()
			Game.world:closeMenu()
			self:remove()
		else
			self.ready = true
		end

	elseif Input.pressed("confirm") then
		if self.selected >= (#Game.party+2) then
			self.ui_cant_select:stop()
			self.ui_cant_select:play()
			self.heart_sprite:shake(0, 5)
		elseif self.ready then
			self.ui_select:stop()
			self.ui_select:play()
			Game.world:openMenu(DarkPartyMenu(self.selected))
		else
			self.ready = true
		end

	elseif Input.pressed("menu") then
		self:removeParty()
	end
end

function DarkCharacterMenu:draw()
    super.draw(self)

	love.graphics.setFont(self.font)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineWidth(6)
	local y = 246
	love.graphics.line(80, y, 560, y)
    local x = 320
	love.graphics.line(x, y, x, 420)

	love.graphics.setColor(0, 0, 0)

	if Game.party[self.selected] then
		self:drawStats()
	end
end

function DarkCharacterMenu:getElement(party) -- added before elements were introduced properly
    local elements = party:getElements()
    if elements then
		if #elements == 1 then
			return elements[1]
		else
			local element = ""
			for i, v in ipairs(elements) do
				element = element..v
				if i < #party.element then
					element = element.."/"
				end
			end
			return element
		end
	end
    return "???"
end

function DarkCharacterMenu:drawStats()

	local party = Game:getPartyMember(Game.party[self.selected].id)

	love.graphics.setColor(1, 1, 1)

	love.graphics.print(party:getName(), 80, 90)

	if party:CharacterMenuDraw() then
		--party:CharacterMenuDraw()
	else
		local x = 330
    	--278, 246
		local elem_width = self.font:getWidth(self:getElement(party)) <= 120 and 1 or 120/self.font:getWidth(self:getElement(party))
		love.graphics.print("ELEMENT: ", x, 374)
		love.graphics.print(self:getElement(party), x + 112, 374, 0, elem_width, 1)
        love.graphics.print("LEVEL: "..party.level, x, 278)
		love.graphics.print("LOVE: "..party.love, x, 310)
		love.graphics.print("KILLS: "..party.kills, x, 342)

		x = 438

		love.graphics.print("HP: "..party.health.."/"..party.stats["health"], x, 246)


		x = 464
		love.graphics.print("ATK: "..party.stats["attack"], x, 278)
		love.graphics.print("DEF: "..party.stats["defense"], x, 310)
		love.graphics.print("MAG: "..party.stats["magic"], x, 342) --374 --342


        Draw.draw(Assets.getTexture("ui/menu/icon/sword"), x - 24, 278 + 6, 0, 2, 2)
        Draw.draw(Assets.getTexture("ui/menu/icon/armor"), x - 24, 310 + 6, 0, 2, 2)
        Draw.draw(Assets.getTexture("ui/menu/icon/magic"), x - 24, 342 + 6, 0, 2, 2)
	end
end

return DarkCharacterMenu
