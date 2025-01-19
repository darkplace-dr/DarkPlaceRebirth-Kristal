local spell, super = Class(Spell, "flowershot")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "FlowerShot"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Damage w/\nFLOWERS"
    -- Menu description
    self.description = "Throws a magical flower at all enemies\nthat explodes upon impact."

    -- TP cost
    self.cost = 80

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemies"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:onCast(user, target)

	for _,enemy in ipairs(target) do
		local targetX, targetY = enemy:getRelativePos(enemy.width/2, enemy.height/2, Game.battle)
		local userX, userY = user:getRelativePos(user.width, user.height/2, Game.battle)

    	Game.battle.timer:script(function(wait)
			wait(10/30)

			Assets.playSound("ceroba_bullet_shot")
			local bigflower = Sprite("effects/spells/ceroba/flower_large", userX+32, userY)
			bigflower:setOrigin(0.5, 0.5)
			bigflower:setScale(1, 1)
			bigflower.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(bigflower)
			bigflower:play(1/10)
			bigflower:slideToSpeed(targetX, targetY, 20, function()
				local damage = math.ceil(((user.chara:getStat("magic") - 11) * 9) + 30 + Utils.random(10))
				enemy:hurt(damage, user)

				Assets.playSound("damage")
				Assets.playSound("ceroba_boom")
				enemy:shake(6, 0, 0.5)
				bigflower:remove()
				local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
				explosion:setOrigin(0.5, 0.5)
				explosion:setScale(1, 1)
				explosion.layer = BATTLE_LAYERS["above_battlers"]
				Game.battle:addChild(explosion)
				explosion:play(1/10, false, function(this)
					this:remove()
				end)
			end)

       		wait(1/30)
    	end)

		Game.battle.timer:after(1.65, function()
			Game.battle:finishActionBy(user)
		end)
	end

    return false
end

function spell:onLightCast(user, target)

	for _,enemy in ipairs(target) do
		local targetX, targetY = enemy:getRelativePos(enemy.width/2, enemy.height/2, Game.battle)

    	Game.battle.timer:script(function(wait)
			wait(10/30)

			Assets.playSound("ceroba_bullet_shot")
			local bigflower = Sprite("effects/spells/ceroba/flower_large", 320, 580)
			bigflower:setOrigin(0.5, 0.5)
			bigflower:setScale(2, 2)
			bigflower.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(bigflower)
			bigflower:play(1/10)
			bigflower:slideToSpeed(targetX, targetY, 20, function()
				local damage = math.ceil((user.chara:getStat("magic") * 7) + 15 + Utils.random(5))
				enemy:hurt(damage, user)

				Assets.playSound("damage")
				Assets.playSound("ceroba_boom")
				enemy:shake(6, 0, 0.5)
				bigflower:remove()
				local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
				explosion:setOrigin(0.5, 0.5)
				explosion:setScale(2, 2)
				explosion.layer = BATTLE_LAYERS["above_battlers"]
				Game.battle:addChild(explosion)
				explosion:play(1/10, false, function(this)
					this:remove()
				end)
			end)

       		wait(1/30)
    	end)

		Game.battle.timer:after(1.65, function()
			Game.battle:finishActionBy(user)
		end)
	end

    return false
end

return spell