---@class Actor : Actor
local Actor, super = HookSystem.hookScript(Actor)

function Actor:init()
    super.init(self)

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {}

    self.shiny_id = nil

    self.walk_path = "walk"
    self.run_path = "run"
    self.talk_path = "talk"

    self.running_sprites = false
    self.directional_talking = false
end

function Actor:getShinyID() return self.shiny_id or self.id end

function Actor:getWalkSpritesPath() return self.walk_path end

function Actor:getRunSpritesPath() return self.run_path end

function Actor:getTalkSpritesPath() return self.talk_path end

function Actor:usesRunningSprites() return self.running_sprites end

function Actor:usesDirectionalTalking() return self.directional_talking end

return Actor