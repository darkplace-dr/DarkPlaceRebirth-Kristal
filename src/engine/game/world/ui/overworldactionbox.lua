---@class OverworldActionBox : Object
---@overload fun(...) : OverworldActionBox
local OverworldActionBox, super = Class(Object)

function OverworldActionBox:init(x, y, index, chara)
    super.init(self, x, y)

    self.index = index
    self.chara = chara

    self.head_sprite = Sprite(chara:getHeadIcons() .. "/head", 13, 13)

    local ox, oy = chara:getNameOffset()
    if chara:getNameSprite() then
        self.name_sprite = Sprite(chara:getNameSprite(), 51 + ox, 16 + oy)
        self:addChild(self.name_sprite)
		
		if Game:getFlag("SHINY", {})[chara.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
			self.name_sprite:addFX(GradientFX(COLORS.white, {235/255, 235/255, 130/255}, 1, math.pi/2))
		end
    end

    self.hp_sprite   = Sprite("ui/hp", 109, 24)
    self.mp_sprite   = Sprite("ui/mp", 107, 26)

    local ox, oy = chara:getHeadIconOffset()
    self.head_sprite.x = self.head_sprite.x + ox
    self.head_sprite.y = self.head_sprite.y + oy

    self:addChild(self.head_sprite)
    self:addChild(self.hp_sprite)
    self:addChild(self.mp_sprite)
    self.mp_sprite.visible = false

    self.font = Assets.getFont("smallnumbers")
    self.main_font = Assets.getFont("main")

    self.selected = false

    self.reaction_text = ""
    self.reaction_alpha = 0
	self.four_party_mode = false
end

function OverworldActionBox:setHeadIcon(icon)
    self.head_sprite:setSprite(self.chara:getHeadIcons() .. "/" .. icon)
end

function OverworldActionBox:react(text, display_time)
    self.reaction_alpha = display_time and (display_time * 30) or 50
    self.reaction_text = text
end

function OverworldActionBox:update()
    self.reaction_alpha = self.reaction_alpha - DTMULT
    super.update(self)
end

function OverworldActionBox:draw()
    -- Draw the line at the top
    if self.selected then
        Draw.setColor(self.chara:getColor())
    else
        Draw.setColor(PALETTE["action_strip"])
    end
	if self.four_party_mode then
		love.graphics.setLineWidth(2)
		love.graphics.line(0, 1, 153, 1)
		
		if Game:getConfig("oldUIPositions") then
			love.graphics.line(0, 2, 2, 2)
			love.graphics.line(151, 2, 153, 2)
		end

        if self.chara:usesMana() then
            self.hp_sprite.y = 10

            self.mp_sprite.visible = true
            self.mp_sprite.x = 51
            
            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 70, 8, 81, 12)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 82

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 70, 8, math.ceil(health), 12)
            end

            ----------------- Mana Bar -----------------------------
            Draw.setColor(ManaHealthResources.PALETTE["mana_bar_bg"])
            love.graphics.rectangle("fill", 70, 24, 81, 12)

            local mana = (self.chara:getMana() / self.chara:getStat("mana")) * 82

            if mana > 0 then
                Draw.setColor(ManaHealthResources.PALETTE["mana_bar_fill"])
                love.graphics.rectangle("fill", 70, 24, math.ceil(mana), 12)
            end
            --------------------------------------------------------------

            local color = PALETTE["action_health_text"]
            local mana_color = ManaHealthResources.PALETTE["mana_text"]

            if mana <= 0 then
                mana_color = ManaHealthResources.PALETTE["mana_text_empty"]
            elseif (self.chara:getMana() <= (self.chara:getStat("mana") / 4)) then
                mana_color = ManaHealthResources.PALETTE["mana_text_low"]
            else
                mana_color = ManaHealthResources.PALETTE["mana_text"]
            end

            if health <= 0 then
                color = PALETTE["action_health_text_down"]
                mana_color = ManaHealthResources.PALETTE["mana_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            local mana_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8
            mana_offset = (#tostring(self.chara:getMana()) - 1) * 8

            local string_width_health = self.font:getWidth(tostring(self.chara:getStat("health")))
            local string_width_mana = self.font:getWidth(tostring(self.chara:getStat("mana")))

            love.graphics.setFont(self.font)

            --Draw the black translucent outlines
            local outline_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_WIDTH)

                ManaHealthResources:getOutlineDraft(self.chara:getHealth(), 127 - health_offset - string_width_health, 9)
                ManaHealthResources:getOutlineDraft("/", 137 - string_width_health, 9)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("health"), 152 - string_width_health, 9)

                ManaHealthResources:getOutlineDraft(self.chara:getMana(), 127 - mana_offset - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft("/", 137 - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("mana"), 152 - string_width_mana, 25)

                Draw.setColor(COLORS["black"], 0.5)
            Draw.popCanvas()

            Draw.drawCanvas(outline_canvas)

            Draw.setColor(color)
            love.graphics.print(self.chara:getHealth(), 127 - health_offset - string_width_health, 9)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 137 - string_width_health, 9)
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 152 - string_width_health, 9)

            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getMana(), 127 - mana_offset - string_width_mana, 25)
            Draw.setColor(ManaHealthResources.PALETTE["mana_text"])
            love.graphics.print("/", 137 - string_width_mana, 25)
            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getStat("mana"), 152 - string_width_mana, 25)
        else
            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 70, 24, 76, 9)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 76

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 70, 24, math.ceil(health), 9)
            end

            local color = PALETTE["action_health_text"]
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8

            Draw.setColor(color)
            love.graphics.setFont(self.font)
            love.graphics.print(self.chara:getHealth(), 96 - health_offset, 11)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 105, 11)
            local string_width = self.font:getWidth(tostring(self.chara:getStat("health")))
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 147 - string_width, 11)
        end

		love.graphics.setFont(self.main_font)
		Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
		love.graphics.printf(self.reaction_text, 5, 43, 146*2, "left", 0, 0.5, 0.5)
	else
		love.graphics.setLineWidth(2)
		love.graphics.line(0, 1, 213, 1)
		
		if Game:getConfig("oldUIPositions") then
			love.graphics.line(0, 2, 2, 2)
			love.graphics.line(211, 2, 213, 2)
		end

        if self.chara:usesMana() then
            self.hp_sprite.x = 107
            self.hp_sprite.y = 10

            self.mp_sprite.visible = true
            
            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 125, 8, 81, 12)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 82

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 125, 8, math.ceil(health), 12)
            end

            ----------------- Mana Bar -----------------------------
            Draw.setColor(ManaHealthResources.PALETTE["mana_bar_bg"])
            love.graphics.rectangle("fill", 125, 24, 81, 12)

            local mana = (self.chara:getMana() / self.chara:getStat("mana")) * 82

            if mana > 0 then
                Draw.setColor(ManaHealthResources.PALETTE["mana_bar_fill"])
                love.graphics.rectangle("fill", 125, 24, math.ceil(mana), 12)
            end
            --------------------------------------------------------------

            local color = PALETTE["action_health_text"]
            local mana_color = ManaHealthResources.PALETTE["mana_text"]

            if mana <= 0 then
                mana_color = ManaHealthResources.PALETTE["mana_text_empty"]
            elseif (self.chara:getMana() <= (self.chara:getStat("mana") / 4)) then
                mana_color = ManaHealthResources.PALETTE["mana_text_low"]
            else
                mana_color = ManaHealthResources.PALETTE["mana_text"]
            end

            if health <= 0 then
                color = PALETTE["action_health_text_down"]
                mana_color = ManaHealthResources.PALETTE["mana_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            local mana_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8
            mana_offset = (#tostring(self.chara:getMana()) - 1) * 8

            local string_width_health = self.font:getWidth(tostring(self.chara:getStat("health")))
            local string_width_mana = self.font:getWidth(tostring(self.chara:getStat("mana")))

            love.graphics.setFont(self.font)

            --Draw the black translucent outlines
            local outline_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_WIDTH)

                ManaHealthResources:getOutlineDraft(self.chara:getHealth(), 182 - health_offset - string_width_health, 9)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_health, 9)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("health"), 207 - string_width_health, 9)

                ManaHealthResources:getOutlineDraft(self.chara:getMana(), 182 - mana_offset - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft("/", 192 - string_width_mana, 25)
                ManaHealthResources:getOutlineDraft(self.chara:getStat("mana"), 207 - string_width_mana, 25)

                Draw.setColor(COLORS["black"], 0.5)
            Draw.popCanvas()

            Draw.drawCanvas(outline_canvas)

            Draw.setColor(color)
            love.graphics.print(self.chara:getHealth(), 182 - health_offset - string_width_health, 9)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 192 - string_width_health, 9)
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 207 - string_width_health, 9)

            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getMana(), 182 - mana_offset - string_width_mana, 25)
            Draw.setColor(ManaHealthResources.PALETTE["mana_text"])
            love.graphics.print("/", 192 - string_width_mana, 25)
            Draw.setColor(mana_color)
            love.graphics.print(self.chara:getStat("mana"), 207 - string_width_mana, 25)
        else
            -- Draw health
            Draw.setColor(PALETTE["action_health_bg"])
            love.graphics.rectangle("fill", 128, 24, 76, 9)

            local health = (self.chara:getHealth() / self.chara:getStat("health")) * 76

            if health > 0 then
                Draw.setColor(self.chara:getColor())
                love.graphics.rectangle("fill", 128, 24, math.ceil(health), 9)
            end

            local color = PALETTE["action_health_text"]
            if health <= 0 then
                color = PALETTE["action_health_text_down"]
            elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end

            local health_offset = 0
            health_offset = (#tostring(self.chara:getHealth()) - 1) * 8

            Draw.setColor(color)
            love.graphics.setFont(self.font)
            love.graphics.print(self.chara:getHealth(), 152 - health_offset, 11)
            Draw.setColor(PALETTE["action_health_text"])
            love.graphics.print("/", 161, 11)
            local string_width = self.font:getWidth(tostring(self.chara:getStat("health")))
            Draw.setColor(color)
            love.graphics.print(self.chara:getStat("health"), 205 - string_width, 11)
        end

		-- Draw name text if there's no sprite
		if not self.name_sprite then
			local font = Assets.getFont("name")
			love.graphics.setFont(font)
			Draw.setColor(1, 1, 1, 1)

			local name = self.chara:getName():upper()
			local ox, oy = self.chara:getNameOffset()
			local spacing = 5 - StringUtils.len(name)

			local off = 0
			for i = 1, StringUtils.len(name) do
				local letter = StringUtils.sub(name, i, i)
				love.graphics.print(letter, ox + 51 + off, oy + 16 - 1)
				off = off + font:getWidth(letter) + spacing
			end
		end

		local reaction_x = -1

		if self.x == 0 then -- lazy check for leftmost party member
			reaction_x = 3
		end

		love.graphics.setFont(self.main_font)
		Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
		love.graphics.print(self.reaction_text, reaction_x, 43, 0, 0.5, 0.5)
	end
	super.draw(self)
end

return OverworldActionBox
