Utils.hook(Game, "encounter", function(orig, self, encounter, transition, enemy, context)
    if transition == nil then transition = true end

    if self.battle then
        error("Attempted to enter a battle while already in battle")
    end
    
    if MagicalGlass.__current_battle_system then
        if MagicalGlass.__current_battle_system == "undertale" then
            self:encounterLight(encounter, transition, enemy, context)
            return
        elseif MagicalGlass.__current_battle_system == "deltarune" then
            self:encounterDark(encounter, transition, enemy, context)
            return
        end
    end

    if Game:isLight() then
        self:encounterLight(encounter, transition, enemy, context)
        return
    else
        self:encounterDark(encounter, transition, enemy, context)
        return
    end

    if MagicalGlass.default_battle_system == "undertale" then
        self:encounterLight(encounter, transition, enemy, context)
    elseif MagicalGlass.default_battle_system == "deltarune" then
        self:encounterDark(encounter, transition, enemy, context)
    else
        self:encounterDark(encounter, transition, enemy, context)
    end
end)

Utils.hook(Game, "encounterDark", function(orig, self, encounter, transition, enemy, context)
    if transition == nil then transition = true end

    if self.battle then
        error("Attempted to enter a battle while already in battle")
    end

    MagicalGlass.__current_battle_system = "deltarune"

    if enemy and not isClass(enemy) then
        self.encounter_enemies = enemy
    else
        self.encounter_enemies = {enemy}
    end

    self.state = "BATTLE"

    self.battle = Battle()

    if context then
        self.battle.encounter_context = context
    end

    if type(transition) == "string" then
        self.battle:postInit(transition, encounter)
    else
        self.battle:postInit(transition and "TRANSITION" or "INTRO", encounter)
    end

    self.stage:addChild(self.battle)
end)

Utils.hook(Game, "encounterLight", function(orig, self, encounter, transition, enemy, context)
    if transition == nil then transition = true end

    if self.battle then
        error("Attempted to enter a battle while already in battle")
    end

    MagicalGlass.__current_battle_system = "undertale"

    if enemy and not isClass(enemy) then
        self.encounter_enemies = enemy
    else
        self.encounter_enemies = {enemy}
    end

    self.state = "BATTLE"

    self.battle = LightBattle()

    if context then
        self.battle.encounter_context = context
    end

    if type(transition) == "string" then
        self.battle:postInit(transition, encounter)
    else
        self.battle:postInit(transition and "TRANSITION" or "INTRO", encounter)
    end

    self.stage:addChild(self.battle)
end)

--[[ Utils.hook(Game, "enterShop", function(orig, self, shop, options)
    if lib.in_light_shop then
        MagicalGlass:enterLightShop(shop, options)
    else
        orig(self, shop, options)
    end
end) ]]

Utils.hook(Game, "gameOver", function(orig, self, x, y)
    Kristal.hideBorder(0)

    self.state = "GAMEOVER"
    if self.battle   then self.battle  :remove() end
    if self.world    then self.world   :remove() end
    if self.shop     then self.shop    :remove() end
    if self.gameover then self.gameover:remove() end
    if self.legend   then self.legend  :remove() end

    self.gameover = GameOver(x or 0, y or 0)
    self.stage:addChild(self.gameover)

    MagicalGlass:setGameOvers(MagicalGlass.__game_overs + 1)
end)