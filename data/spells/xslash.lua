local spell, super = Class(Spell, "xslash")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "X-Slash"
    -- Name displayed when cast (optional)
    self.cast_name = "X-SLASH"

    -- Battle description
    self.effect = "Physical\nDamage"
    -- Menu description
    self.description = "Deals large physical damage to 1 enemy."
    -- Check description
    self.check = "Deals large physical damage to 1 enemy."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    local function generateSlash(count)
        user:setAnimation("battle/attack")
        user:flash()
        local a = AfterImage(user, 1)
        a.physics.speed_x = 2.5
        a.layer = user.layer - 1
        Game.battle:addChild(a)
		a = AfterImage(user, 0.6)
        a.physics.speed_x = 5
        a.layer = user.layer - 2
        Game.battle:addChild(a)

        if (count % 2) ~= 0 then
            Assets.playSound("scytheburst", 1, 1.2)
        else
            Assets.playSound("scytheburst", 1, 0.8)
        end

        if target.health <= 0 then
            target = Game.battle.enemies[1]
        end
        local x, y = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
        local attacksprite = user.chara:getWeapon() and user.chara:getWeapon():getAttackSprite(user, enemy) or user.chara:getAttackSprite()
        local dmg_sprite = Sprite(attacksprite or "effects/attack/cut", x, y)
        dmg_sprite:setOrigin(0.5, 0.5)
        if (count % 2) ~= 0 then
            dmg_sprite:setScale(2, 2)
        else
            dmg_sprite:setScale(-2, 2)
        end
        dmg_sprite.layer = target.layer + 0.1
        dmg_sprite:play(1 / 15, false, function() dmg_sprite:remove() end)
        Game.battle:addChild(dmg_sprite)

        local damage = self:getDamage(user, target)
        target:hurt(damage, user)
    end

	Game.battle.timer:script(function(wait)
        local total_slashes = 2 -- easily customizable baby

        for i = 1, total_slashes do
            generateSlash(i)
            wait(14 / 30)
            if target.health <= 0 and #Game.battle:getActiveEnemies() == 0 then
                break
            end
        end

        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:getDamage(user, target)
    local damage = MathUtils.round((user.chara:getStat("attack") * 150 / 20 - target.defense * 3) * 1.25)

    return damage
end

return spell
