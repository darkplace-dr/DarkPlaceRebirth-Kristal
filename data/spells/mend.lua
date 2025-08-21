local spell, super = Class(Spell, "mend")

function spell:init()
    super.init(self)
    self.name = "Mend"
    self.cast_name = nil
    self.effect = "Heals over\ntime"
    self.description = "Allan please add description."
    self.check = "Allan please add check."

    self.cost = 10
    self.target = "ally"
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local object = Mend(user, target)
    --Game.battle.timer:script(function(wait)
      --  wait(1)
        Game.battle:addChild(object)
    --end)
    return true
end

function spell:getDamage(user, target)
    return 0 
end

return spell