local spell, super = Class(Spell, "flower_barrage")

function spell:init()
    super.init(self)

    self.name = "F. Barrage"
	self.cast_name = "FLOWER BARRAGE"

    self.effect = "Flower\nCircle"
    self.description = "Summons a flower circle around the enemy,\nwhich." -- uhh can't find the proper words to finish it
	self.check = {"Deals massive\ndamage to one enemy.", "* Depends on Magic."}

    self.cost = 40

    self.target = "enemy"

    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target) -- Thank you Copilot for rewriting this code, I'll be sure to use you sparingly tho since I don't wanna rely on a stinkin AI 24/7 - BrendaK7200
    local damage = self:getDamage(user, target)
    self.flowers = {}
    local targetX, targetY = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
    local positions = {
        {25, -25}, {40, 0}, {25, 25}, {-25, 25}, {-40, 0}, {-25, -25}
    }

    -- Function to create a flower at a specific position
    local function createFlower(index)
        local offsetX, offsetY = unpack(positions[index])
        local flower = Sprite("effects/spells/ceroba/flower")
        flower:setOrigin(0.5, 0.5)
        flower:setScale(1, 1)
        flower:setPosition(targetX + offsetX, targetY + offsetY)
        flower.layer = target.layer + 1
        flower.alpha = 0 -- Start fully transparent
        flower:fadeTo(1, 0.1) -- Fade in over 0.1 seconds
        flower:play(1 / 15, true)
        Game.battle:addChild(flower)
        table.insert(self.flowers, flower)
    end

    -- Create flowers one by one with a delay
    for i = 1, #positions do
        Game.battle.timer:after((i - 1) * 0.1, function()
            createFlower(i)
        end)
    end

    -- After all flowers are created, reel them back (enlarge the circle) and then close in
    Game.battle.timer:after(#positions * 0.1 + 0.35, function()
        Assets.playSound("ceroba_swoosh", 3)

        -- Reel back: enlarge the circle
        for i, flower in ipairs(self.flowers) do
            local offsetX, offsetY = unpack(positions[i])
            local reelBackX = offsetX * 1.5 -- Enlarge the circle by 1.5x
            local reelBackY = offsetY * 1.5
            flower:slideTo(targetX + reelBackX, targetY + reelBackY, 0.3, "out-cubic")
        end

        -- Close in after reeling back
        Game.battle.timer:after(0.3, function()
            for _, flower in ipairs(self.flowers) do
                flower:slideTo(targetX, targetY, 0.1, "in-cubic")
            end
        end)

        -- Remove flowers and create explosion
        Game.battle.timer:after(0.5, function()
            for _, flower in ipairs(self.flowers) do
                flower:remove()
            end
            local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
            explosion:setOrigin(0.5, 0.5)
            explosion:setScale(1, 1)
            explosion.layer = BATTLE_LAYERS["above_battlers"]
            Game.battle:addChild(explosion)
            Assets.playSound("ceroba_boom")
            explosion:play(1 / 10, false, function(this)
                this:remove()
            end)
        end)
    end)

    -- Deal damage to the target
    Game.battle.timer:after(#positions * 0.1 + 0.85, function()
        target:hurt(damage, user)
    end)

    -- Finish the action
    Game.battle.timer:after(#positions * 0.1 + 1, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
	local damage = self:getDamage(user, target)
    self.flowers = {}
    local targetX, targetY = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
    local positions = {
        {50, -50}, {80, 0}, {50, 50}, {-50, 50}, {-80, 0}, {-50, -50}
    }

    -- Function to create a flower at a specific position
    local function createFlower(index)
        local offsetX, offsetY = unpack(positions[index])
        local flower = Sprite("effects/spells/ceroba/flower")
        flower:setOrigin(0.5, 0.5)
        flower:setScale(2, 2)
        flower:setPosition(targetX + offsetX, targetY + offsetY)
        flower.layer = target.layer + 1
        flower.alpha = 0 -- Start fully transparent
        flower:fadeTo(1, 0.1) -- Fade in over 0.1 seconds
        flower:play(1 / 15, true)
        Game.battle:addChild(flower)
        table.insert(self.flowers, flower)
    end

    -- Create flowers one by one with a delay
    for i = 1, #positions do
        Game.battle.timer:after((i - 1) * 0.1, function()
            createFlower(i)
        end)
    end

    -- After all flowers are created, reel them back (enlarge the circle) and then close in
    Game.battle.timer:after(#positions * 0.1 + 0.35, function()
        Assets.playSound("ceroba_swoosh", 3)

        -- Reel back: enlarge the circle
        for i, flower in ipairs(self.flowers) do
            local offsetX, offsetY = unpack(positions[i])
            local reelBackX = offsetX * 1.5 -- Enlarge the circle by 1.5x
            local reelBackY = offsetY * 1.5
            flower:slideTo(targetX + reelBackX, targetY + reelBackY, 0.3, "out-cubic")
        end

        -- Close in after reeling back
        Game.battle.timer:after(0.3, function()
            for _, flower in ipairs(self.flowers) do
                flower:slideTo(targetX, targetY, 0.1, "in-cubic")
            end
        end)

        -- Remove flowers and create explosion
        Game.battle.timer:after(0.5, function()
            for _, flower in ipairs(self.flowers) do
                flower:remove()
            end
            local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
            explosion:setOrigin(0.5, 0.5)
            explosion:setScale(2, 2)
            explosion.layer = BATTLE_LAYERS["above_battlers"]
            Game.battle:addChild(explosion)
            Assets.playSound("ceroba_boom")
            explosion:play(1 / 10, false, function(this)
                this:remove()
            end)
        end)
    end)

    -- Deal damage to the target
    Game.battle.timer:after(#positions * 0.1 + 0.85, function()
        target:hurt(damage, user)
    end)

    -- Finish the action
    Game.battle.timer:after(#positions * 0.1 + 1, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        return math.ceil(((user.chara:getStat("magic") - 2) * 8) + 45 + Utils.random(5))
    else
		return math.ceil(((user.chara:getStat("magic") - 10) * 10) + 75 + Utils.random(10))
    end
end

return spell
