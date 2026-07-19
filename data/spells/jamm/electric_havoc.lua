local spell, super = Class(Spell, "electric_havoc")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Elec. Havoc"

    -- Battle description
    self.effect = "Electric\nStorm"
    -- Menu description
    self.description = "Bolts an enemy 3 times. Extremely powerful."
    -- Check description
    self.check = "Bolts an enemy\n3 times.\n* Extremely powerful."

    -- Resource costs
    self.cost = 100
    self.mana_cost = 100

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local function shock(scale_x)
		local cutAnim = Sprite("party/jamm/dark/special/shock")
		cutAnim:setOrigin(0.5, 1)
		cutAnim:setScale(2 * scale_x, 2)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		user.parent:addChild(cutAnim)
		Assets.playSound("shock", 1, 1)
		Game.stage.timer:tween(0.5, cutAnim, {alpha = 0}, "linear", function()
			cutAnim:remove()
		end)
	end

	Game.battle.timer:after(0.25, function()
		shock(1)
		target:hurt(self:getDamage(user, target), user)
		Game.battle.timer:after(0.25, function()
			shock(-1)
			target:hurt(self:getDamage(user, target), user)
			Game.battle.timer:after(0.25, function()
				shock(1)
				target:hurt(self:getDamage(user, target), user)
			end)
		end)
	end)
end

function spell:onLightCast(user, target)
	local function shock(scale_x)
		local cutAnim = Sprite("party/jamm/dark/special/shock")
		cutAnim:setOrigin(0.5, 1)
		cutAnim:setScale(2 * scale_x, 2)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		Game.battle:addChild(cutAnim)
		Assets.playSound("shock", 1, 1)
		Game.stage.timer:tween(0.5, cutAnim, {alpha = 0}, "linear", function()
			cutAnim:remove()
		end)
	end

	Game.battle.timer:after(0.25, function()
		shock(1)
		target:hurt(self:getDamage(user, target), user)
		Game.battle.timer:after(0.25, function()
			shock(-1)
			target:hurt(self:getDamage(user, target), user)
			Game.battle.timer:after(0.25, function()
				shock(1)
				target:hurt(self:getDamage(user, target), user)
			end)
		end)
	end)
end

function spell:getDamage(user, target)
	if Game:isLight() then
		local damage = 50

		if target.defense >= 99 then
			damage = 0
		end

		return damage
	else
		local _, yellowhat_count = user.chara:checkArmor("yellowhat")

		local damage = 200 + (200 * (0.2 * yellowhat_count))

		if target.defense >= 99 then
			damage = 0
		end

		damage = math.ceil(damage / target:getResistance("ELEC"))

		return damage
	end
end

return spell
