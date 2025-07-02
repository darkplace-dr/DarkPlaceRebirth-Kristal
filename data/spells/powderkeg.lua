local spell, super = Class(Spell, "powderkeg")

function spell:init()
    super.init(self)

    self.name = "Powderkeg"
	self.cast_name = "POWDERKEG"

    self.effect = "2x Fire\nDamage"
    self.description = "Covers the target with gunpowder, causing\nthem to take double damage from FIRE attacks."
	self.check = {"", ""}

    self.cost = 16

    self.target = "enemy"

    self.tags = {"Status"}
end

function spell:getCastMessage(user, target)
    if target.powder ~= true then
        return "* "..user.chara:getName().." used "..self:getCastName().."![wait:10]\n* "..target.name.." now takes 2x damage\nfrom FIRE attacks!"
    else
        return "* "..user.chara:getName().." used "..self:getCastName().."![wait:10]\n* ... but "..target.name.." was already\ncovered in gunpowder..."
    end
end

function spell:onCast(user, target)
    user:setAnimation("battle/act")

    Game.battle.timer:after(1/4, function()
        if target.powder ~= true then
            Assets.playSound("damage")
            target.powder = true
            target:addFX(ColorMaskFX({0,0,0}, 0.5), "powder_fx")
            target:shake(10)
        end
    end)

    Game.battle.timer:after(1, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
    return false
end

return spell
