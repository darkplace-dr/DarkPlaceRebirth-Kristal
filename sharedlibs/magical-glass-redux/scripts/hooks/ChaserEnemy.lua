local ChaserEnemy, super = HookSystem.hookScript(ChaserEnemy)

function ChaserEnemy:init(actor, x, y, properties)
    super.init(self, actor, x, y, properties)

    self.sprite.aura = nil
    self.light_encounter = properties["lightencounter"]
    self.light_enemy = properties["lightenemy"]

    if properties["aura"] == nil then
        if Game:isLight() then
            self.sprite.aura = Kristal.getLibConfig("magical-glass", "light_enemy_auras")
        else
            self.sprite.aura = Game:getConfig("enemyAuras")
        end
    else
        self.sprite.aura = properties["aura"]
    end
end

function ChaserEnemy:getDebugInfo()
    local info = super.getDebugInfo(self)
    local type = nil
    if self.light_encounter or self.light_enemy then
        type = "Light"
    elseif self.encounter or self.enemy then
        type = "Dark"
    end
    if type then table.insert(info, "Battle Type: " .. type) end
    return info
end

function ChaserEnemy:onCollide(player)
    if (self.encounter or self.enemy) and (self.light_encounter or self.light_enemy) then
        error("ChaserEnemy cannot have a mix of light and dark for encounters or enemies")
    elseif not self.light_encounter then
        super.onCollide(self, player)
    else
        if self:isActive() and player:includes(Player) then
            self.encountered = true
            local encounter = self.light_encounter
            if not encounter and Mod.libs["magical-glass"]:getLightEnemy(self.enemy or self.actor.id) then
                encounter = LightEncounter()
                encounter:addEnemy(self.actor.id)
            end
            if encounter then
                self.world.encountering_enemy = true
                self.sprite:setAnimation("hurt")
                self.sprite.aura = false
                Game.lock_movement = true
                self.world.timer:script(function(wait)
                    Assets.playSound("tensionhorn")
                    wait(8/30)
                    local src = Assets.playSound("tensionhorn")
                    src:setPitch(1.1)
                    wait(12/30)
                    self.world.encountering_enemy = false
                    Game.lock_movement = false
                    local enemy_target = self
                    if self.enemy then
                        enemy_target = {{self.enemy, self}}
                    end
                    Game:encounter(encounter, true, enemy_target, self)
                end)
            end
        end
    end
end

return ChaserEnemy