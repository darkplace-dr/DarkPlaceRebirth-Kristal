local LightSavepoint, super = Class(Interactable, "lightsavepoint")

function LightSavepoint:init(data)
    super.init(self, data.center_x, data.center_y, nil, nil, data.properties)

    local properties = data.properties or {}

    self.marker = properties["marker"]
    self.advanced_menu = properties["advanced_menu"]
    self.text_once = properties["text_once"]

    self.heal_after_save = properties["heal_after_save"] or false
    self.heals = properties["heals"] ~= false

    self.solid = true

    self:setOrigin(0.5)

    self:setSprite("world/events/lightsavepoint", 1/6)

    self.used = false

    local width, height = self:getSize()
    self:setHitbox(0, math.ceil(height / 4) * 2, width, math.floor(height / 4) * 2)
end

function LightSavepoint:healParty()
    for _,member in pairs(Game.party_data) do
        if member:getHealth() < member:getStat("health") then
            member:setHealth(member:getStat("health"))
        end
    end
end

function LightSavepoint:onInteract(player, dir)
    Assets.playSound("power")

    if self.heals and not self.heal_after_save then
        self:healParty()
    end

    if self.text_once and self.used then
        self:onTextEnd()
        return
    end

    if self.text_once then
        self.used = true
    end

    super.onInteract(self, player, dir)
    return true
end

function LightSavepoint:onTextEnd()
    if not self.world then return end

    if self.heals and self.heal_after_save then
        self:healParty()
    end

    if self.advanced_menu or MagicalGlass.advanced_save_menu then
        self.world:openMenu(LightAdvancedSaveMenu(self.marker))
    else
        self.world:openMenu(LightSaveMenu(Game.save_id, self.marker))
    end
end

return LightSavepoint