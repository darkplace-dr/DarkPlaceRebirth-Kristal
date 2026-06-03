local SpeechBubble, super = HookSystem.hookScript(SpeechBubble)

function SpeechBubble:draw()
    if Game.battle and Game.battle.light and not self.auto then
        if self.right then
            local width = self:getSpriteSize()
            Draw.draw(self:getSprite(), width - 12, 0, 0, -1, 1)
        else
            Draw.draw(self:getSprite(), 0, 0)
        end

        Object.draw(self)
    else
        super.draw(self)
    end
end

return SpeechBubble