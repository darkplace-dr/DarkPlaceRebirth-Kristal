local Tenna, super = Class(Encounter)

function Tenna:init()
    super.init(self)

    self.text = "* It's TV TIME!\n* (Gather as many [color:yellow]POINTs[color:reset] as you can before time runs out!)"

    self.music = "deltarune/tenna_battle"
    self.background = true

    self.tenna = self:addEnemy("tenna", 526, 300)
end

function Tenna:createBackground()
    if self.background then
        return Game.battle:addChild(TennaBattleBackground())
    end
end

function Tenna:createBattleDarkener()
    return Game.battle:addChild(TennaBattleDarkener())
end

function Tenna:getDialogueCutscene()
	self.tenna:setPhase()
	super.getDialogueCutscene(self)
end

function Tenna:onTurnStart()
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
	if not tenna_bg.battle_started then
		tenna_bg.battle_started = true
	end
end

function Tenna:onBattleEnd()
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
	Game.battle.timer:tween(10/30, tenna_bg, {audience_y_pos = SCREEN_HEIGHT+80}, "linear")
end

function Tenna:addScore(score, clamp, reason, delay)
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
	tenna_bg:addScore(score, clamp, reason, delay)
end

function Tenna:update()
	super.update(self)
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
	if tenna_bg.battle_timer <= 0 then
		if not tenna_bg.gameover then
			Assets.playSound("lancerwhistle")
			Game.battle.timer:after(1/30, function()
				Assets.playSound("coin")
			end)
			Game.battle.timer:after(8/30, function()
				Assets.playSound("coin")
			end)
			Game.battle.timer:after(15/30, function()
				Assets.playSound("coin")
			end)
			tenna_bg.gameover = true
			tenna_bg.score = tenna_bg.score + tenna_bg.addscore
			tenna_bg.addscore = 0
			Game:setFlag("tenna_battle_score", tenna_bg.score)
			Game.battle.music:stop()
			Game.battle:setState("TIMEUP")
		end
		tenna_bg.battle_timer = 0
	end
end

function Tenna:onStateChange(old,new)
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
    super.onStateChange(self, old, new)
	if TableUtils.contains({"ACTIONSDONE", "ENEMYDIALOGUE", "DEFENDING", "SPARING", "USINGITEMS", "ATTACKING", "BATTLETEXT", "SHORTACTTEXT"}, new) then
		tenna_bg.stop_counting_points = true
		tenna_bg.timeloss_max = 20
		if new == "ENEMYDIALOGUE" then
			tenna_bg.move_timer_offset = true
			Game.battle.timer:tween(20/30, tenna_bg, {audience_y_pos = 400}, "linear")
		end
	elseif new == "ACTIONSELECT" then
		tenna_bg.stop_counting_points = false
		tenna_bg.move_timer_offset = false
		Game.battle.timer:tween(20/30, tenna_bg, {audience_y_pos = 360}, "linear")
	elseif new == "TIMEUP" then 
		for _,dialogue in ipairs(Game.battle.enemy_dialogue) do
			if dialogue then
				dialogue:remove()
			end
		end
        Game.battle.enemy_dialogue = {}
		for _,box in ipairs(Game.battle.battle_ui.attack_boxes) do
            box:remove()
        end
        Game.battle.battle_ui.attack_boxes = {}
        Game.battle.battle_ui.attacking = false
        Game.battle:returnSoul()
        if Game.battle.arena then
            Game.battle.arena:remove()
            Game.battle.arena = nil
        end
        for _,battler in ipairs(Game.battle.party) do
            battler.targeted = false
        end
		for _,wave in ipairs(Game.battle.waves) do
            if not wave:onEnd(false) then
                wave:clear()
                wave:remove()
            end
        end
        local function exitWaves()
            for _,wave in ipairs(Game.battle.waves) do
                wave:onArenaExit()
            end
            Game.battle.waves = {}
        end
        Game.battle.timer:after(15/30, function()
            exitWaves()
        end)
        Game.battle.current_selecting = 0
        Game:getPartyMember("susie").rage = false
        Game:getPartyMember("susie").rage_counter = 0

        if Game.battle.tension_bar then
            Game.battle.tension_bar:hide()
        end

        for _,battler in ipairs(Game.battle.party) do
            battler:setSleeping(false)
            battler.defending = false
            battler.action = nil

            battler.chara:resetBuffs()
            
            if battler.chara:getHealth() <= 0 then
                battler:revive()
                battler.chara:setHealth(battler.chara:autoHealAmount())
            end

            battler:setAnimation("battle/victory")

            local box = Game.battle.battle_ui.action_boxes[Game.battle:getPartyIndex(battler.chara.id)]
            box:resetHeadIcon()
        end

        local win_text = "* Time's up!\n* You earned "..tenna_bg.score.." POINTs."
		Game.battle.battle_ui:clearEncounterText()
        Game.battle:battleText(win_text, function()
            Game.battle:setState("TRANSITIONOUT")
            self:onBattleEnd()
            return true
        end)
	end
end

return Tenna