local Jackenstein, super = Class(EnemyBattler)

function Jackenstein:init()
    super.init(self)

    -- Enemy name
    self.name = "Jackenstein"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("jackenstein")

    -- Enemy health
    self.max_health = 1350
    self.health = 1350
    -- Enemy attack (determines bullet damage)
    self.attack = 14
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 100

    self.experience = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "jackenstein/test",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "GO... BACK...",
        "DARK ZONE!\nBABY YEAH!"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* You are in the DARK ZONE.",
		"* Everything seems OK.",
		"* Too dark to see near the walls.",
		"* Too dark to see near the walls.\n* There's a pit here!",
		"* Too dark to see near the walls.\n* There's a texture of a dog playing maracas in here!",
		"* Too dark to see near the walls.\n* There's something miniboss-shaped\nin here!"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Jackenstein has low HP."

	self:getAct("Check").description = "Consider\nstrategy"
    self:registerAct("Unleash", "Reveal\nweakness", nil, 60)
	self:registerAct("ScaredyCat", "Def.Down\nSpeed Up", nil, 2)
    self.killable = true
	
	self.check_amt = 0
	self.scaredycat_amt = 0
	self:setAnimation("idle")
	
	self.powder_immunity = true
	self.boss = true
end

function Jackenstein:update()
    if self.actor then
        self.actor:onBattleUpdate(self)
    end
	super.update(self)
end

function Jackenstein:isXActionShort(battler)
    return true
end

function Jackenstein:getXAction(battler)
    if battler.chara.id == "susie" then
		return "TreasureHunt"
	elseif battler.chara.id == "ralsei" then
		return "LightUp"
	elseif battler.chara.id == "dess" then
		return "LightUp"
	end
    return "Standard"
end

function Jackenstein:onShortAct(battler, name)
    if name == "TreasureHunt" then
        return "* Susie sniffs out treasure!"
    elseif name == "LightUp" then
        return "* Ralsei lit up! Light grew!"
    end
    return nil
end

function Jackenstein:onActStart(battler, name)
    super.onActStart(self, battler, name)
end

function Jackenstein:onAct(battler, name)
    if name == "Unleash" then
        battler:setAnimation("act")

        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* " .. battler.chara:getName() .. "'s SOUL emitted a brilliant light!")
            battler:flash()

            cutscene:playSound("great_shine", 1, 1.2)

            local bx, by = Game.battle:getSoulLocation()

            local soul = Game.battle:addChild(PurifySoul(bx + 20, by + 10))
            soul.color = Game:getPartyMember(Game.party[1].id).soul_color or { 1, 0, 0 }
            soul.layer = 501
            --  soul.graphics.fade = 0.20
            --soul.graphics.fade_to = 0

            local flash_parts = {}
            local flash_part_total = 20
            local flash_part_grow_factor = 1
            for i = 1, flash_part_total - 1 do
                -- width is 1px for better scaling
                local part = Rectangle(bx + 20, 0, 1, SCREEN_HEIGHT)
                part:setOrigin(0.5, 0)
                part.layer = soul.layer - i
                part:setColor(1, 1, 1, -(i / flash_part_total))
                part.graphics.fade = flash_part_grow_factor / 16
                part.graphics.fade_to = math.huge
                part.scale_x = i * i * 2
                part.graphics.grow_x = flash_part_grow_factor * i * 2
                table.insert(flash_parts, part)
                Game.battle:addChild(part)
            end

            local rect = nil

            local function fade(step, color)
                rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                rect:setParallax(0, 0)
                rect:setColor(color)
                rect.layer = soul.layer + 1
                rect.alpha = 0
                rect.graphics.fade = step
                rect.graphics.fade_to = 1
                Game.battle:addChild(rect)
                cutscene:wait(1 / step / 45)
            end

            cutscene:wait(12 / 30)

            fade(0.04, { 1, 1, 1 })
            cutscene:wait(10 / 30)
            for _, part in ipairs(flash_parts) do
                part:remove()
            end

            rect.graphics.fade = 0.04
            rect.graphics.fade_to = 0


            local wait = function() return soul.t > 540 end
            cutscene:wait(wait)
        end)
		self.wave_override = "jackenstein/lightup"
        return
    elseif name == "ScaredyCat" then
        self.scaredycat_amt = self.scaredycat_amt + 1
		Game.battle.encounter.scaredy_cat = true
		Assets.playSound("drive")
        if self.check_amt == 1 then
			return "* Your heart pumped nervously!\n* SPEED increased for 1 turn!\n* Everyone's DEFENSE down!"
		else
			return "* Scared! SPEED up, DEF down!"
		end
    elseif name == "TreasureHunt" then
		Game.battle.encounter.treasure_hunt = true
        return "* Susie sniffs out treasure! It's easier to pick stuff up!"
    elseif name == "LightUp" then
		Game.battle.encounter.light_up = true
        return "* Ralsei lit up! The light grew larger and stronger!"
    elseif name == "Check" then
		self.check_amt = self.check_amt + 1
        if self.check_amt == 1 then
            return {"* JACKENSTEIN - An unsightly beast that lives in total darkness.", "* Gather [color:yellow]TREASURE[color:reset] to gain TP, and use \"UNLEASH\" to light him up!"}
        else
			local charamt = 3
			local charname1 = "Susie"
			local charname2 = "Ralsei"
			if charamt == 1 then
				return "* You CHECKed Jackenstein...\n* You remember that [color:yellow]DEFEND[color:reset]ing gives you TP!"
			elseif charamt == 2 then
				return { "* You CHECKed Jackenstein...\n* You remember that [color:yellow]DEFEND[color:reset]ing gives you TP!", "* You remember "..charname1.." might have their own ACTs as well...!" }
			elseif charamt == 3 then
				return { "* You CHECKed Jackenstein...\n* You remember that [color:yellow]DEFEND[color:reset]ing gives you TP!", "* You remember "..charname1.." and "..charname2.." might have their own ACTs as well...!" }
			end
		end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Jackenstein:getEncounterText()
    if (Game.tension >= 60) then
        return "* The atmosphere feels tense...\n(You can use [color:yellow]UNLEASH[color:reset]!)"
    end
	local text = self.text
	if Game:hasPartyMember("susie") then
		table.insert(text, "SUSIE_TEXT")
	end
	if Game:hasPartyMember("ralsei") then
		table.insert(text, "RALSEI_TEXT")
	end
	if Game:hasPartyMember("dess") then
		table.insert(text, "DESS_TEXT")
	end
	if Game:hasPartyMember("jamm") then
		table.insert(text, "JAMM_TEXT")
	end
	if Game:hasPartyMember("brenda") then
		table.insert(text, "BRENDA_TEXT")
	end
	text = Utils.pick(text)
	if text == "SUSIE_TEXT" then
		Game.battle.battle_ui.encounter_text:addReaction("react", "That's ME, dumbass!", "right", "bottom", "teeth", "susie")
		return "* Too dark to see near the walls.\n* There's something very Susie-like\nin here![react:react]"
	end
	if text == "RALSEI_TEXT" then
		local leadername = GeneralUtils:getLeader().name
		local leadernameshort = StringUtils.sub(leadername, 1, 2)
		Game.battle.battle_ui.encounter_text:addReaction("react", leadernameshort..".. "..leadername.."?", "right", "bottom", "blush_surprise", "ralsei")
		return "* Too dark to see near the walls.\n* There's something fluffy in here![react:react]"
	end
	if text == "DESS_TEXT" then
		Game.battle.battle_ui.encounter_text:addReaction("react", "bro that's u", "right", "bottom", "teehee", "dess")
		return "* Too dark to see near the walls.\n* There's something cringeworthy\nin here![react:react]"
	end
	if text == "JAMM_TEXT" then
		Game.battle.battle_ui.encounter_text:addReaction("react", "D-don't scare me\nlike that!", "right", "bottom", "shocked", "jamm")
		return "* Too dark to see near the walls.\n* There's something static-like\nin here![react:react]"
	end
	if text == "BRENDA_TEXT" then
		Game.battle.battle_ui.encounter_text:addReaction("react", "Hey! Did anybody teach\nyou proper firearm\nsafety?!", 380, "middle", "angry_b", "brenda")
		return "* Too dark to see near the walls.\n* There's something\ngun-shaped in here![react:react]"
	end
    return text
end

return Jackenstein