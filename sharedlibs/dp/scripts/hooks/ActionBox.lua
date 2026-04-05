local ActionBox, super = HookSystem.hookScript(ActionBox)

function ActionBox:init(...)
    super.init(self, ...)

    self.main_font = Assets.getFont("main")

    self.reaction_text = ""
    self.reaction_alpha = 0
end

function ActionBox:react(text, display_time)
    self.reaction_alpha = display_time and (display_time * 30) or 50
    self.reaction_text = text
end

function ActionBox:update()
    -- yup uh huh it DOES NOT work because of mana lib so I put it all the way there too
    self.reaction_alpha = self.reaction_alpha - DTMULT
    super.update(self)
end

function ActionBox:draw()
    -- basically uhh it starts moving up when the alpha gets below 1
    local y_offset = self.reaction_alpha / 6
    y_offset = math.min(y_offset, 1)
    y_offset = y_offset * 20

	love.graphics.setFont(self.main_font)
	Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
	love.graphics.print(self.reaction_text, 106 - self.main_font:getWidth(self.reaction_text)*0.5/2, -36 + y_offset, 0, 0.5, 0.5)

    super.draw(self)
end

return ActionBox