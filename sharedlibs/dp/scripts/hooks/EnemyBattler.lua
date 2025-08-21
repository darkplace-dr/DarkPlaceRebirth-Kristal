---@class EnemyBattler : EnemyBattler
local EnemyBattler, super = Utils.hookScript(EnemyBattler)

function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)
    
    self.tiredness = 0
	
	self.service_mercy = 20

    self.killable = false
	
	-- These next three variables are for the "Disarm" spell Jamm learns in Dark Future.
	self.has_weapon = false
	self.disarm_chance = -0.1
	-- Ideally, armed enemies would have separate attacks and sprites for when they're disarmed.
	-- Disarming doesn't deal damage. It only puts the enemy at some disadvantage.
	self.disarmed = false

    self.powder = false
    self.powder_damage = false
end

function EnemyBattler:registerAssistAct(party_member, mini, name, description, party, tp, highlight, icons)
    if Game:getPartyMember(party_member) == nil then error("Party member with ID " .. party_member .. " does not exist.") end
    if not Game:getPartyMember(party_member):getAssistID(--[[For some reason, there was a `mini` parameter here???]]) then return end
    self:registerActFor(party_member, name, description, party, tp, highlight, icons)

    local color = {Game:getPartyMember(party_member):getAssistColor()}

    self.acts[#self.acts].color = color
end


function EnemyBattler:registerShortAssistAct(party, mini, name, description, party, tp, highlight, icons)
    if Game:getPartyMember(party_member) == nil then error("Party member with ID " .. party_member .. " does not exist.") end
    if not Game:getPartyMember(party_member):getAssistID(--[[For some reason, there was a `mini` parameter here???]]) then return end
    self:registerShortActFor(party_member, name, description, party, tp, highlight, icons)

    local color = {Game:getPartyMember(party_member):getAssistColor()}

    self.acts[#self.acts].color = color
end

---@deprecated
function EnemyBattler:registerMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Kristal.Console:warn("Deprecated EnemyBattler:registerMarcyAct used!")
    Kristal.Console:warn(info.source .. ":"..info.currentline)
    self:registerAssistAct("jamm", "marcy", name, description, party, tp, highlight, icons)
end

---@deprecated
function EnemyBattler:registerShortMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Kristal.Console:warn("Deprecated EnemyBattler:registerMarcyAct used!")
    Kristal.Console:warn(info.source .. ":"..info.currentline)
    self:registerShortAssistAct("jamm", "marcy", name, description, party, tp, highlight, icons)
end

function EnemyBattler:onMercy(battler, spare_all)
    if self:canSpare() then
        self:spare()
        return true
    else
        if spare_all then
            local alive = 0
            for _,party in ipairs(Game.battle.party) do
                if not party.is_down then
                    alive = alive + 1
                end
            end
            local mercy_points = Utils.round(self.spare_points * alive/#Game.battle:getActiveEnemies())
            self:addMercy(math.min(mercy_points,100))
            -- if mercy_points > 100 and self:canSpare() then
                -- self:spare()
            -- end
            -- return true
        else
            self:addMercy(self.spare_points)
        end
        return false
    end
end

--- *(Override)* Called when a service spell is used
function EnemyBattler:onService(spell) end
--- *(Override)* Called when a service spell is used
function EnemyBattler:canService(spell) return true end

function EnemyBattler:onDefeat(damage, battler)
    if self.killable and Game:getFlag("can_kill") then
        self:onDefeatFatal(damage, battler)
        return
    end
    return super.onDefeat(self, damage, battler)
end


function EnemyBattler:addTired(amount)
    if self.tiredness >= 100 then
        -- We're already at full tiredness; do nothing.
        return
    end

    self.tiredness = self.tiredness + amount
    if self.tiredness < 0 then
        self.tiredness = 0
    end

    if self.tiredness >= 100 then
        self.tiredness = 100
		self:setTired(true)
	else
		self:setTired(false)
    end

    if Game:getConfig("mercyMessages") then
        if amount > 0 then
            local pitch = 0.8
            if amount < 99 then pitch = 1 end
            if amount <= 50 then pitch = 1.2 end
            if amount <= 25 then pitch = 1.4 end

            local src = Assets.playSound("mercyadd", 0.8)
            src:setPitch(pitch)
        end
		self:statusMessage("tired", amount)
    end
end

function EnemyBattler:canSleep()
    return self.tiredness >= 100
end

function EnemyBattler:attemptDisarm()
    if self.has_weapon then
		if not self.disarmed then
			if Utils.random() <= self.disarm_chance then
				return true, "* The enemy was disarmed!"
			end
			return false, "* The enemy resisted...[wait:10] Try again?"
		end
		return false, "* But the enemy was already disarmed."
	end
	return false, "* But the enemy couldn't be disarmed."
end

function EnemyBattler:onDisarm() end

return EnemyBattler
