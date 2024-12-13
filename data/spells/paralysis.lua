local spell, super = Class(Spell, "paralysis")

function spell:init()
    super.init(self)

    self.name = "Paralysis"

    self.effect = "Ceroba's\nSpecial"
    self.description = "Deals massive damage to one enemy.\nDepends on Magic."

    self.cost = 70

    self.target = "enemy"

    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = self:getDamage(user, target)

	local function generateSlash()
		local diamond = Sprite("effects/spells/ceroba/diamond")
		diamond:setOrigin(0.5, 0.5)
		diamond:setScale(2.5, 2.5)
		diamond:setPosition(target:getRelativePos(target.width/2, target.height/2))
		diamond.layer = target.layer + 1
		Assets.playSound("trap")
		diamond:play(1/15, false, function(s) s:fadeOutAndRemove(0.1) end)
		user.parent:addChild(diamond)
	end

	Game.battle.timer:after(0.65, function()
		target:flash()
		target:hurt(damage, user)
	end)

	Game.battle.timer:after(0.8, function()
		Game.battle:finishActionBy(user)
	end)

	generateSlash(1)
	return false
end

function spell:onLightCast(user, target)
	local damage = self:getDamage(user, target)

	local function generateSlash()
		local diamond = Sprite("effects/spells/ceroba/diamond")
		diamond:setOrigin(0.5, 0.5)
		diamond:setScale(3.5, 3.5)
		diamond:setPosition(target:getRelativePos(target.width/2, target.height/2))
		diamond.layer = target.layer + 1
		Assets.playSound("trap")
		diamond:play(1/15, false, function(s) s:fadeOutAndRemove(0.1) end)
		user.parent:addChild(diamond)
	end

	Game.battle.timer:after(0.65, function()
		target:hurt(damage, user)
	end)

	Game.battle.timer:after(0.8, function()
		Game.battle:finishActionBy(user)
	end)

	generateSlash(1)
	return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local min_magic = Utils.clamp(user.chara:getStat("magic") - 3, 1, 999)
        return math.ceil((min_magic * 8) + 45 + Utils.random(10))
    else
		local min_magic = Utils.clamp(user.chara:getStat("magic") - 10, 1, 999)
		return math.ceil((min_magic * 12) + 90 + Utils.random(10))
    end
end

return spell