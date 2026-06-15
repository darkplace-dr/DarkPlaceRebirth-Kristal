local Savepoint, super = HookSystem.hookScript(Savepoint)

function Savepoint:init(x, y, properties)
    super.init(self, x, y, properties)
    
    self.heals = properties["heals"]
    
    if self.heals == nil then
        self.heals = (not Game:isLight() and Kristal.getLibConfig("magical-glass", "savepoint_heal")[1]) or (Game:isLight() and Kristal.getLibConfig("magical-glass", "savepoint_heal")[2])
    end

    if Game:isLight() and Kristal.getLibConfig("magical-glass", "savepoint_style") == "undertale" then
        self:setSprite("world/events/lightsavepoint", 1 / 6)
    end
end

function Savepoint:onTextEnd()
    if not Game:isLight() then
        super.onTextEnd(self)
    else
        if not self.world then return end

        if self.heals then
            for _, party in pairs(Game.party_data) do
                party:heal(math.huge, false)
            end
        end

        if Kristal.getLibConfig("magical-glass", "savepoint_style") ~= "undertale" then
            self.world:openMenu(LightSaveMenu(self.marker))
        elseif self.simple_menu or (self.simple_menu == nil and not Kristal.getLibConfig("magical-glass", "light_save_menu_expanded")) then
            self.world:openMenu(LightSaveMenuNormal(Game.save_id, self.marker))
        else
            self.world:openMenu(LightSaveMenuExpanded(self.marker))
        end
    end
end

function Savepoint:update()
    if Game:isLight() and Kristal.getLibConfig("magical-glass", "savepoint_style") == "undertale" then
        Interactable.update(self)
    else
        super.update(self)
    end
end

return Savepoint