local MimicBoss, super = Class(Encounter)

function MimicBoss:init()
    super.init(self)

    if Game:isDessMode() then
        self.text = "* Undefeatable."
        if not Game:getFlag("mimic_defeated") then
            self.music = nil
        else
            self.music = "undefeatable"
        end
    else
        self.music = "threestrikesyoureout"
        self.text = "* It's too easy!"
    end

    self.background = true

    self.mimic = self:addEnemy("mimic")
    self.death_cine_played = false

    self.flee = false

    self.energy = 0

    self.boss_rush = false
    if Game:getFlag("mimic_defeated") then
        self.boss_rush = true
    end

    self.font = Assets.getFont("main")
end

function MimicBoss:onBattleStart(battler)
	local party_has_acter = false
    for _, pm in ipairs(Game.party) do
        if pm:hasAct() then
            party_has_acter = true
            break
        end
    end
    if not party_has_acter then
        for _, pm in ipairs(Game.party) do
            if pm:hasSpells() then
                Game.battle:registerXAction(pm.id, "Mutate", "TP to\nEnergy", 10)
                Game.battle:registerXAction(pm.id, "Send", "Send All\nEnergy")
                break
            end
        end
    end
end

function MimicBoss:createBackground()
    if self.background then
        if self.boss_rush then
            return Game.battle:addChild(DojoBG({ 1, 1, 1 }))
        else
            return Game.battle:addChild(StarsBG({ 1, 1, 1 }))
        end
    end
end

function MimicBoss:draw()
    super.draw(self)

    love.graphics.setFont(self.font)

    Draw.setColor(0, 0.1, 0.5, 1)
    love.graphics.print("ENERGY: " .. self.energy .. "%", 72, 20)
    love.graphics.print("ENERGY: " .. self.energy .. "%", 68, 20)
    love.graphics.print("ENERGY: " .. self.energy .. "%", 70, 22)
    love.graphics.print("ENERGY: " .. self.energy .. "%", 70, 18)

    love.graphics.rectangle("fill", 48, 8, 204, 14)
    Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 50, 10, 200, 10)
    Draw.setColor(1, 1, 0.5, 1)
    love.graphics.rectangle("fill", 50, 10, self.energy * 2, 10)

    love.graphics.print("ENERGY: " .. self.energy .. "%", 70, 20)
end

function MimicBoss:onActionsEnd()
    if (self.mimic.done_state == "VIOLENCE" or self.mimic.done_state == "KILLED") and not self.death_cine_played then
        self.death_cine_played = true
        local cutscene = Game.battle:startCutscene("mimic.dies", nil, self.mimic)
        cutscene:after(function()
            Game.battle:setState("ENEMYDIALOGUE")
        end)
        return true
    end
end

return MimicBoss
