---@class HealthBar : Object
---@overload fun(...) : HealthBar
local HealthBar, super = Class(Object)

function HealthBar:init()
    super.init(self, 0, -80)

    self.layer = 1 -- TODO

    self.parallax_x = 0
    self.parallax_y = 0

    self.animation_done = false
    self.animation_timer = 0
    self.animate_out = false
    self.animation_y = -63
	self.animation_extra_y = 0

    self.action_boxes = {}
	local four_party_mode = false
    for index, chara in ipairs(Game.party) do
        local x_pos = (index - 1) * 213
        if #Game.party == 4 then
			x_pos = 14 + (index - 1) * 153
			four_party_mode = true
        elseif #Game.party == 2 then
            if Game:getConfig("oldUIPositions") then
                if index == 1 then
                    x_pos = 105
                else
                    x_pos = 325
                end
            else
                if index == 1 then
                    x_pos = 108
                else
                    x_pos = 322
                end
            end
        elseif #Game.party == 1 then
            x_pos = 213
        end

        local action_box = OverworldActionBox(x_pos, 0, index, chara)
		action_box.four_party_mode = four_party_mode
		if four_party_mode then
			action_box.hp_sprite.x = 51
			if action_box.name_sprite then
				action_box.name_sprite.visible = false
			end
			if Game:getFlag("SHINY", {})[action_box.chara.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
				action_box.shiny_sprite = Sprite("ui/mini_shiny_icon", 53, 10)
				action_box:addChild(action_box.shiny_sprite)
				action_box.shiny_sprite:addFX(GradientFX(COLORS.white, {235/255, 235/255, 130/255}, 1, math.pi/2))
			end
		end
        self:addChild(action_box)
        table.insert(self.action_boxes, action_box)
        chara:onActionBox(action_box, true)
    end

    self.auto_hide_timer = 0
end

function HealthBar:transitionIn()
    if self.animate_out then
        self.animate_out = false
        self.animation_timer = 0
        self.animation_done = false
    end
end

function HealthBar:transitionOut()
    if not self.animate_out then
        self.animate_out = true
        self.animation_timer = 0
        self.animation_done = false
    end
end

function HealthBar:update()
    self.animation_timer = self.animation_timer + DTMULT
    self.auto_hide_timer = self.auto_hide_timer + DTMULT
    if Game.world.menu or Game.world:inBattle() then
        -- If we're in an overworld battle, or the menu is open, we don't want the health bar to disappear
        self.auto_hide_timer = 0
    end

    if self.auto_hide_timer > 60 then -- After two seconds outside of a battle, we hide the health bar
        self:transitionOut()
    end

    local max_time = self.animate_out and 3 or 8

    if #Game.party == 4 then
		self.animation_extra_y = 14
	else
		self.animation_extra_y = 0		
	end
    if self.animation_timer > max_time + 1 then
        self.animation_done = true
        self.animation_timer = max_time + 1
        if self.animate_out then
            Game.world.healthbar = nil
            self:remove()
            return
        end
    end

    if not self.animate_out then
        if self.animation_y < 0 then
            if self.animation_y > -40 then
                self.animation_y = self.animation_y + math.ceil(-self.animation_y / 2.5) * DTMULT
            else
                self.animation_y = self.animation_y + 30 * DTMULT
            end
        else
            self.animation_y = 0
        end
    else
        if self.animation_y > -63 - self.animation_extra_y then
            if self.animation_y > 0 then
                self.animation_y = self.animation_y - math.floor(self.animation_y / 2.5) * DTMULT
            else
                self.animation_y = self.animation_y - 30 * DTMULT
            end
        else
            self.animation_y = -63 - self.animation_extra_y
        end
    end

    self.y = 480 - (self.animation_y + 63 + self.animation_extra_y)

    super.update(self)
end

function HealthBar:draw()
    -- Draw the black background
    Draw.setColor(PALETTE["world_fill"])
    love.graphics.rectangle("fill", 0, 2, 640, 62 + self.animation_extra_y)

    super.draw(self)
end

function HealthBar:react(chara, reaction)
    local index = Game:getPartyIndex(chara)
    if index and self.action_boxes[index] then
        self.action_boxes[index]:react(reaction)
    end
end

return HealthBar