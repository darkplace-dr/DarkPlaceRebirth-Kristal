---@class EnemyBattler : EnemyBattler
local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)

    self.graze_tension_reduced = 0.2 -- like defend tension goes down from 16 to 2, graze tension's default goes down from 1.6 to 0.2

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

    self.can_darken = true

    -- An enemies elemental resistances.
    self.resistances = {
        ELEC = 1,
        FIRE = 1,
        STAR = 1,
        DARK = 1,
        RUDE = 1,
        RED = 1,
        ICE = 1,
        HOLY = 1
    }
end

function EnemyBattler:getGrazeTension()
    if Game.battle:hasReducedTension() then
        return self.graze_tension_reduced
    end
    return self.graze_tension
end

function EnemyBattler:hurt(amount, battler, on_defeat, color, show_status, attacked)
    if amount == 0 or (amount < 0 and Game:getConfig("damageUnderflowFix")) then
        if show_status ~= false then
            if battler and battler.chara.id == "pauling" then
                self:statusMessage("msg", "miss_pauling", color or (battler and { battler.chara:getDamageColor() }))
            else
                self:statusMessage("msg", "miss", color or (battler and { battler.chara:getDamageColor() }))
            end
        end

        self:onDodge(battler, attacked)
        return
    end

    self.health = self.health - amount
    if show_status ~= false then
        self:statusMessage("damage", amount, color or (battler and { battler.chara:getDamageColor() }))
    end

    if amount > 0 then
        self.hurt_timer = 1
        self:onHurt(amount, battler)
    end

    self:checkHealth(on_defeat, amount, battler)
end

function EnemyBattler:registerAssistAct(party_member, mini, name, description, party, tp, highlight, icons)
    if Game:getPartyMember(party_member) == nil then error("Party member with ID " .. party_member .. " does not exist.") end
    if not Game:getPartyMember(party_member):getAssistID( --[[For some reason, there was a `mini` parameter here???]]) then return end
    self:registerActFor(party_member, name, description, party, tp, highlight, icons)

    local color = { Game:getPartyMember(party_member):getAssistColor() }

    self.acts[#self.acts].color = color
end

function EnemyBattler:registerShortAssistAct(party, mini, name, description, party, tp, highlight, icons)
    if Game:getPartyMember(party_member) == nil then error("Party member with ID " .. party_member .. " does not exist.") end
    if not Game:getPartyMember(party_member):getAssistID( --[[For some reason, there was a `mini` parameter here???]]) then return end
    self:registerShortActFor(party_member, name, description, party, tp, highlight, icons)

    local color = { Game:getPartyMember(party_member):getAssistColor() }

    self.acts[#self.acts].color = color
end

---@deprecated
function EnemyBattler:registerMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Logging.warnNotify("Deprecated EnemyBattler:registerMarcyAct used!")
    Logging.warnNotify(info.source .. ":" .. info.currentline)
    self:registerAssistAct("jamm", "marcy", name, description, party, tp, highlight, icons)
end

---@deprecated
function EnemyBattler:registerShortMarcyAct(name, description, party, tp, highlight, icons)
    local info = debug.getinfo(2, "Sln")
    love.timer.sleep(1)
    Logging.warnNotify("Deprecated EnemyBattler:registerMarcyAct used!")
    Logging.warnNotify(info.source .. ":" .. info.currentline)
    self:registerShortAssistAct("jamm", "marcy", name, description, party, tp, highlight, icons)
end

function EnemyBattler:onMercy(battler, spare_all)
    if self:canSpare() then
        self:spare()
        return true
    else
        if spare_all then
            local mercy_points = MathUtils.round(self.spare_points * #Game.battle:getActiveParty() / #Game.battle:getActiveEnemies())
            self:addMercy(math.min(mercy_points, 100))
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

function EnemyBattler:defeat(reason, violent)
    self.done_state = reason or "DEFEATED"

    if violent then
        Game.battle.used_violence = true
        if self:isRecruitable() and self:getRecruitStatus() ~= false then
            if Game:getConfig("enableRecruits") and self.done_state ~= "FROZEN" and self.done_state ~= "DARKENED" then
                self:recruitMessage("lost")
            end
            self:setRecruitStatus(false)
        end
        if self.done_state == "KILLED" or self.done_state == "FROZEN" or self.done_state == "DARKENED" then
            Game.battle.killed = true
            for i, battler in ipairs(Game.battle.party) do
                battler.chara.kills = battler.chara.kills + 1
                if battler.chara.name == "Noel" then
                    local newData = {
                        Kills = battler.chara.kills
                    }
                    Noel:saveNoel(newData)
                end
            end
            if self.done_state == "FROZEN" then
                Game.battle.freeze_xp = Game.battle.freeze_xp + self.experience
            elseif self.done_state == "DARKENED" then
                Game.battle.dark_xp = Game.battle.dark_xp + self.experience
            else
                Game.battle.xp = Game.battle.xp + self.experience
            end
            if Game:hasPartyMember("hero") then
                Game:getPartyMember("hero"):addKarma(-1)
            end
        end
    elseif MagicalGlassLib then -- Compactability with MGR
        Game.battle.xp = Game.battle.xp + self.experience -- MGR reduces EXP gain from not killing, so basically, this just makes sure that the enemy adds 0 EXP
    end

    if self:isRecruitable() and type(self:getRecruitStatus()) == "number" and (self.done_state == "PACIFIED" or self.done_state == "SPARED") then
        self:setRecruitStatus(self:getRecruitStatus() + 1)
        if Game:getConfig("enableRecruits") then
            local counter = self:recruitMessage("recruit")
            counter.first_number = self:getRecruitStatus()
            counter.second_number = Game:getRecruit(self.id):getRecruitAmount()
            Assets.playSound("sparkle_gem")
        end
        if self:getRecruitStatus() >= Game:getRecruit(self.id):getRecruitAmount() then
            self:setRecruitStatus(true)
            Game:addSP(1)
            if Game:hasPartyMember("hero") then
                Game:getPartyMember("hero"):addKarma(1)
            end
        end
    end

    Game.battle.money = Game.battle.money + self.money
    --Game.battle.xp = Game.battle.xp + self.experience

    Game.battle:removeEnemy(self, true)
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

            Assets.playSound("mercyadd", 0.8, pitch)
        end
        self:statusMessage("tired", amount, amount == 100 and ColorUtils.mergeColor(COLORS.blue, COLORS.white, 0.6) or COLORS.white)
    end
end

function EnemyBattler:canSleep()
    return self.tiredness >= 100
end

function EnemyBattler:attemptDisarm()
    if self.has_weapon then
        if not self.disarmed then
            if MathUtils.random() <= self.disarm_chance then
                return true, "* The enemy was disarmed!"
            end
            return false, "* The enemy resisted...[wait:10] Try again?"
        end
        return false, "* But the enemy was already disarmed."
    end
    return false, "* But the enemy couldn't be disarmed."
end

function EnemyBattler:onDisarm() end

function EnemyBattler:getResistance(element)
    for i, resist in pairs(self.resistances) do
        if i == element then
            return resist
        end
    end
    return 1
end

function EnemyBattler:darkify()
    if not self.can_darken then
        self:onDefeat()
        return
    end

    Assets.playSound("petrify")

    self:toggleOverlay(true)

    local sprite = self:getActiveSprite()
    if not sprite:setAnimation("darkened") then
        sprite:setAnimation("hurt")
    end
    sprite:stopShake()

    self:recruitMessage("darkened")

    self.hurt_timer = -1

    sprite.darkened = true
    sprite.darkened_progress = 0

    Game.battle.timer:tween(20 / 30, sprite, { darkened_progress = 1 })

    Game.battle.money = Game.battle.money + 44
    self:defeat("DARKENED", true)
end

return EnemyBattler
