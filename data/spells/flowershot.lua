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
    self.description = "Summons a large flower that shoots smaller\nflowers that explode upon impact."

    -- TP cost
    self.cost = 80

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemies"

    -- Tags that apply to this spell
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
	bigflower.layer = BATTLE_LAYERS["above_bullets"] + 1
	Game.battle:addChild(bigflower)
	bigflower:play(1/10)
	bigflower:slideToSpeed(320, 240, 20, function()
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
			flower.layer = BATTLE_LAYERS["above_bullets"]
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
				explosion.layer = BATTLE_LAYERS["above_battlers"]
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