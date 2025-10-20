local scenes = {}
local spamfiguration = {
	x = 345,
	y = 250,
}

---@param cutscene BattleCutscene
---@param text table List of strings to use as dialog lines
--- Hack because the actor doesn't seem to be doing anything
local function spamtext(cutscene, spamton, text)
	for i,line in ipairs(text or {}) do
		-- text[i] = "[voice:spamton]"..line
	end
	cutscene:battlerText(spamton, text, spamfiguration)
end

---@param cutscene BattleCutscene
---@param battler Battler
---@param enemy EnemyBattler
function scenes.talk(cutscene, battler, enemy)
	---@class Encounter
	local enc = Game.battle.encounter
	local spamton = Game.battle.enemies[1]
	if spamton.health > spamton.max_health then
		spamton.health = spamton.max_health
	end
	-- cutscene:battlerText(spamton, {"[voice:spamton]I HAVE [Becomed] OMEGA", "NOW YOU [Canned] HURT ME [Jack]"}, spamfiguration)
	if spamton.health == spamton.max_health and enc.progress == 0 then
		cutscene:battlerText(spamton, {
			"THIS BODY HARDENS IN \n[PreSponse] TO \n[Magical] TRAUMA",
			"IN OTHER \nWORDS...[wait:5]YOU \n[Canned] HURT \nME [Jack]"
		}, spamfiguration)
		enc.progress = 100
	elseif spamton.attack <= 10 and spamton.xaction_flag ~= true then
		spamton.xaction_flag = true
		spamton:registerAct("X-Downgrade", "Lower\nstats+.", "all", 50)
		cutscene:text("* Ugh,[wait:5] this is taking FOREVER!", "teeth", "susie")
		if Game:hasPartyMember("berdly") then
			cutscene:text("* Perhaps we should have level grinded beforehand?", "scared", "berdly")
			cutscene:text("* Nah,[wait:5] I've got a better idea...", "neutral_side", "susie")
			cutscene:text("* Hey,[wait:5] Hero,[wait:5] you should let us help out with downgrading this pile of junk!", "smile", "susie")
		else
			cutscene:text("* Hey,[wait:5] Hero,[wait:5] you should let ME help out with downgrading this pile of junk!", "smile", "susie")
		end
		cutscene:text("* Alright,[wait:5] let's turn this guy into scrap metal!", "smug", "hero")
		cutscene:text("* Yeah,[wait:5] you said it!", "sincere_smile", "susie")
		cutscene:battlerText(spamton, {
			"DO YOU REALLY THINK\nTHE POWER OF [Friendship!]\nWILL SAVE YOU NOW?",
			"YOU KIDS SHOULD KNOW\nBY NOW THAT [color:red]NEO[color:reset]\nNEVER LOSES!"
		}, spamfiguration)
		Assets.playSound("boost")
		cutscene:text("* (You can now use [color:yellow]X-DOWNGRADE[color:reset]!)")
	elseif spamton.health < spamton.max_health and enc.progress == 100 then
		cutscene:battlerText(spamton, {
			"WHAT!? [Yuo're]\n[Killing Me]!?",
			"WELL, NO PROBLEM!\nI CAN JUST USE [Stolen Goods]!\nAVAILIBLE [while true;]\nSUPPLIES LAST!"
		}, spamfiguration)
		spamton:heal(10000)
		enc.progress = 200
	elseif enc.progress >= 200 and enc.progress < 299 then
		enc.progress = enc.progress + 1
		if enc.progress == 205 then
			if Game:hasPartyMember("berdly") then
				cutscene:text("* He just keeps spamming healing items every turn!", "angry", "berdly")
				cutscene:text("* We'll never make more than a dent at this rate!", "angry", "berdly")
				cutscene:text("* What if we don't let him?", "sus_nervous", "susie")
				cutscene:text("* And how do we do that?", "scared", "berdly")
				cutscene:text("* I'm saying we smash him in one go.", "teeth", "susie")
				cutscene:text("* An excelent idea, dear Susan!", "doubtful", "berdly") -- odd portrait name imo
			else
				cutscene:text("* Damnit,[wait:5] we're never gonna win at this rate!", "pout", "hero")
				cutscene:text("* He just keeps using healing items...", "annoyed", "hero")
				cutscene:text("* What if we don't let him?", "sus_nervous", "susie")
				cutscene:text("* And how do we do that?", "neutral_closed", "hero")
				cutscene:text("* I'm saying we smash him in one go.", "teeth", "susie")
				cutscene:text("* Sounds good to me.", "smug", "hero")
			end
			cutscene:battlerText(spamton, {
				"HAEHAEHAEHAE!\nADORABLE, YOU\nTHINK THAT'S A VALID\n[Options Trading]",
				"THIS BODY IS\nINDESTRUCTABLE,\nYOUR PLAN TO\n[Spare] ME TO\n[Heaven] WILL JUST\n[Nintendo NX]TO\n[Sleep Mode]."
			}, spamfiguration)
			cutscene:text("* ...Huh...?", "sus_nervous", "susie")
		end
	elseif spamton.health <= 0 and enc.progress < 300 then
		cutscene:battlerText(spamton, {
			"WHAT THE [#&!!]!?\nYOU'VE [Killeding] ME?\nYOU'VE BREACHED MY [Befences]!?",
			"NOT ON MY [Whatch!?]\nYOU'LL HAVE TO FACE\nTHIS FINAL ATTACK!",
			"...",
			"WHAT, NORMAL?"
		}, spamfiguration)
		spamton:heal(10000)
		enc.progress = 300
	end
	-- cutscene:battlerText(spamton, spamfiguration)
end
return scenes