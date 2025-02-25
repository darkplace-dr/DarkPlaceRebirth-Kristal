local spell, super = Class("dual_heal", true)

function spell:init()
    super.init(self)
    
    self.check = {"Heavenly light restores a little HP to\nall party members.", "* Depends on Magic."}
end

function spell:onLightCast(user, target)
    local amount = math.ceil(Game:isLight() and user.chara:getStat("magic") * 3 or user.chara:getStat("magic") * 5.5)
    for _,battler in ipairs(Game.battle.party) do
        battler:heal(amount)
    end
end

function spell:onCast(user, target)
    if Game:isLight() then
        for _,battler in ipairs(Game.battle.party) do
            battler:heal(math.ceil(user.chara:getStat("magic") * 3))
        end
    else
        super.onCast(self, user, target)
    end
end

return spell