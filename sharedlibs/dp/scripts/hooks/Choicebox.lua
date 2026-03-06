---@class Choicebox : Choicebox
local Choicebox, super = HookSystem.hookScript(Choicebox)

function Choicebox:init(x, y, width, height, battle_box, options)
    super.init(self, x, y, width, height, battle_box, options)

    options = options or {}
	self.choice_offsets = {}
	for i = 1, 4 do
		self.choice_offsets[i] = {x = options["offset_x_" .. i] or 0, y = options["offset_y_" .. i] or 0}
	end
end

function Choicebox:draw()
    super.super.draw(self)
    love.graphics.setFont(self.font)
    if self.choices[1] then
        Draw.setColor(self.main_colors[1])
        if self.current_choice == 1 then Draw.setColor(self.hover_colors[1]) end
        love.graphics.print(self.choices[1], 36 + self.choice_offsets[1].x, 24 + self.choice_offsets[1].y)
    end
    if self.choices[2] then
        Draw.setColor(self.main_colors[2])
        if self.current_choice == 2 then Draw.setColor(self.hover_colors[2]) end
        love.graphics.print(self.choices[2], 528 - self.font:getWidth(self.choices[2]) + self.choice_offsets[2].x, 24 + self.choice_offsets[2].y)
    end
    if self.choices[3] then
        Draw.setColor(self.main_colors[3])
        if self.current_choice == 3 then Draw.setColor(self.hover_colors[3]) end
        love.graphics.print(self.choices[3], 17 + MathUtils.round(self.width / 2) - MathUtils.round(self.font:getWidth(self.choices[3]) / 2) + self.choice_offsets[3].x, -8 + self.choice_offsets[3].y)
    end
    if self.choices[4] then
        Draw.setColor(self.main_colors[4])
        if self.current_choice == 4 then Draw.setColor(self.hover_colors[4]) end
        love.graphics.print(self.choices[4], 17 + MathUtils.round(self.width / 2) - MathUtils.round(self.font:getWidth(self.choices[4]) / 2) + self.choice_offsets[4].x, 78 + self.choice_offsets[4].y)
    end

    local soul_positions = {
        --[[ Center: ]] { 224, 38 },
        --[[ Left:   ]] { 4,   34 },
        --[[ Right:  ]] { 528 - self.font:getWidth(self.choices[2] or "") - 32, 34 },
        --[[ Top:    ]] { 17 + MathUtils.round(self.width / 2) - MathUtils.round(self.font:getWidth(self.choices[3] or "") / 2) - 32, -8 + 6 },
        --[[ Bottom: ]] { 17 + MathUtils.round(self.width / 2) - MathUtils.round(self.font:getWidth(self.choices[4] or "") / 2) - 32, 78 + 6 }
    }

    local heart_x = soul_positions[self.current_choice + 1][1]
    local heart_y = soul_positions[self.current_choice + 1][2]

    Draw.setColor(Game:getSoulColor())
    Draw.draw(self.heart, heart_x, heart_y, 0, 2, 2)
end

return Choicebox