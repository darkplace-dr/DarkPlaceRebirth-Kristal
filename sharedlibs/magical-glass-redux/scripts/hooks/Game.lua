local Game, super = HookSystem.hookScript(Game)

function Game:getMonsterSoul()
    local monster_soul = Kristal.callEvent(MG_EVENT.getMonsterSoul)
    if monster_soul ~= nil then
        return monster_soul
    end

    if self.state == "BATTLE" and self.battle and self.battle.encounter and self.battle.encounter.getMonsterSoul and self.battle.encounter:getMonsterSoul() then
        return self.battle.encounter:getMonsterSoul()
    end

    local chara = self:getSoulPartyMember()

    if chara and chara:getSoulPriority() >= 0 and chara:getMonsterSoul() then
        return chara:getMonsterSoul()
    end

    return false
end

function Game:enterShop(shop, options, light)
    if Mod.libs["magical-glass"].in_light_shop or light then
        Mod.libs["magical-glass"]:enterLightShop(shop, options)
    else
        super.enterShop(self, shop, options)
    end
end

function Game:setupShop(shop)
    local check_shop
    if type(shop) == "string" then
        check_shop = Registry.getShop(shop)
    else
        check_shop = shop
    end

    if check_shop:includes(LightShop) then
        error("Attempted to use LightShop in a Shop. Convert the shop \"" .. check_shop.id .. "\" file to a Shop")
    end

    super.setupShop(self, shop)
end

function Game:encounter(encounter, transition, enemy, context, light)
    if Mod.libs["magical-glass"].current_battle_system then
        if Mod.libs["magical-glass"].current_battle_system == "undertale" then
            self:encounterLight(encounter, transition, enemy, context)
        else
            super.encounter(self, encounter, transition, enemy, context)
        end
    else
        Mod.libs["magical-glass"].current_battle_system = "deltarune"
        if context and isClass(context) and context:includes(ChaserEnemy) then
            if context.light_encounter then
                self:encounterLight(encounter, transition, enemy, context)
            else
                super.encounter(self, encounter, transition, enemy, context)
            end
        elseif light ~= nil then
            if light then
                self:encounterLight(encounter, transition, enemy, context)
            else
                super.encounter(self, encounter, transition, enemy, context)
            end
        else
            self:setLight(Kristal.getLibConfig("magical-glass", "default_battle_system")[2])
            if Kristal.getLibConfig("magical-glass", "default_battle_system")[1] == "undertale" then
                self:encounterLight(encounter, transition, enemy, context)
            else
                super.encounter(self, encounter, transition, enemy, context)
            end
        end
    end
end

function Game:encounterLight(encounter, transition, enemy, context)
    Mod.libs["magical-glass"].current_battle_system = "undertale"

    if transition == nil then transition = true end

    if self.battle then
        error("Attempt to enter light battle while already in battle")
    end

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
end

function Game:getRecruit(id, light)
    if light then
        id = "light/" .. id
    end
    return super.getRecruit(self, id)
end

function Game:getRecruits(include_incomplete, include_hidden, light)
    local recruits = {}
    for id,recruit in pairs(self.recruits_data) do
        if (not recruit:getHidden() or include_hidden) and (recruit:getRecruited() == true or include_incomplete and type(recruit:getRecruited()) == "number" and recruit:getRecruited() > 0) then
            if light == nil or light == true and StringUtils.sub(id, 1, 6) == "light/" or light == false and StringUtils.sub(id, 1, 6) ~= "light/" then
                table.insert(recruits, recruit)
            end
        end
    end
    table.sort(recruits, function(a,b) return a.index < b.index end)
    return recruits
end

function Game:hasRecruit(recruit, light)
    return self:getRecruit(recruit, light):getRecruited() == true
end

function Game:convertToLight()
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        local inventory = self.inventory

        self.inventory = inventory:convertToLight()

        for _, chara in pairs(self.party_data) do
            chara:convertToLight()
        end
    else
        super.convertToLight(self)
    end
end

function Game:convertToDark()
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        local inventory = self.inventory

        self.inventory = inventory:convertToDark()

        for _, chara in pairs(self.party_data) do
            chara:convertToDark()
        end
    else
        super.convertToDark(self)
    end
end

return Game