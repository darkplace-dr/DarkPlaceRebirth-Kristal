local spell, super = Class(Spell, "allegro")

function spell:init()
    super:init(self)

    -- Display name
    self.name = "Allegro"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "20%\nDamage"
    -- Menu description
    self.description = "Attack that deals 20% of the targets current HP. Such best against bosses who barely took damage."

    -- TP cost
    self.cost = 100

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." swings with extreme speed and accuracy and hit "..self:getCastName().." three times!"
end

function spell:onCast(user, target)
    
    target:flash()
    damage = math.ceil(target.health/15)
    target:hurt(damage, battler)
    target:hurt(damage, battler)
    target:hurt(damage, battler)
    Game.battle:finishActionBy(user)

    return false
end

return spell