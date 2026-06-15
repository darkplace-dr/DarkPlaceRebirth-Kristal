---@class Starwalker : EnemyBattler
local Starwalker, super = Class(EnemyBattler)

function Starwalker:init()
    super.init(self)

    self.name = "Starwalker"
    self:setActor("starwalker")

    self.path = "enemies/starwalker"
    self.default = ""
    self.sprite:set("wings")

    self.max_health = 6000
    self.health = 6000
    self.attack = 8
    self.defense = 2
    self.money = 420
    self.experience = Mod:isInRematchMode() and 0 or 420
    self.service_mercy = 0
    
    self.boss = true
    self.milestone = true

    self.spare_points = 0

    self.killable = Mod:isInRematchMode() and false or true
    self.exit_on_defeat = false
    self.auto_spare = true

    self.movearound = true

    self.waves = {
        "starwalker/starwings",
        "starwalker/starwingsfaster",
        "starwalker/starwingscomet",
        "starwalker/starwingshyper",
        "starwalker/starcomets",
    }

    self.check = "The   original\n            ."

    self.text = {
        "* Star walker",
        "* Smells like   [color:yellow]pissed off[color:reset]",
        "*               this encounter\n is against star  walker",
        "* this [color:yellow]battle[color:reset] is     [color:yellow]pissing[color:reset] me\noff...",
        "* Smells like a subtle DeltaRaid reference."
    }

    self.low_health_text = "* Star walker is [color:yellow]Pissed[color:reset] off..."

    self:registerAct("Star walker", "")

    local description = "Red\ndamage"
    if Game.chapter <= 3 then
        description = "Red\nDamage"
    end

    self:registerAct("Red Buster", description, "susie", 60)
    self:registerAct("DualHeal", "Heals\neveryone", "ralsei", 50)

    self.text_override = nil
	
    self.old_x = self.x
    self.old_y = self.y

    self.mode = "normal"
    self.ease = false

    self.ease_timer = 0

    self.timer = 0

    self.progress = 0

    self.blue = false
end

function Starwalker:getHealthDisplay()
    return math.ceil(100 + (100 - (self.health / self.max_health) * 100)) .. "%"
end

function Starwalker:getTarget()
    return "ALL"
end

function Starwalker:makeBullet(x, y)
    if (MathUtils.random() < 0.25) then
        return Registry.createBullet("SW_FallenStarBullet", x, y)
    end

    return Registry.createBullet("SW_StarBullet", x, y)
end

function Starwalker:makeCometBullet(x, y)
    if (MathUtils.random() < 0.25) then
        return Registry.createBullet("SW_FallenStarComet", x, y)
    end

    return Registry.createBullet("SW_StarComet", x, y)
end

function Starwalker:getGrazeTension()
    return 0
end

function Starwalker:onTurnEnd()
    self.progress = self.progress + 1
	
    if self.progress > 10 then
        self.progress = 2
    end
end

function Starwalker:getEncounterText()

    if (self.progress == 2) then
        return "* Star walker is preparing\n[color:blue]something [offset:0,-8][color:red][font:main_mono,48]!!"
    end
    return super.getEncounterText(self)
end

function Starwalker:getNextWaves()
    if (self.progress == 0) then
        return {"starwalker/starwings"}
    elseif (self.progress == 1) then
        return {"starwalker/starwingsfaster"}
    elseif (self.progress == 2) then
        return {"starwalker/staract"}
    elseif (self.progress == 3) then
        self.blue = true
        return {"starwalker/starwings"}
    elseif (self.progress == 4) then
        self.blue = true
        return {"starwalker/starcomets"}
    elseif (self.progress == 5) then
        self.blue = true
        return {"starwalker/starup"}
    elseif (self.progress == 6) then
        self.blue = true
        return {"starwalker/stardust"}
    elseif (self.progress == 7) then
        return {"starwalker/starwingshyper"}
    end

    return super.getNextWaves(self)
end

function Starwalker:setMode(mode)
    self.mode = mode
    self.old_x = self.x
    self.old_y = self.y
    self.ease = true
    self.ease_timer = 0
end

function Starwalker:update()
    super.update(self)

    if not self.done_state and (Game.battle:getState() ~= "TRANSITION") then
        self.timer = self.timer + (1 * DTMULT)

        local wanted_x = self.old_x
        local wanted_y = self.old_y

        if self.mode == "normal" then
            wanted_x = 530 + (math.sin(self.timer * 0.08) * 20)
            wanted_y = 238 + (math.sin(self.timer * 0.04) * 10)
        elseif self.mode == "shoot" then
            wanted_x = 530 - 40 + (math.sin(self.timer * 0.08) * 10)
            wanted_y = 238 - 50 + (math.sin(self.timer * 0.04) * 40)
        elseif self.mode == "still" then
            wanted_x = 530 - 40
            wanted_y = 238 - 50
        elseif self.mode == "flying" then
            wanted_x = 530 - 205 + (math.sin(self.timer * 0.06) * 100)
            wanted_y = 238 - 108 + (math.sin(self.timer * 0.2) * 10)
        end

        if not self.ease then
            self.x = wanted_x
            self.y = wanted_y
        else
            self.ease_timer = self.ease_timer + (0.05 * DTMULT)
            self.x = Ease.outQuad(self.ease_timer, self.old_x, wanted_x - self.old_x, 1)
            self.y = Ease.outQuad(self.ease_timer, self.old_y, wanted_y - self.old_y, 1)
            if self.ease_timer >= 1 then
                self.ease = false
            end
        end
    end

    for _,enemy in pairs(Game.battle.enemy_world_characters) do
        enemy:remove()
    end
end

function Starwalker:isXActionShort(battler)
    return true
end

function Starwalker:onActStart(battler, name)
    super.onActStart(self, battler, name)
end

function Starwalker:onAct(battler, name)
    if name == "DualHeal" then
        Game.battle:powerAct("dual_heal", battler, "ralsei")
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie", self)
    elseif name == "Star walker" then
        self:addMercy(8)
        return "* The Original Starwalker  absorbs the\nACT"
    elseif name == "Standard" then
        if Game:isDessMode() then
            self:addMercy(12)
        else
            self:addMercy(4)
        end

        if battler.chara.id == "ralsei" then
            Game:gameOver(Game.world.player.x, Game.world.player.y)
            return "* Ralsei explodes and dies\n(it got [color:yellow]absorbed[color:reset])"
        elseif battler.chara.id == "susie" then
            return "* Susie more like sussy\n(it got [color:yellow]absorbed[color:reset])"
        elseif battler.chara.id == "bor" then
            return "* Bor got bored\n(it got [color:yellow]absorbed[color:reset])"
        else
            return "* " .. battler.chara.name .. " did a thing\n(it got [color:yellow]absorbed[color:reset])"
        end
    end
    return super.onAct(self, battler, name)
end

function Starwalker:onShortAct(battler, name)
    if name == "Standard" then
        if Game:isDessMode() then
            self:addMercy(12)
        else
            self:addMercy(4)
        end

        if battler.chara.id == "ralsei" then
            Game:gameOver(Game.world.player.x, Game.world.player.y)
            return "* Ralsei explodes and dies"
        elseif battler.chara.id == "susie" then
            return "* Susie more like sussy"
        elseif battler.chara.id == "bor" then
            return "* Bor got bored"
        else
            return "* " .. battler.chara.name .. " did a thing"
        end
    end
    return nil
end

function Starwalker:getEnemyDialogue()
    if self.text_override then
        local dialogue = self.text_override
        self.text_override = nil
        return dialogue
    end

    local dialogue
    if self.mercy >= 100 then
        dialogue = {
            "walk",
            "star"
        }
    else
        dialogue = {
            "star",
            "walker"
        }
    end
    return dialogue[math.random(#dialogue)]
end

function Starwalker:spare(pacify)
    if not self.exit_on_defeat then
        self:defeat(pacify and "PACIFIED" or "SPARED", false)
    else
        Game.battle.spare_sound:stop()
        Game.battle.spare_sound:play()

        local spare_flash = self:addFX(ColorMaskFX())
        spare_flash.amount = 0

        local sparkle_timer = 0
        local parent = self.parent

        Game.battle.timer:during(
            5 / 30,
            function()
                spare_flash.amount = spare_flash.amount + 0.2 * DTMULT
                sparkle_timer = sparkle_timer + DTMULT
                if sparkle_timer >= 0.5 then
                    local x, y = MathUtils.random(0, self.width), MathUtils.random(0, self.height)
                    local sparkle = SpareSparkle(self:getRelativePos(x, y))
                    sparkle.layer = self.layer + 0.001
                    parent:addChild(sparkle)
                    sparkle_timer = sparkle_timer - 0.5
                end
            end, function()
                spare_flash.amount = 1
                local img1 = AfterImage(self, 0.7, (1 / 25) * 0.7)
                local img2 = AfterImage(self, 0.4, (1 / 30) * 0.4)
                img1:addFX(ColorMaskFX())
                img2:addFX(ColorMaskFX())
                img1.physics.speed_x = 4
                img2.physics.speed_x = 8
                parent:addChild(img1)
                parent:addChild(img2)
                self:remove()
            end
        )
        self:defeat(pacify and "PACIFIED" or "SPARED", false)
    end
    self:onSpared()
end

function Starwalker:onSpared()
    super.onSpared(self)

    self.sprite:resetSprite()
    Game.battle.music:stop()
end

function Starwalker:onDefeat(damage, battler)
    self.exit_on_defeat = true
    super.onDefeat(self, damage, battler)
end

return Starwalker
