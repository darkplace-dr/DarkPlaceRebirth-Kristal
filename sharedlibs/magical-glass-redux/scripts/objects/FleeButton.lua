local FleeButton, super = Class(ActionButton)

function FleeButton:init(flee_only)
    super.init(self, "flee")
    
    self.flee_only = flee_only
    self.flee_mode = self.flee_only
    
    self.delay_timer = 0
end

function FleeButton:update()
    super.update(self)
    
    self.delay_timer = MathUtils.approach(self.delay_timer, 0, DTMULT)
    local battle_leader
    for i, battler in ipairs(Game.battle.party) do
        if not battler.is_down and not battler.sleeping and not (Game.battle:getActionBy(battler) and Game.battle:getActionBy(battler).action == "AUTOATTACK") then
            battle_leader = battler.chara.id
            break
        end
    end
    
    if not self.flee_only then
        if Game.battle:getPartyIndex(battle_leader) == Game.battle.current_selecting and Game.battle.encounter:canFlee() and not self.disabled then
            if self.hovered and (Input.pressed("up") or Input.pressed("down")) then
                if self.flee_mode then
                    self.flee_mode = false
                else
                    self.flee_mode = true
                end
                Game.battle.ui_move:stop()
                Game.battle.ui_move:play()
            end
        elseif self.flee_mode then
            self.flee_mode = false
            self.delay_timer = 2
        end
    end
    
    local type = self.type
    if not self.flee_mode then
        type = "spare"
    end
    if self.delay_timer <= 0 then
        self.texture = Assets.getTexture("ui/battle/btn/" .. type)
        self.hovered_texture = Assets.getTexture("ui/battle/btn/" .. type .. "_h")
        self.special_texture = Assets.getTexture("ui/battle/btn/" .. type .. "_a")
        self.disabled_texture = Assets.getTexture("ui/battle/btn/" .. type .. "_d")
    end
end

function FleeButton:select()
    if self.flee_mode then
        if Game.battle.encounter:canFlee() then
            local chance = Game.battle.encounter.flee_chance

            for _, party in ipairs(Game.battle.party) do
                for _, equip in ipairs(party.chara:getEquipment()) do
                    chance = chance + (equip:getFleeBonus() / #Game.battle.party or 0)
                end
            end
            
            chance = math.floor(chance)

            if chance >= MathUtils.round(MathUtils.random(1, 100)) then
                Game.battle:onFlee()
            else
                Game.battle.current_selecting = 0
                Game.battle:setState("ENEMYDIALOGUE", "FLEEFAIL")
                Game.battle.encounter:onFleeFail()
            end
        else
            Game.battle:setEncounterText({text = "* You attempted to escape,\n[wait:5]but it failed."})
        end
    else
        Game.battle:setState("ENEMYSELECT", "SPARE")
    end
end

function FleeButton:hasSpecial()
    if not self.flee_mode then
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.mercy >= 100 then
                return true
            end
        end
    end
    return false
end

return FleeButton