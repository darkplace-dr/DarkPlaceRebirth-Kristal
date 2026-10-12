local Kawkaw, super = Class(EnemyBattler)

function Kawkaw:init()
    super.init(self)

    self.name = "Kawkaw"
    self:setActor("kawkaw")
    self:setAnimation("idle")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 270

    self.spare_points = 10

    self.waves = {
        --"kawkaw/falling_feathers",
        --"kawkaw/pchoo"
    }

    self.text = {
        "* Kawkaw makes ueueueueue noises.",
        "* Kawkaw wants to play with a throwing toy.",
        "* Kawkaw pecks the ground looking for treats.",
        "* Kawkaw gathers sticks for nest and fetch."
    }

    self.low_health_text = "* Kawkaw is licking its wounds."
    self.tired_text = "* Kawkaw is ready to sleep in a nest."
    self.spareable_text = "* Kawkaw looks peaceful."

    self.low_health_percentage = 1/4

    self:registerAct("Hoop", "60%\nMercy")
    self:registerAct("ShooOrCall", "Leave\nor Love", {"susie", "ralsei"})
    
    self.slowsoul = false
end

function Kawkaw:update()
    super.update(self)

    if self.slowsoul == true then
        if Game.battle.soul then
            Game.battle.soul.speed = 2
            
            if #Game.stage:getObjects(SoulSlime) == 0 then
                Game.battle:addChild(SoulSlime(Game.battle.soul.x, Game.battle.soul.y))
            end
        end
    end
end

function Kawkaw:isXActionShort(battler)
    return true
end

function Kawkaw:onAct(battler, name)
    if name == "Check" then
        return "* KAWKAW - It thinks battle is play.[wait:5] Loves scarecrows."

    elseif name == "Hoop" then
        return

    elseif name == "ShooOrCall" then
        return

    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Kawkaw:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(25)
            local text = {
                "* Susie cawed like a bird!",
                "* Susie pets aggressively!",
                "* Susie rides on Kawkaw's back!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            local text = {
                "* Ralsei offers shiny trinkets!",
                "* Ralsei pats on the head!",
                "* Ralsei sings in crow song!"
            }
            return TableUtils.pick(text)
        end
    end
    return nil
end

function Kawkaw:getEncounterText()
    if Game.battle:getEnemyBattler("shi") then
        return "* Shi wants Kawkaw to go!\n* Kawkaw wants to play with Shi!"
    end

    return super.getEncounterText(self)
end

function Kawkaw:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

    Game.battle.timer:after(1 / 30, function() Assets.stopAndPlaySound("kawkaw/damage") end)
end

return Kawkaw