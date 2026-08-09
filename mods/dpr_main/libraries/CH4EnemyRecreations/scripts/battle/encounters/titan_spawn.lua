local TitanSpawn, super = Class(Encounter)

function TitanSpawn:init()
    super.init(self)

    self.text = "* Darkness constricts you...\n* [color:yellow]TP[color:reset] Gain reduced outside of [color:green]???[color:reset]"

    self.music = "titan_spawn"
    self.background = true

    self.titan_spawn_1 = self:addEnemy("titan_spawn", 500, 130)
    self.titan_spawn_2 = self:addEnemy("titan_spawn", 500, 290)
	
    self.reduced_tension = true
	self.light_radius = 48
	self.unleash_threshold = 64
end

function TitanSpawn:onTurnEnd()
    super.onTurnEnd(self)
	self.light_radius = 48
end

function TitanSpawn:getPartyPosition(index)
    local krloc = {94, 50}
    local suloc = {80, 122}
    local raloc = {72, 200}

    if #Game.party == 1 then
        krloc = {80, 122}
    elseif #Game.party == 2 then
        krloc = {94, 86}
        suloc = {80, 166}
    end

    if index == 1 then
        return krloc[1]+(19 + 4), krloc[2]+(38 + 38)
    elseif index == 2 then
        return suloc[1]+(25 + 6), suloc[2]+(43 + 45)
    elseif index == 3 then
        return raloc[1]+(21 + 4), raloc[2]+(40 + 52)
    else
        return super.getPartyPosition(self, index)
    end
end

function TitanSpawn:onBattleStart(battler)
	if Game:hasPartyMember("kris") then
		self.default_xactions = false
		for _,battler in ipairs(Game.battle.party) do
			if battler.chara.id == "susie" then
				Game.battle:registerXAction("susie", "WakeKris", "Revive\nKris", 16)
			elseif battler.chara.id == "ralsei" then
				Game.battle:registerXAction("ralsei", "ReviveKris", "Revive\nKris", 16)
			end
		end
	end
end

return TitanSpawn