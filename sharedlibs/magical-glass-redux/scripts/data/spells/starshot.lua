local spell, super = Class("starshot", true)

function spell:onLightCast(user, target)
    user.delay_turn_end = true

    Game.battle.timer:script(function(wait)
		local x, y = (SCREEN_WIDTH/2), SCREEN_HEIGHT
		local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
		
        Assets.playSound("wish")
		Assets.playSound("bomb")

		Game.battle.starbasic = Sprite("effects/spells/dess/star_basic", x, y)
		Game.battle.starbasic:setOrigin(0.5, 0.5)
		Game.battle.starbasic:setScale(2)
		Game.battle.starbasic.layer = BATTLE_LAYERS["above_ui"]
		Game.battle:addChild(Game.battle.starbasic)
		Game.battle.starbasic:slideToSpeed(tx, ty, 20, function()
			local damage = math.ceil((user.chara:getStat("magic") * 2) + 50 + (Utils.random(5) * 2))
			target:hurt(damage, user)

			Assets.playSound("celestial_hit")
			Assets.playSound("damage")
			target:shake(6, 0, 0.5)

			Game.battle.starbasic:remove()

			Game.battle:finishActionBy(user)
		end)

		Game.battle.timer:every(0.01, function()
			local starparticle = Sprite("effects/spells/dess/rainbow_star", Game.battle.starbasic.x + Utils.random(32), Game.battle.starbasic.y + Utils.random(32))
			starparticle:setOrigin(0.5, 0.5)
			starparticle:setScale(2)
			starparticle.layer = Game.battle.starbasic.layer - 1
			Game.battle:addChild(starparticle)
			starparticle:play(0.1, false)
			starparticle:slideToSpeed(starparticle.x, starparticle.y+32, 2)
			starparticle:fadeOutAndRemove(0.5)
		end, 50)

        wait(1/30)
    end)

    return false
end

function spell:getDamage(user, target, pressed)
    if Game:isLight() then
        return super.getDamage(self, user, target, pressed)
    end
end

return spell