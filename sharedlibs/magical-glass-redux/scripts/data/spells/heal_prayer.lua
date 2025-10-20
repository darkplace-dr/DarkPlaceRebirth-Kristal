local spell, super = Class("heal_prayer", true)

function spell:init()
    super.init(self)
    
    self.check = {"Heavenly light restores a little HP to\none party member.", "* Depends on Magic."}
end

function spell:onLightCast(user, target)
    local amount = math.ceil(Game:isLight() and user.chara:getStat("magic") * 2.5 or user.chara:getStat("magic") * 5)
    target:heal(amount)
end

function spell:onCast(user, target)
    if Game:isLight() then
        target:heal(math.ceil(user.chara:getStat("magic") * 2.5))
    else
        super.onCast(self, user, target)
    end
end

function spell:onLightWorldCast(chara)
    Game.world:heal(chara, 60)
end

return spell