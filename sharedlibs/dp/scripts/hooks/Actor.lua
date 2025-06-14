---@class Actor : Actor
local Actor, super = Utils.hookScript(Actor)

function Actor:init()
    super.init(self)

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {}

    self.shiny_id = nil
end

function Actor:getShinyID() return self.shiny_id or self.id end

return Actor