local Dess, super = Class(Encounter)

function Dess:init()
    super.init(self)

    self.text = "* Dess stands in your way."

    self.music = "dessimation_clip"
    self.background = false

    MUSIC_VOLUMES["dessimation_clip"] = 0.75 -- that "track" is temporarily here anyway

    self.dess = self:addEnemy("dess")

    self.phase = 1
    self.afterimages = false
    self.afterimage_timer = 0
end

function Dess:onBattleInit()
    self.bg = DessimationBG({1, 1, 1})
    Game.battle:addChild(self.bg)
end

function Dess:onReturnToWorld(events)
end

function Dess:onActionsEnd()
    if (self.dess.done_state == "VIOLENCE" or self.dess.done_state == "KILLED")
        and not self.death_cine_played then
        self.death_cine_played = true
        local cutscene = Game.battle:startCutscene("dess.dies", nil, self.dess)
        cutscene:after(function ()
            Game.battle:setState("ENEMYDIALOGUE")
        end)
        return true
    end
end

function Dess:update()
    super.update(self)

    local dess = Game.battle.enemies[1]

    if dess then
        if dess.health <= dess.max_health * 0.75 and self.phase < 2 then
            self.phase = 2
            self.bg.max_alpha = 0.25
            self.afterimages = true
            dess.phase2_start_text = true
        elseif dess.health <= dess.max_health * 0.5 and self.phase < 3 then
            self.phase = 3
            self.bg.max_alpha = 0.5
            for i = 1, 4 do
                local circler = DessimationCircler(dess, i) -- that shi doesn't work because I HATE AND CAN'T DO CIRCLE MOVEMENT (someone pls fix)
                Game.battle:addChild(circler)
            end
            self.bg.desses = true
            dess.phase3_start_text = true
        elseif dess.health <= dess.max_health * 0.25 and self.phase < 4 then
            self.phase = 4
            self.bg.max_alpha = 0.75
            self.bg.deltarune = true
            dess.phase4_start_text = true
        end
    end

    if self.afterimages then
        self.afterimage_timer = self.afterimage_timer + 1 * DTMULT
        if self.afterimage_timer >= 10 then
            for _,battler in ipairs(Game.battle.party) do
                local sprite = battler.sprite
                if battler.overlay_sprite and battler.overlay_sprite.visible then
                    sprite = battler.overlay_sprite
                end
                local aimg = AfterImage(sprite, 0.6, 0.01)
                aimg:setPhysics({
                    speed_x = -1
                })
                Game.battle:addChild(aimg)
            end
            if dess then
                local aimg = AfterImage(dess.sprite, 0.6, 0.01)
                aimg:setPhysics({
                    speed_x = 1,
                    speed_y = MathUtils.randomInt(2) == 1 and -MathUtils.random(1) or MathUtils.random(1)
                })
                Game.battle:addChild(aimg)
            end
            self.afterimage_timer = 0
        end
    end
end

return Dess