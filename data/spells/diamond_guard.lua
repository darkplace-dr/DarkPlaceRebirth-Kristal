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

function spell:getCastMessage(user, target)
    if Game.pp > 0 then
        return "* But the SOUL was already protected."
    elseif not Game.battle.no_buff_loop then
        return "* But the SOUL was already about\nto be protected."
    else
        return "* "..user.chara:getName().." protected the SOUL!"
    end
end

function spell:getLightCastMessage(user, target)
    if Game.pp > 0 then
        return "* But the SOUL was already protected."
    elseif not Game.battle.no_buff_loop then
        return "* But the SOUL was already about\nto be protected."
    else
        return "* "..user.chara:getName().." protected the SOUL!"
    end
end

function spell:onCast(user, target)
	if Game.pp > 0 or not Game.battle.no_buff_loop then
        Game:giveTension(self.cost)
    else
        Game.battle.no_buff_loop = false
    end
end

function spell:onLightCast(user, target)
	if Game.pp > 0 or not Game.battle.no_buff_loop then
        Game:giveTension(self.cost)
    else
        Game.battle.no_buff_loop = false
    end
end

function spell:hasWorldUsage(chara)
    if Game.pp > 0 then
        return false
    else
        return true
    end
end

function spell:onWorldCast(chara)
    Game.pp = 1
    Assets.playSound("ceroba_trap")
    Game.world.timer:after(0.46, function()
        Assets.playSound("equip_armor")
    end)
end

return spell