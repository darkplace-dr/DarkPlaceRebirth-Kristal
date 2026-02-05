local Pebblin, super = Class(EnemyBattler)

function Pebblin:init()
    super.init(self)

    self.name = "Pebblin"
    self:setActor("pebblin")

    self.max_health = 150
    self.health = 150
    self.attack = 3
    self.defense = 5
    self.money = 15
    if Game.world.map.id == "grey_cliffside/cliffside_right_3" then
        self.experience = 10
    else
        self.experience = 3
    end

    self.killable = true

    self.spare_points = 20

    self.waves = {
        "pebblin/pebbledrop",
        "pebblin/club"
    }

    self.dialogue = {
        "..."
    }

    self.check = "AT 3 DF 5\n* Proud warrior of Cliffside.\n* Has a cobbled together club."

    self.text = {
        "* Pebblin readies their club.",
        "* Pebblin might be taking this fight for granite.",
        "* Smells like andesite."
    }
    self.low_health_text = "* Pebblin is starting to errode."

    self:registerAct("Polish")
    self:registerAct("X-Polish", "", {"susie"})
end

function Pebblin:onAct(battler, name)
    if name == "Polish" then
        self:addMercy(100)
        self.dialogue_override = "Dziekuje!"
        return "* You cooked some Perogis for Pebblin.\n* It looks like they were just hungry."

    elseif name == "X-Polish" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.id == "pebblin" then
                enemy:setTired(true)
                enemy.attack = enemy.attack + 2
                enemy.dialogue_override = "...?!"
            end
        end
        return {
            "* Susie said some Polish swear words.",
            "* The Pebblin became angry!\n* Their attack increased, but they became [color:blue]TIRED[color:reset]!"
        }

    elseif name == "Standard" then --X-Action
        self:addMercy(50)
        return "* "..battler.chara:getName().." tried to polish Pebblin's club."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Pebblin:onDefeat(damage, battler)
    self:onDefeatFatal(damage, battler)
    return
end

function Pebblin:onDefeatFatal(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("vaporized", 1.2)

    local sprite = self:getActiveSprite()

    sprite.visible = false
    sprite:stopShake()

    local death_x, death_y = sprite:getRelativePos(0, 0, self)
    local death
    death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() self:remove() end)
     
    death:setColor(sprite:getDrawColor())
    death:setScale(sprite:getScale())
    self:addChild(death)

    self:defeat("KILLED", true)
end

return Pebblin