local spell, super = Class(Spell, "allegro")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Allegro"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "20%\nDamage"
    -- Menu description
    self.description = "Attack that deals about 20% of the targets current HP. Such best against bosses who barely took damage."

    -- TP cost
    self.cost = 100

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." swings with extreme speed and accuracy and hits "..self:getCastName().." three times!"
end

function spell:getLightCastMessage(user, target)
    return "* "..user.chara:getName().." swings with extreme speed and accuracy and hits "..self:getCastName().." three times!"
end

function spell:onCast(user, target)
    local damage = math.ceil(target.health/15) + Utils.clamp((user.chara:getStat("attack")*2)-28, 0, 50)
    local orig_pos_x, orig_pos_y = user.x, user.y
    Assets.playSound("shakerbreaker")
    user:slideTo(target.x - 80, target.y, 0.5)
    Game.battle.timer:after(1, function()
        user:slideTo(target.x + 80, target.y, 0.1)
        Assets.playSound("scytheburst")
        target:flash()
        target:hurt(damage, user)
        Game.battle.timer:after(0.1, function()
            user.flip_x = true
        end)
    end)
    Game.battle.timer:after(1.5, function()
        user:slideTo(target.x - 80, target.y, 0.1)
        Assets.playSound("scytheburst")
        target:flash()
        target:hurt(damage, user)
        Game.battle.timer:after(0.1, function()
            user.flip_x = false
        end)
    end)
    Game.battle.timer:after(2, function()
        user:slideTo(target.x + 80, target.y, 0.1)
        Assets.playSound("scytheburst")
        target:flash()
        target:hurt(damage, user)
        Game.battle.timer:after(0.1, function()
            user.flip_x = true
        end)
    end)
    Game.battle.timer:after(3, function()
        user.flip_x = false
        user:slideTo(orig_pos_x, orig_pos_y, 0.5)
    end)
    Game.battle.timer:after(4, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
    local damage = math.ceil(target.health/15) + Utils.clamp((user.chara:getStat("attack"))-14, 0, 50)
    Game.battle.timer:after(0.5, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    Game.battle.timer:after(1, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    Game.battle.timer:after(1.5, function()
        Assets.playSound("scytheburst")
        target:hurt(damage, user)
    end)
    Game.battle.timer:after(2, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

return spell