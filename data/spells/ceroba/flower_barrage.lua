local spell, super = Class(Spell, "flower_barrage")

function spell:init()
    super.init(self)

    self.name = "F. Barrage"
	self.cast_name = "FLOWER BARRAGE"

    self.effect = "Flower\nCircle"
    self.description = "Summons a circle of flowers around the enemy,\nwhich fly towards them, making an explosion."
	self.check = {"Summons a circle of flowers around the enemy, which fly towards them.", "* And then make an explosion."}

    self.cost = 40

    self.target = "enemy"

    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    local flowers = {}

    local bullet_number_max = 6
    local bullet_speed = 12
    local attack_dir = MathUtils.randomInt(0, 360)

    local function explosion()
        Assets.playSound("ceroba_boom")
        local boom = Sprite("effects/spells/ceroba/explosion", target.x, target.y - target.height)
        boom:setOrigin(0.5)
        boom:setScale(1)
        boom.layer = BATTLE_LAYERS["above_battlers"] + 1
        boom:play(1/12, false, function() boom:remove() end)
        Game.battle:addChild(boom)
    end

    Game.battle.timer:after(0.25, function()
        for i = 1, bullet_number_max do
            Game.battle.timer:after((i * 5) / 30, function()
                local flower = FlowerBarrageBullet(target.x, target.y - target.height, bullet_speed, attack_dir, function()
                    if i == bullet_number_max then
                        explosion()
                        Game.battle:shakeCamera(5, 5)
                        local damage = self:getDamage(user, target)
                        target:hurt(damage, user)
                    end
                end)
                flower.layer = BATTLE_LAYERS["above_battlers"]
                table.insert(flowers, flower)
                Game.battle:addChild(flower)
            end)
        end
        Game.battle.timer:after(((bullet_number_max * 5) + 6) / 30, function()
            for _, flower in ipairs(flowers) do
                flower.state = 1
            end
        end)
    end)

    Game.battle.timer:after(0.25 + ((bullet_number_max * 5) + 6) / 30 + 1, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
	local flowers = {}

    local bullet_number_max = 6
    local bullet_speed = 12
    local attack_dir = MathUtils.randomInt(0, 360)

    local function explosion()
        Assets.playSound("ceroba_boom")
        local boom = Sprite("effects/spells/ceroba/explosion", target.x, target.y - target.height)
        boom:setOrigin(0.5)
        boom:setScale(2)
        boom.layer = LIGHT_BATTLE_LAYERS["above_arena_border"] + 1
        boom:play(1/12, false, function() boom:remove() end)
        Game.battle:addChild(boom)
    end

    Game.battle.timer:after(0.25, function()
        for i = 1, bullet_number_max do
            Game.battle.timer:after((i * 5) / 30, function()
                local flower = FlowerBarrageBullet(target.x, target.y - target.height, bullet_speed, attack_dir, function()
                    if i == bullet_number_max then
                        explosion()
                        Game.battle:shakeCamera(5, 5)
                        local damage = self:getDamage(user, target)
                        target:hurt(damage, user)
                    end
                end)
                flower:setScale(2)
                flower.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
                table.insert(flowers, flower)
                Game.battle:addChild(flower)
            end)
        end
        Game.battle.timer:after(((bullet_number_max * 5) + 6) / 30, function()
            for _, flower in ipairs(flowers) do
                flower.state = 1
            end
        end)
    end)

    Game.battle.timer:after(0.25 + ((bullet_number_max * 5) + 6) / 30 + 1, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local damage = math.ceil((user.chara:getStat("magic") * 9) - (target.defense * 3))
        --damage = math.ceil(damage / target:getResistance("FLOWER")) -- do light enemies have that yet?
        return damage
    else
        local _, yellowhat_count = user.chara:checkArmor("yellowhat")
        local magic_part = user.chara:getStat("magic") * 13
        local damage = math.ceil(magic_part + (magic_part * (0.2 * yellowhat_count)) - (target.defense * 3))
        damage = math.ceil(damage / target:getResistance("FLOWER"))
		return damage
    end
end

return spell
