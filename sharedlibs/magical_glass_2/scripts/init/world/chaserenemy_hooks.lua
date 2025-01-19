Utils.hook(ChaserEnemy, "init", function(orig, self, actor, x, y, properties)
    orig(self, actor, x, y, properties)

    self.light_encounter = properties["lightencounter"]
    self.light_enemy = properties["lightenemy"]
end)

Utils.hook(ChaserEnemy, "onCollide", function(orig, self, player)
    if self:isActive() and player:includes(Player) then
        self.encountered = true
        local encounter
        local enemy
        
        if self.encounter and self.light_encounter then
            if Game:isLight() then
                encounter = self.light_encounter
                enemy = self.light_enemy
            else
                encounter = self.encounter
                enemy = self.enemy
            end
        elseif self.encounter then
            encounter = self.encounter
            enemy = self.enemy
        elseif self.light_encounter then
            encounter = self.light_encounter
            enemy = self.light_enemy
        end

        if not encounter then
            if Game:isLight() and MagicalGlass:getLightEnemy(self.enemy or self.actor.id) then
                encounter = LightEncounter()
                encounter:addEnemy(self.actor.id)
            elseif not Game:isLight() and Registry.getEnemy(self.light_enemy or self.actor.id) then
                encounter = Encounter()
                encounter:addEnemy(self.actor.id)
            end
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
                if enemy then
                    enemy_target = {{enemy, self}}
                end
                Game:encounter(encounter, true, enemy_target, self)
            end)
        end
    end
end)