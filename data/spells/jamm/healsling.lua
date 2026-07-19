local spell, super = Class(Spell, "healsling")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "HealSling"

    -- Battle description
    self.effect = "Healing\nService"
    -- Menu description
    self.description = "Slingshot healing bullets to an enemy, making them more likely to spare us."
    -- Check description
    self.check = "Slingshot healing bullets to an enemy, making\nthem more likely to spare us."

    -- Resource costs
    self.cost = 32
    self.mana_cost = 32

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:getName()
    if Game:getFlag("healsling_plus") then
        return "HealSling+"
    end
    return self.name
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:getLightCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local function generateSlash(scale_x)
		local cutAnim = Sprite("effects/attack/sling")
		Assets.playSound("scytheburst")
		Assets.playSound("criticalswing", 1.2, 1.3)
		user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
		user:toggleOverlay(true)
		local afterimage1 = AfterImage(user, 0.5)
		local afterimage2 = AfterImage(user, 0.6)
		user:toggleOverlay(false)
		afterimage1.physics.speed_x = 2.5
		afterimage2.physics.speed_x = 5
		afterimage2:setLayer(afterimage1.layer - 1)
		user:setAnimation("battle/attack", function()
			user:setAnimation("battle/idle")
		end)
		user:flash()
		cutAnim:setOrigin(0.5, 0.5)
		cutAnim:setScale(2.5 * scale_x, 2.5)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		cutAnim:play(1/15, false, function(s) s:remove() end)
		user.parent:addChild(cutAnim)
		user.parent:addChild(afterimage1)
		user.parent:addChild(afterimage2)
	end

	Game.battle.timer:after(0.1/2, function()
		generateSlash(1)

		local heal = self:getDamage(user, target)
		if heal > 0 then
			target:heal(heal)
		else
			target:statusMessage("msg", "miss", {0, 1, 0})
		end
		if target:canService(self.id) then
			target:addMercy(math.ceil(target.service_mercy * 1.3 * self:getMercyMult(user, target, heal)))
		end
		target:onService(self.id)
	end)
end

function spell:onLightCast(user, target)
	local function generateSlash(scale_x)
		local cutAnim = Sprite("effects/attack/sling")
		Assets.playSound("scytheburst")
		Assets.playSound("criticalswing", 1.2, 1.3)
		cutAnim:setOrigin(0.5, 0.5)
		cutAnim:setScale(2.5 * scale_x, 2.5)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		cutAnim:play(1/15, false, function(s) s:remove() end)
		Game.battle:addChild(cutAnim)
	end

	Game.battle.timer:after(0.1/2, function()
		generateSlash(1)

		local heal = self:getDamage(user, target)
		if heal > 0 then
			target:heal(heal)
		else
			target:lightStatusMessage("text", "MISS", {0, 1, 0})
		end
		if target:canService(self.id) then
			target:addMercy(math.ceil(target.service_mercy * 1.3 * self:getMercyMult(user, target, heal)))
		end
		target:onService(self.id)
	end)
end

function spell:isUsable(chara) return not chara.disarmed end

function spell:getDamage(user, target)
	if Game:isLight() then
		local damage = math.floor((user.chara:getStat("attack") * 3))

		if (Game.battle and Game.battle.headwind > 0) then
			damage = math.floor(damage * 1.25)
		end

		return damage
	else
		local _, yellowhat_count = user.chara:checkArmor("yellowhat")

		local damage = math.floor((user.chara:getStat("attack") * 15) + (user.chara:getStat("attack") * 15) * (0.2 * yellowhat_count))
		if Game:getFlag("healsling_plus") then
			damage = math.floor((user.chara:getStat("attack") * 30) + (user.chara:getStat("attack") * 30) * (0.2 * yellowhat_count))
		end

		if (Game.battle and Game.battle.headwind > 0) then
			damage = math.floor(damage * 1.25)
		end

		return damage
	end
end

function spell:getMercyMult(user, target, heal)
	if heal <= 0 then
		return 0
	end

	local mult = 1
	if target.health == target.max_health then
		mult = 0.5
	end

	if Game:isLight() then
		return mult
	else
		local _, yellowhat_count = user.chara:checkArmor("yellowhat")

		mult = mult + (0.2 * yellowhat_count)

		if Game:getFlag("jamm_skill_9") then
            mult = mult * 1.5
        end

        if (Game.battle and Game.battle.headwind > 0) then
            mult = math.floor(mult * 1.25)
        end

		return mult
	end
end

return spell
