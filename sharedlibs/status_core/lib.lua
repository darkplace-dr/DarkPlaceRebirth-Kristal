local Lib = {}

function Lib:init()
    print("Loaded Status CORE " .. self.info.version .. "!")
    
    Utils.hook(PartyBattler, "init", function(orig, self, ...)
        orig(self, ...)
		
		self.statuses = {}	-- status_id: {statcon: status, turn_count: number of turns}
    end)
    Utils.hook(PartyBattler, "inflictStatus", function(orig, self, status, turns)
		if self.statuses[status] then
			self.statuses[status].turn_count = math.max(
				self.statuses[status].turn_count,
				(
					turns or self.statuses[status].statcon.default_turns
				)
			)
		else
			local effect = Lib:createStatus(status)
			self.statuses[status] = {statcon = effect, turn_count = (turns or effect.default_turns)}
			self.statuses[status].statcon:onStatus(self)
		end
    end)
    Utils.hook(PartyBattler, "cureStatus", function(orig, self, status)
		if self.statuses[status] then
			self.statuses[status].statcon:onCure(self)
			self.statuses[status] = nil
		end
    end)
    Utils.hook(PartyBattler, "update", function(orig, self)
		orig(self)
		for id, status in pairs(self.statuses) do
			status.statcon:onUpdate(self)
		end
    end)
    Utils.hook(PartyBattler, "hurt", function(orig, self, amount, exact, color, options)
		for id, status in pairs(self.statuses) do
			amount = status.statcon:onHurt(self, amount) or amount
		end
		if amount > 0 then
			orig(self, amount, exact, color, options)
		end
    end)
    
    Utils.hook(Battle, "nextTurn", function(orig, self)
        orig(self)
		
		for _, battler in ipairs(Game.battle.party) do
			for id, status in pairs(battler.statuses) do
				status.turn_count = status.turn_count - 1
				
				if status.turn_count == 0 then
					battler.statuses[id].statcon:onCure(battler)
					battler.statuses[id] = nil
				else
					battler.statuses[id].statcon:onTurnStart(battler)
				end
			end
		end
    end)
    Utils.hook(Battle, "onStateChange", function(orig, self, old, new)
        orig(self, old, new)
		
		if new == "ACTIONSDONE" then
			for _, battler in ipairs(Game.battle.party) do
				for id, status in pairs(battler.statuses) do
					status.statcon:onActionsEnd(battler)
				end
			end
		elseif new == "DEFENDINGBEGIN" then
			for _, battler in ipairs(Game.battle.party) do
				for id, status in pairs(battler.statuses) do
					status.statcon:onDefenseStart(battler)
				end
			end
		end
    end)
    Utils.hook(Battle, "init", function(orig, self, ...)
        orig(self, ...)
		local sv = StatusView()
		sv:setLayer(BATTLE_LAYERS["top"])
		self:addChild(sv)
    end)
    
    Utils.hook(ActionBoxDisplay, "draw", function(orig, self)
		local i = 0
		love.graphics.setFont(Assets.getFont("smallnumbers"))
		for k, status in pairs(self.actbox.battler.statuses) do
			Draw.setColor(1, 1, 1, 1)
			if Kristal.getLibConfig("status_core", "match_color") then
				Draw.setColor(self.actbox.battler.chara.color)
			end
			love.graphics.draw(Assets.getTexture(status.statcon.icon), (i * 24) + 4, -24)
			
			local width = Assets.getFont("smallnumbers"):getWidth(status.turn_count)
			Draw.setColor(0, 0, 0, 1)
			love.graphics.print(status.turn_count, (i * 24) + 25 - width, -12)
			love.graphics.print(status.turn_count, (i * 24) + 25 - width, -11)
			love.graphics.print(status.turn_count, (i * 24) + 25 - width, -13)
			love.graphics.print(status.turn_count, (i * 24) + 26 - width, -11)
			love.graphics.print(status.turn_count, (i * 24) + 27 - width, -12)
			love.graphics.print(status.turn_count, (i * 24) + 27 - width, -11)
			love.graphics.print(status.turn_count, (i * 24) + 27 - width, -13)
			love.graphics.print(status.turn_count, (i * 24) + 26 - width, -13)
			Draw.setColor(1, 1, 1, 1)
			love.graphics.print(status.turn_count, (i * 24) + 26 - width, -12)
			
			i = i + 1
		end
        orig(self)
    end)
end

function Lib:onRegistered()
    Mod.statuses = {}

    for _,path,stat in Registry.iterScripts("battle/statuses") do
        assert(stat ~= nil, '"statuses/'..path..'.lua" does not return value')
        stat.id = stat.id or path
        Mod.statuses[stat.id] = stat
    end
end

function Lib:registerStatus(id, class)
    Mod.statuses[id] = class
end

function Lib:getStatus(id)
    return Mod.statuses[id]
end

function Lib:createStatus(id, ...)
    if Mod.statuses[id] then
        return Mod.statuses[id](...)
    else
        error("Attempt to create non existent status condition \"" .. tostring(id) .. "\"")
    end
end

return Lib