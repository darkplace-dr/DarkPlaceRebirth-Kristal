-- Extend the Event class, and set the ID to "pinwheel"
-- This is what you'll use to refer to the event in Tiled
---@class PodiumItem : Event
local PodiumItem, super = Class(Event, "podiumitem")

-- `data` is the data directly from Tiled
function PodiumItem:init(data)
    -- Place the event at the correct position, and make the size 20x20
    super.init(self, data.x, data.y, 20, 20, data)

    -- Any custom properties are stored in `data.properties`
    local properties = data and data.properties or {}

    self.path = properties["path"]
    self.item = properties["item"]

    -- Most events in DELTARUNE are 2x sized
    self:setScale(2)

    -- We placed a single point in Tiled, which we want to be the bottom center of the pinwheel
    self:setOrigin(0.5, 1)

    if self.path then
        self:setSprite(self.path)
    end

    self.siner = 0
end

function PodiumItem:onAdd(parent)
    super.onAdd(self, parent)

    if self:getFlag("grabbed") then
        self:remove()
    end
end

function PodiumItem:tryGiveItem(dont_remove)
    if not self.item then return end
    local success, result_text = Game.inventory:tryGiveItem(self.item)
    if success and not dont_remove then
        self:remove()
    end

    return success, result_text
end

-- Update gets called every frame
function PodiumItem:update()
    super.update(self)
    
    self.sine = math.sin(self.siner)
    self.sprite:setPosition(0, 0 + self.sine)
    self.siner = self.siner + DTMULT / 10
    self.sprite.alpha = self.alpha
end

function PodiumItem:draw()
    local sprite_x, sprite_y = self.sprite:getRelativePosFor(self)
    local y = sprite_y / 1.3 + self.sprite:getScaledHeight() / 0.7
    local radius = self.sprite.width / 1.2
    local sine = self.sine or 0
    love.graphics.setColor(0, 0, 0, (0.2 + (sine / 10)) * self.alpha)
    love.graphics.circle("fill", 0 + self.sprite.width, y, radius)

    super.draw(self)
end

return PodiumItem