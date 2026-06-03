local spell, super = Class(Spell, "siderostat")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Siderostat"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Reflect\nDamage"
    -- Menu description
    self.description = "Use mirroring tech to trick\nenemies and reflect one hit."
    -- Check description
    self.check = "Use mirroring tech to trick enemies and reflect one hit."

    -- TP cost
    self.cost = 100

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"dodge", "reflect", "parry"}
end

function spell:onCast(user, target)
	Assets.playSound("mirror")

	user:setAnimation("battle/snap")

	--local spellEffect = SaveBaseEffect()
	--Game.battle:addChild(spellEffect)

	Game.battle.timer:after(10/30, function(wait)
		for _,battler in ipairs(target) do
			battler.chara.reflectNext = true
			Assets.playSound("mirrorsetup")
			--local effect = MirrorEffect(battler.chara.actor.x, battler.chara.actor.y)
			local effect = MirrorEffect(battler.x, battler.y)
			effect.attached = battler
			--effect.texture = Assets.getTexture("party/"..battler.chara.id.."/battle/idle") or Assets.getTexture("party/"..battler.chara.id.."/battle/idle_1")
			effect:setActor(battler.actor)
			effect:set("battle/idle")
			Game.battle:addChild(effect)
		end
		
		

		--user:setAnimation("battle/idle")
		Game.battle.timer:after(10/30, function(wait)
			Game.battle:finishActionBy(user)
		end)
	end)

	return false
end

return spell