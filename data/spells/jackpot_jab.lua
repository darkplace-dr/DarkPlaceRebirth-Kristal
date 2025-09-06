local spell, super = Class(Spell, "jackpot_jab")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Jackpot Jab"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Scaling\nDamage"
    -- Menu description
    self.description = "Momento of Hero Siffrin. Jab that gets stronger if you use it each turn non stop."

    -- TP cost
    self.cost = 10

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    local message = "* "..user.chara:getName().." performed "..self:getCastName().."!"
    if not Game:getFlag("JJS4") then
        return message
    else
        return message.."\n[wait:0.25s]* JACKPOT! Keep the streak!"
    end
end

function spell:onCast(user, target)
    
    target:flash()
    Game:setFlag("LastTurnJJ", true)
    local damage = math.ceil(((user.chara:getStat("attack") * 3)))
    Game.battle.timer:after(0.5, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    if Game:getFlag("JJS4") then
        Game.battle.timer:after(0.4, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
    end
    if Game:getFlag("JJS3") then
        Game.battle.timer:after(0.3, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS4", true)
    end
    if Game:getFlag("JJS2") then
        Game.battle.timer:after(0.2, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS3", true)
    end
    if Game:getFlag("JJS1") then
        Game.battle.timer:after(0.1, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS2", true)
    end
    Game:setFlag("JJS1", true)
    Game.battle:finishActionBy(user)

    return false
end

function spell:onCast(user, target)
    
    target:flash()
    Game:setFlag("LastTurnJJ", true)
    local damage = math.ceil(((user.chara:getStat("attack") * 3)))
    Game.battle.timer:after(0.5, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    if Game:getFlag("JJS4") then
        Game.battle.timer:after(0.4, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
    end
    if Game:getFlag("JJS3") then
        Game.battle.timer:after(0.3, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS4", true)
    end
    if Game:getFlag("JJS2") then
        Game.battle.timer:after(0.2, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS3", true)
    end
    if Game:getFlag("JJS1") then
        Game.battle.timer:after(0.1, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS2", true)
    end
    Game:setFlag("JJS1", true)
    Game.battle:finishActionBy(user)

    return false
end

function spell:onLightCast(user, target)
    
    target:flash()
    Game:setFlag("LastTurnJJ", true)
    local damage = math.ceil(((user.chara:getStat("attack") * 2)))
    Game.battle.timer:after(0.5, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    if Game:getFlag("JJS4") then
        Game.battle.timer:after(0.4, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
    end
    if Game:getFlag("JJS3") then
        Game.battle.timer:after(0.3, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS4", true)
    end
    if Game:getFlag("JJS2") then
        Game.battle.timer:after(0.2, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS3", true)
    end
    if Game:getFlag("JJS1") then
        Game.battle.timer:after(0.1, function()
            Assets.playSound("scytheburst")
            target:hurt(damage, user)
        end)
        Game:setFlag("JJS2", true)
    end
    Game:setFlag("JJS1", true)
    Game.battle:finishActionBy(user)

    return false
end

return spell