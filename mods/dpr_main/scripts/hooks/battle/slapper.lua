---@class Slapper : Object
---@overload fun(...) : Slapper
local Slapper, super =  Utils.hookScript(Slapper)

function Slapper:init(user, target)
    super.init(self, user, target)
	self.jackenstein = Game.battle.encounter.is_jackenstein
end

function Slapper:update()
    super.super.update(self)

    if Input.pressed("z") then
        if self.caster.sprite then
            self.caster:setAnimation("battle/attack_repeat")
            if self.target.health > 0 then
				if self.jackenstein then
					self.target:hurt(0, self.caster)
				else
					self.target:flash()
					self.target:hurt(self.power, self.caster, self.target.onDefeatFatal)
				end
            end
        else
            if self.target.health > 0 then
				if self.jackenstein then
					self.target:hurt(0, self.caster)
				else
					self.target:hurt(self.power - 10, self.caster, self.target.onDefeatFatal)
				end
            end
        end
        if self.target.health > 0 then
            if self.caster.sprite then
                self.hits = self.hits + self.power
            else
                self.hits = self.hits + self.power-10
            end
			if not self.jackenstein then
				Game.battle:shakeCamera(4)
				Assets.playSound("damage")
			end
            self.target.hit_count = 0
        end
    end

    if self.thing <= 0 then
        Game.battle:finishAction()
        self:remove()
    end

end

return Slapper