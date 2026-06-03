local spell, super = Class(Spell, "diamond_guard")

function spell:init()
    super.init(self)

    self.name = "D. Guard"
    self.cast_name = "DIAMOND GUARD"

    self.effect = "Raise\nShield"
    self.description = "Raises a temporary diamond shield to\nprotect the SOUL."
    self.check = "Raises a temporary\ndiamond shield to protect the\nSOUL."

    self.cost = 32

    self.target = "none"

    self.tags = {}
end

function spell:getBattleDescription()
    if Game.pp > 0 then
        return "Already\nProtected"
    elseif not Game.battle.no_buff_loop then
        return "Already\nPrepared"
    end
    return self.effect
end

function spell:isUsable(chara)
    if Game.pp > 0 or not Game.battle.no_buff_loop then
        return false
    end
    return self.usable
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." protected the SOUL!"
end

function spell:getLightCastMessage(user, target)
    return "* "..user.chara:getName().." protected the SOUL!"
end

function spell:onCast(user, target)
	Game.battle.no_buff_loop = false
end

function spell:onLightCast(user, target)
	Game.battle.no_buff_loop = false
end

function spell:hasWorldUsage(chara)
    if Game.pp > 0 then
        return false
    end
    return true
end

function spell:onWorldCast(chara)
    Game.pp = 1
    Assets.playSound("ceroba_trap")
    Game.world.timer:after((1/15)*8, function()
        -- plays on the 8th frame of the diamond animation
        -- no diamond, so we just imitate the delay
        Assets.playSound("equip_armor")
    end)
end

return spell