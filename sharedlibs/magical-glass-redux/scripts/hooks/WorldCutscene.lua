local WorldCutscene, super = HookSystem.hookScript(WorldCutscene)

function WorldCutscene:init(world, group, id, ...)
    super.init(self, world, group, id, ...)

    if Game:isLight() then
        if self.world.menu and self.world.menu.state == "STATMENU" then
            self.world.menu:closeBox()
            self.world.menu.state = "TEXT"
        end
    end
end

function WorldCutscene:showShop()
    if Game:isLight() then
        if self.shopbox then self.shopbox:remove() end

        self.shopbox = LightShopbox()
        self.shopbox.layer = WORLD_LAYERS["textbox"]
        self.world:addChild(self.shopbox)
        self.shopbox:setParallax(0, 0)
    else
        super.showShop(self)
    end
end

function WorldCutscene:startLightEncounter(encounter, transition, enemy, options)
    options = options or {}
    transition = transition ~= false
    Game:encounter(encounter, transition, enemy, nil, true)
    if options.on_start then
        if transition and (type(transition) == "boolean" or transition == "TRANSITION") then
            Game.battle.timer:script(function(wait)
                while Game.battle.state == "TRANSITION" do
                    wait()
                end
                options.on_start()
            end)
        else
            options.on_start()
        end
    end

    local battle_encounter = Game.battle.encounter
    local function waitForEncounter(self) return (Game.battle == nil), battle_encounter end

    if options.wait == false then
        return waitForEncounter, battle_encounter
    else
        return self:wait(waitForEncounter)
    end
end

return WorldCutscene