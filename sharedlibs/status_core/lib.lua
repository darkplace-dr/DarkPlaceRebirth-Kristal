local Lib = {}

function Lib:init()
    print("Loaded Status CORE " .. self.info.version .. "!")
	
	Utils.hook(Utils, "dump", function(orig, o)
		if type(o) == "table" and isClass(o) and o.__tostring then
			return tostring(o)
		end
		return orig(o)
	end)
    
    Utils.hook(PartyBattler, "init", function(orig, self, ...)
        orig(self, ...)
		
		self.statuses = {}	-- status_id: {statcon: status, turn_count: number of turns}
    end)
    Utils.hook(PartyBattler, "inflictStatus", function(orig, self, status, turns, ...)
		if self.statuses[status] then
			self.statuses[status].turn_count = math.max(
				self.statuses[status].turn_count,
				(
					turns or self.statuses[status].statcon.default_turns
				)
			)
		else
			local effect = Lib:createStatus(status, ...)
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
		for _,battler in ipairs(Game.battle.party) do
			if battler ~= self then
				for id, status in pairs(battler.statuses) do
					status.statcon:onOtherHurt(battler, self, amount)
				end
			end
		end
    end)
    Utils.hook(PartyBattler, "hasStatus", function(orig, self, status)
		return (self.statuses[status] ~= nil)
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
		if Kristal.getLibConfig("status_core", "status_menu") then
			local sv = StatusView()
			sv:setLayer(BATTLE_LAYERS["top"])
			self:addChild(sv)
		end
    end)

	Utils.hook(PartyMember, "getStat", function (orig, pm, name, default, light)
        local value = orig(pm, name, default, light)
        if Game.battle then
            local battler = Game.battle:getPartyBattler(pm.id)
            for id, status in pairs(battler.statuses) do
                ---@cast status {statcon:StatusCondition}
                value = status.statcon:applyStatModifier(name, value)
            end
        end
        return value
    end)

    Utils.hook(ActionBoxDisplay, "draw", function(orig, self)
		local i = 0
		love.graphics.setFont(Assets.getFont("smallnumbers"))
		for k, status in pairs(self.actbox.battler.statuses) do
			if not status.statcon.hidden then
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
				
				if status.statcon.amplifier and status.statcon.amplifier >= 1 then
					Draw.setColor(0, 0, 0, 1)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 3, -28)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 3, -27)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 3, -29)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 4, -27)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 5, -28)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 5, -27)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 5, -29)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 4, -29)
					Draw.setColor(1, 1, 1, 1)
					love.graphics.print(status.statcon.amplifier, (i * 24) + 4, -28)
				end
			
				i = i + 1
			end
		end
        orig(self)
    end)
	if Mod.libs["magical-glass"] and Kristal.getLibConfig("status_core", "magical-glass") then
		print("[Status CORE] Magical Glass detected and changes allowed.")
		if LightPartyBattler then
			Utils.hook(LightPartyBattler, "init", function(orig, self, ...)
				orig(self, ...)
				
				self.statuses = {}	-- status_id: {statcon: status, turn_count: number of turns}
			end)
			Utils.hook(LightPartyBattler, "inflictStatus", function(orig, self, status, turns, ...)
				if self.statuses[status] then
					self.statuses[status].turn_count = math.max(
						self.statuses[status].turn_count,
						(
							turns or self.statuses[status].statcon.default_turns
						)
					)
				else
					local effect = Lib:createStatus(status, ...)
					self.statuses[status] = {statcon = effect, turn_count = (turns or effect.default_turns)}
					self.statuses[status].statcon:onStatus(self)
				end
			end)
			Utils.hook(LightPartyBattler, "cureStatus", function(orig, self, status)
				if self.statuses[status] then
					self.statuses[status].statcon:onCure(self)
					self.statuses[status] = nil
				end
			end)
			Utils.hook(LightPartyBattler, "update", function(orig, self)
				orig(self)
				for id, status in pairs(self.statuses) do
					status.statcon:onUpdate(self)
				end
			end)
			Utils.hook(LightPartyBattler, "hurt", function(orig, self, amount, exact, color, options)
				for id, status in pairs(self.statuses) do
					amount = status.statcon:onHurt(self, amount) or amount
				end
				if amount > 0 then
					orig(self, amount, exact, color, options)
				end
				for _,battler in ipairs(Game.battle.party) do
					if battler ~= self then
						for id, status in pairs(battler.statuses) do
							status.statcon:onOtherHurt(battler, self, amount)
						end
					end
				end
			end)
			Utils.hook(LightPartyBattler, "hasStatus", function(orig, self, status)
				return (self.statuses[status] ~= nil)
			end)
		end
		
		if LightBattle then
			Utils.hook(LightBattle, "nextTurn", function(orig, self)
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
			Utils.hook(LightBattle, "onStateChange", function(orig, self, old, new)
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
			Utils.hook(LightBattle, "init", function(orig, self, ...)
				orig(self, ...)
				if Kristal.getLibConfig("status_core", "status_menu") then
					local sv = StatusView()
					sv:setLayer(BATTLE_LAYERS["top"])
					self:addChild(sv)
				end
			end)
			Utils.hook(LightBattle, "draw", function(orig, self)
				orig(self)
				
				for i, battler in ipairs(self.party) do
					Draw.setColor(1, 1, 1, (1 - self.fader.alpha))
					local head_icon = Assets.getTexture(battler.chara.head_icons + "/head")
					love.graphics.draw(head_icon, 600, (i * 28) - 20)
					
					x = 566
					love.graphics.setFont(Assets.getFont("smallnumbers"))
					for k, status in pairs(battler.statuses) do
						if not status.statcon.hidden then
							Draw.setColor(1, 1, 1, (1 - self.fader.alpha))
							if Kristal.getLibConfig("status_core", "match_color") then
								Draw.setColor(battler.chara.color)
							end
							love.graphics.draw(Assets.getTexture(status.statcon.icon), x + 4, (i * 28) - 16)
							
							local width = Assets.getFont("smallnumbers"):getWidth(status.turn_count)
							Draw.setColor(0, 0, 0, (1 - self.fader.alpha))
							love.graphics.print(status.turn_count, x + 25 - width, (i * 28) - 4)
							love.graphics.print(status.turn_count, x + 25 - width, (i * 28) - 3)
							love.graphics.print(status.turn_count, x + 25 - width, (i * 28) - 5)
							love.graphics.print(status.turn_count, x + 26 - width, (i * 28) - 3)
							love.graphics.print(status.turn_count, x + 27 - width, (i * 28) - 4)
							love.graphics.print(status.turn_count, x + 27 - width, (i * 28) - 3)
							love.graphics.print(status.turn_count, x + 27 - width, (i * 28) - 5)
							love.graphics.print(status.turn_count, x + 26 - width, (i * 28) - 5)
							Draw.setColor(1, 1, 1, (1 - self.fader.alpha))
							love.graphics.print(status.turn_count, x + 26 - width, (i * 28) - 4)
							
							if status.statcon.amplifier and status.statcon.amplifier >= 1 then
								Draw.setColor(0, 0, 0, 1)
								love.graphics.print(status.statcon.amplifier, x + 3, (i * 28) - 20)
								love.graphics.print(status.statcon.amplifier, x + 3, (i * 28) - 19)
								love.graphics.print(status.statcon.amplifier, x + 3, (i * 28) - 21)
								love.graphics.print(status.statcon.amplifier, x + 4, (i * 28) - 19)
								love.graphics.print(status.statcon.amplifier, x + 5, (i * 28) - 20)
								love.graphics.print(status.statcon.amplifier, x + 5, (i * 28) - 19)
								love.graphics.print(status.statcon.amplifier, x + 5, (i * 28) - 21)
								love.graphics.print(status.statcon.amplifier, x + 4, (i * 28) - 21)
								Draw.setColor(1, 1, 1, 1)
								love.graphics.print(status.statcon.amplifier, x + 4, (i * 28) - 20)
							end
							
							x = x - 24
						end
					end
					
				end
			end)
		end
	end
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