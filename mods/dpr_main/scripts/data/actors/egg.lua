local Egg, super = Class(Actor, "egg")

function Egg:init()
    super.init(self)
    self.width, self.height = 50, 84
    self.hitbox = {12,41, 30,40}
    self.path = "battle/enemies/egg/nothing"
    self.flip = "right"
end

function Egg:createSprite()
    return EggActor(self)
end

function Egg:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if anim == "idle" then
        sprite:resetParts()
    elseif anim == "down" then
        sprite:resetParts()
        sprite:setSwingSpeed(0.5)
    end
end

return Egg