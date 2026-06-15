local spell, super = Class(Spell, "flowershot")

function spell:init()
    super.init(self)

    self.name = "FlowerShot"
    self.cast_name = nil

    self.effect = "Damage w/\nFLOWERS"
    self.description = "Summons a large flower that shoots smaller\nflowers that explode upon impact."
	self.check = {"Summons a large\nflower that shoots smaller\nflowers.", "* ...[wait:5] which explode upon impact."}

    self.cost = 50

    self.target = "enemies"

    self.tags = {"damage"}
end

function spell:onCast(user, target)
	local userX, userY = user:getRelativePos(user.width, user.height/2, Game.battle)
	Assets.playSound("ceroba_bullet_shot")
	local bigflower = Sprite("effects/spells/ceroba/flower_large", userX+32, userY)
	bigflower:setOrigin(0.5, 0.5)
	bigflower:setScale(2, 2)
	bigflower.layer = BATTLE_LAYERS["above_arena"] + 1
	Game.battle:addChild(bigflower)
	bigflower:play(1/10)
	bigflower:slideToSpeed(320, 180, 20, function()
		Game.battle.timer:after(1, function()
			bigflower:fadeOutAndRemove(0.5)
		end)
	end)
	for _,enemy in ipairs(target) do
		local targetX, targetY = enemy:getRelativePos(enemy.width/2, enemy.height/2, Game.battle)
    	Game.battle.timer:script(function(wait)
			wait(1)

			Assets.playSound("ceroba_bullet_shot")
			local flower = Sprite("effects/spells/ceroba/flower_large", bigflower.x, bigflower.y)
			flower:setOrigin(0.5, 0.5)
			flower:setScale(1, 1)
			flower.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(flower)
			flower:play(1/10)
			flower:slideToSpeed(targetX, targetY, 20, function()
				local damage = math.ceil(((user.chara:getStat("magic") - 10) * 9) + 30 + Utils.random(10))
				enemy:hurt(damage, user)

				Assets.playSound("damage")
				Assets.playSound("ceroba_boom")
				enemy:shake(6, 0, 0.5)
				flower:remove()
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

		Game.battle.timer:after(2.65, function()
			Game.battle:finishActionBy(user)
		end)
	end

    return false
end

function spell:onLightCast(user, target)
	Assets.playSound("ceroba_bullet_shot")
	local bigflower = Sprite("effects/spells/ceroba/flower_large", 320, 580)
	bigflower:setOrigin(0.5, 0.5)
	bigflower:setScale(3, 3)
	bigflower.layer = LIGHT_BATTLE_LAYERS["above_arena_border"] + 1
	Game.battle:addChild(bigflower)
	bigflower:play(1/10)
	bigflower:slideToSpeed(320, 320, 20, function()
		Game.battle.timer:after(1, function()
			bigflower:fadeOutAndRemove(0.5)
		end)
	end)
	for _,enemy in ipairs(target) do
		local targetX, targetY = enemy:getRelativePos(enemy.width/2, enemy.height/2, Game.battle)

    	Game.battle.timer:script(function(wait)
			wait(1)

			Assets.playSound("ceroba_bullet_shot")
			local flower = Sprite("effects/spells/ceroba/flower_large", bigflower.x, bigflower.y)
			flower:setOrigin(0.5, 0.5)
			flower:setScale(2, 2)
			flower.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
			Game.battle:addChild(flower)
			flower:play(1/10)
			flower:slideToSpeed(targetX, targetY, 20, function()
				local damage = math.ceil((user.chara:getStat("magic") * 7) + 15 + Utils.random(5))
				enemy:hurt(damage, user)

				Assets.playSound("damage")
				Assets.playSound("ceroba_boom")
				enemy:shake(6, 0, 0.5)
				flower:remove()
				local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
				explosion:setOrigin(0.5, 0.5)
				explosion:setScale(2, 2)
				explosion.layer = LIGHT_BATTLE_LAYERS["above_arena_border"] - 1
				Game.battle:addChild(explosion)
				explosion:play(1/10, false, function(this)
					this:remove()
				end)
			end)

       		wait(1/30)
    	end)

		Game.battle.timer:after(2, function()
			Game.battle:finishActionBy(user)
		end)
	end

    return false
end

return spell