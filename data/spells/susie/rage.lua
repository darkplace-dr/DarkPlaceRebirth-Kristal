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

    -- Target mode (ally, party, target, enemies, or none)
    self.target = "enemies"

    -- Tags that apply to this spell
    self.tags = {"rage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." goes into a RAGE!"
end

function spell:onCast(user, target)
	target = TableUtils.pick(target)
	user.chara.rage = true
	user.chara.rage_counter = 6
    Assets.playSound("scytheburst")
    Assets.playSound("criticalswing", 1.2, 1.3)
	user:setAnimation("battle/attack", function()
        local damage = self:getDamage(user, target)

        -- copied some stuff from normal attacking code to make it look like one
        if damage > 0 then
            Game:giveTension(MathUtils.round(target:getAttackTension(450)))

            local attacksprite = user.chara:getWeapon() and user.chara:getWeapon():getAttackSprite(user, target, 450) or user.chara:getAttackSprite()
            local dmg_sprite = Sprite(attacksprite or "effects/attack/cut")
            dmg_sprite:setOrigin(0.5, 0.5)
            dmg_sprite:setScale(2.5, 2.5) -- same size as a critical hit
            local relative_pos_x, relative_pos_y = target:getRelativePos(target.width / 2, target.height / 2)
            dmg_sprite:setPosition(relative_pos_x + target.dmg_sprite_offset[1], relative_pos_y + target.dmg_sprite_offset[2])
            dmg_sprite.layer = target.layer + 0.01
            dmg_sprite.battler_id = user.chara.id
            table.insert(target.dmg_sprites, dmg_sprite)
            dmg_sprite:play(1 / 15, false, function(s) s:remove(); TableUtils.removeValue(target.dmg_sprites, dmg_sprite) end)
            target.parent:addChild(dmg_sprite)

            local sound = target:getDamageSound() or "damage"
            if sound and type(sound) == "string" then
                Assets.stopAndPlaySound(sound)
            end
            target:hurt(damage, user)

            user.chara:onAttackHit(target, damage)
        else
            target:hurt(0, user, nil, nil, nil, true)
        end

        for _, item in ipairs(user.chara:getEquipment()) do
            item:onAttackHit(user, target, damage)
        end

		Game.battle.timer:after(15/30, function()
            user:setAnimation("battle/idle")
			Game.battle:finishAction()
		end)
    end)

	return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local damage = math.ceil(((user.chara:getStat("attack") * 50) / 3) - (target.defense * 3))
        return damage
    else
        local _, yellowhat_count = user.chara:checkArmor("yellowhat")

        local attack_part = (user.chara:getStat("attack") * 100) / 5
        local damage = math.ceil(attack_part + attack_part * (0.2 * yellowhat_count) - (target.defense * 3))

        local weapon = user.chara:getWeapon()
        if weapon and weapon.id == "berserkeraxe" then -- taken from normal attack code
            damage = damage * 2
        end

        return damage
    end
end

return spell