local spell, super = Class(Spell, "flower_barrage")

function spell:init()
    super.init(self)

    self.name = "F. Barrage"
	self.cast_name = "FLOWER BARRAGE"

    self.effect = "Flower\nCircle"
    self.description = "Summons a flower circle around the enemy,\nwhich." -- uhh can't find the proper words to finish it
	self.check = {"Deals massive\ndamage to one enemy.", "* Depends on Magic."}

    self.cost = 70

    self.target = "enemy"

    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = self:getDamage(user, target)
	self.flower_count = 0
	self.flowers = {}
	local targetX, targetY = target:getRelativePos(target.width/2, target.height/2, Game.battle)

	for i = 1, 6 do
		local flower = Sprite("effects/spells/ceroba/flower")
		flower:setOrigin(0.5, 0.5)
		flower:setScale(1, 1)
		if self.flower_count == 0 then
			flower:setPosition(targetX + 25, targetY - 25)
		elseif self.flower_count == 1 then
			flower:setPosition(targetX + 40, targetY)
		elseif self.flower_count == 2 then
			flower:setPosition(targetX + 25, targetY + 25)
		elseif self.flower_count == 3 then
			flower:setPosition(targetX - 25, targetY + 25)
		elseif self.flower_count == 4 then
			flower:setPosition(targetX - 40, targetY)
		elseif self.flower_count == 5 then
			flower:setPosition(targetX - 25, targetY - 25)
		else
			flower:setPosition(targetX, targetY)
		end
		flower.layer = target.layer + 1
		flower:play(1/15, true)
		Game.battle:addChild(flower)
		table.insert(self.flowers, flower)
		self.flower_count = self.flower_count + 1
	end

	Game.battle.timer:after(0.35, function()
		Assets.playSound("ceroba_swoosh", 3)
		Game.battle.timer:after(0.3, function()
			for _,flower in ipairs(self.flowers) do
				flower:slideTo(targetX, targetY, 0.2)
			end
		end)
		Game.battle.timer:after(0.5, function()
			for _,flower in ipairs(self.flowers) do
				flower:remove()
			end
			local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
			explosion:setOrigin(0.5, 0.5)
			explosion:setScale(1, 1)
			explosion.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(explosion)
			Assets.playSound("ceroba_boom")
			explosion:play(1/10, false, function(this)
				this:remove()
			end)
		end)
	end)

	Game.battle.timer:after(0.85, function()
		target:hurt(damage, user)
	end)

	Game.battle.timer:after(1, function()
		Game.battle:finishActionBy(user)
	end)

	return false
end

function spell:onLightCast(user, target)
	local damage = self:getDamage(user, target)

	local diamond = Sprite("effects/spells/ceroba/diamond")
	diamond:setOrigin(0.5, 0.5)
	diamond:setScale(3, 3)
	diamond:setPosition(targetX, targetY)
	diamond.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
	Assets.playSound("trap")
	diamond:play(1/15, false, function(s) s:fadeOutAndRemove(0.1) end)
	Game.battle:addChild(diamond)

	Game.battle.timer:after(0.65, function()
		target:hurt(damage, user)
	end)

	Game.battle.timer:after(0.8, function()
		Game.battle:finishActionBy(user)
	end)

	return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        return math.ceil(((user.chara:getStat("magic") - 2) * 8) + 45 + Utils.random(5))
    else
		return math.ceil(((user.chara:getStat("magic") - 10) * 10) + 75 + Utils.random(10))
    end
end

return spell
