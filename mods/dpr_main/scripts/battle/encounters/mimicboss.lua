local MimicBoss, super = Class(Encounter)

function MimicBoss:init()
    super.init(self)

    -- Battle music ("battle" is rude buster)
    if Game:isDessMode() then
        self.text = "* Undefeatable."
        if Game:getFlag("mimic_defeated") == false then
            self.music = nil
        else
            self.music = "undefeatable"
        end
    else
        self.music = "threestrikesyoureout"
        self.text = "* It's too easy!"
    end

    -- Enables the purple grid battle background
    self.background = false
	self.hide_world = true

	self.energy = 0

    -- Add the dummy enemy to the encounter
    self.mimic = self:addEnemy("mimic")
    self.death_cine_played = false
	
	self.flee = false

    self.boss_rush = false
    if Game:getFlag("mimic_defeated") == true then
        self.boss_rush = true
    end

    self.font = Assets.getFont("main")
end

function MimicBoss:onBattleInit()
    super.onBattleInit(self)
    if self.boss_rush == true then
        Game.battle.dojo_bg = DojoBG({1, 1, 1})
        Game.battle:addChild(Game.battle.dojo_bg)
    else
        self.bg = StarsBG({1, 1, 1})
	    Game.battle:addChild(self.bg)
    end
end

function MimicBoss:draw()
    local nrg = Game.battle.encounter.energy 
    super.draw(self)
    love.graphics.setFont(self.font)

    Draw.setColor(0, 0.1, 0.5, 1)
    love.graphics.print("ENERGY: "..nrg.."%", 72, 20)
    love.graphics.print("ENERGY: "..nrg.."%", 68, 20)
    love.graphics.print("ENERGY: "..nrg.."%", 70, 22)
    love.graphics.print("ENERGY: "..nrg.."%", 70, 18)

    love.graphics.rectangle("fill", 48,8, 204,14)
    Draw.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 50,10, 200,10)
    Draw.setColor(1, 1, 0.5, 1)
    love.graphics.rectangle("fill", 50,10, nrg * 2,10)

    love.graphics.print("ENERGY: "..nrg.."%", 70, 20)


    --Game.battle.encounter.energy
end

function MimicBoss:onActionsEnd()
    if (self.mimic.done_state == "VIOLENCE" or self.mimic.done_state == "KILLED")
        and not self.death_cine_played then
        self.death_cine_played = true
        local cutscene = Game.battle:startCutscene("mimic.dies", nil, self.mimic)
        cutscene:after(function ()
            Game.battle:setState("ENEMYDIALOGUE")
        end)
        return true
    end
end

return MimicBoss
