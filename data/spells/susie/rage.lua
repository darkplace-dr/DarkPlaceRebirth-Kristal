local spell, super = Class(Spell, "rage")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Rage"
    -- Name displayed when cast (optional)
    self.cast_name = "RAGE"

    -- Battle description
    self.effect = "Enrage\nself"
    -- Menu description
    self.description = "Consume yourself with RAGE for a few turns and attack much stronger and uncontrollably."

    -- TP cost
    self.cost = 32

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "none"

    -- Tags that apply to this spell
    self.tags = {"rage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." goes into a RAGE!"
end

function spell:onCast(user, target)
	targer = Game.battle:getActiveEnemies()[love.math.random(#Game.battle:getActiveEnemies())]
	user.chara.rage = true
	user.chara.rage_counter = 6
	user:setAnimation("battle/attack")
    Assets.playSound("scytheburst")
    Assets.playSound("criticalswing", 1.2, 1.3)
	
	Game.battle.timer:after(15/30, function()
		local damage = math.ceil(((user.chara:getStat("attack") * 100) / 5) - (targer.defense * 3))
		
		targer:hurt(damage, user)
		Assets.playSound("damage")
		user:setAnimation("battle/idle")
		Game.battle.timer:after(15/30, function()
			Game.battle:finishAction()
		end)
	end)
	return false
end

return spell