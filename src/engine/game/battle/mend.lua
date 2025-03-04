---@class Mend : Object
---@overload fun(...) : Mend
local Mend, super = Class(Object)

function Mend:init(user, target)
    super.init(self, 0, 0)

    self.target = target

    self.chara = target.chara

    self.caster = user

    -- too op
    --self.magic = user.chara:getStat("magic")

    self.magic = 1

    self.last_second = 0

    self.last_healed = self.chara.health
end

function Mend:healUpdate()
    local second = os.date("%S")
    if self.last_second ~= second then --heal every 1 second

        if self.last_healed > self.chara.health then
            self:remove()
        else
            self.last_second = second

            self.chara.health = self.chara.health + self.magic

            self.last_healed = self.chara.health
        end
    end
end

function Mend:update()
    super.update(self)

    if Game.battle.state == "DEFENDING" then
        self:healUpdate()
    end

end

function Mend:draw()
    super.draw(self)
end

return Mend