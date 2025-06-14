---@class EnemyBattler : EnemyBattler
local EnemyBattler, super = Utils.hookScript(EnemyBattler)

function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)
    
    self.tiredness = 0
	
	self.service_mercy = 20

    self.killable = false
end

function EnemyBattler:registerMinipartyAct(party, mini, name, description, party, tp, highlight, icons)
    party = type(party) == "string" and Game:getPartyMember(party) or party
    if not party:getMinimemberID(mini) then return end
    self:registerActFor(party.id, name, description, party, tp, highlight, icons)

    local color = {party:getColor()}

    -- TODO: Unhardcode
    if party.id == "jamm" and mini == "marcy" then
        color = {0,1,1}
    end

    self.acts[#self.acts].color = color
end


function EnemyBattler:registerShortMinipartyAct(party, mini, name, description, party, tp, highlight, icons)
    party = type(party) == "string" and Game:getPartyMember(party) or party
    if not party:getMinimemberID(mini) then return end
    self:registerShortActFor(party.id, name, description, party, tp, highlight, icons)

    -- TODO: Unhardcode, make a PartyMember getter
    local color = {1, 1, 1}
    if party.id == "jamm" and mini == "marcy" then
        color = {0,1,1}
    end

    self.acts[#self.acts].color = color
end

---@deprecated
function EnemyBattler:registerMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Kristal.Console:warn("Deprecated EnemyBattler:registerMarcyAct used!")
    Kristal.Console:warn(info.source .. ":"..info.currentline)
    self:registerMinipartyAct("jamm", "marcy", name, description, party, tp, highlight, icons)
end

---@deprecated
function EnemyBattler:registerShortMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Kristal.Console:warn("Deprecated EnemyBattler:registerMarcyAct used!")
    Kristal.Console:warn(info.source .. ":"..info.currentline)
    self:registerShortMinipartyAct("jamm", "marcy", name, description, party, tp, highlight, icons)
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

return EnemyBattler