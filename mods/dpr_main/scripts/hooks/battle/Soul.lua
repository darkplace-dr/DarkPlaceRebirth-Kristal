local Soul, super = Utils.hookScript(Soul)

function Soul:update()	
    if self.transitioning and Game.battle.encounter.jackenstein then
        if self.timer >= 7 then
            Input.clear("cancel")
			self.alpha = 1
            self.timer = 0
            if self.transition_destroy then
                Game.battle:addChild(HeartBurst(self.target_x, self.target_y, {Game:getSoulColor()}))
                self:remove()
            else
                self.transitioning = false
                self:setExactPosition(self.target_x, self.target_y)
            end
        else
            self:setExactPosition(
                Utils.lerp(self.original_x, self.target_x, self.timer / 7),
                Utils.lerp(self.original_y, self.target_y, self.timer / 7)
            )
			
            if self.transition_destroy then
				self.alpha = MathUtils.lerp(0, self.target_alpha or 1, MathUtils.clamp(self.timer / 3, 0, 1))
			else
				self.alpha = MathUtils.lerp(1, 0, MathUtils.clamp(self.timer / 7, 0, 1))
			end
            self.sprite:setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            self.timer = self.timer + (1 * DTMULT)
        end
        return
    end
	
	super.update(self)
end

return Soul