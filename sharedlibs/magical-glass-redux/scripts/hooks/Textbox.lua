local Textbox, super = HookSystem.hookScript(Textbox)

function Textbox:init(x, y, width, height, default_font, default_font_size, battle_box)
    super.init(self, x, y, width, height, default_font, default_font_size, battle_box)

    if battle_box then
        if Game.battle.light then
            Textbox.REACTION_X_BATTLE = Textbox.REACTION_X
            Textbox.REACTION_Y_BATTLE = Textbox.REACTION_Y

            self.face_x = 6
            self.face_y = -3

            self.text_x = 0
            self.text_y = -2

            self.face:setPosition(self.face_x, self.face_y)
            self.text:setPosition(self.text_x, self.text_y)
        else
            Textbox.REACTION_X_BATTLE = ORIG_REACTION_X_BATTLE
            Textbox.REACTION_Y_BATTLE = ORIG_REACTION_Y_BATTLE
        end
    end
end

return Textbox