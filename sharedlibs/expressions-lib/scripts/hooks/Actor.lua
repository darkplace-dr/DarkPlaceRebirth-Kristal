--- Actors are a type of data class that represent the visuals of a character - anything that is some type of character, be it the player, an NPC, or an enemy in battle, it will require an actor. \
--- As a data class, actors are stored in `scripts/data/actors/`, and extend this class. Their filepath starting from here becomes their id, unless an id is specified as an argument to `Class()`.
---@class Actor : Class
---@overload fun(...) : Actor
local Actor, super = HookSystem.hookScript(Actor)

function Actor:init()
    super.init(self)

    -- Table with data for this actor's expression parts for dialogue (optional)
    -- (do not touch, add new expression parts using self:addExpressionPart())
    self.expression_parts = nil
    
    -- The speed at which the blinking sprites will play.
    self.blink_speed = 4/30
    
    -- The speed at which the talksprites will play.
    self.talk_speed = 4/30

    -- How long until the blink sprites play
    -- Can either be a fixed number or a number range. If its a range, a random number between the two will be picked after each blink.
    self.blink_delay = {1, 3}

end

function Actor:getExpressionParts()
    return self.expression_parts
end

function Actor:getExpressionPart(name)
    if name and self:getExpressionParts()[name] then
        return self:getExpressionParts()[name]
    end
    return nil
end

--- Creates data for an expression part.
---@param name string
---@param path string
---@param x number
---@param y number
---@param options table?
function Actor:newExpressionPart(path, x, y, options)
    return {
        path = path,
        x = x,
        y = y,
        options = options or {},
    }
end

--- Stores data for an expression part on this actor.
---@param name string
---@param path string
---@param x number
---@param y number
---@param options table?
function Actor:addExpressionPart(name, path, x, y, options)
    self.expression_parts = self.expression_parts or {}
    self.expression_parts[name] = self:newExpressionPart(path, x, y, options)
end

function Actor:getTalkSprites() return self.talk_sprites end
function Actor:getTalkSprite(sprite)
    if not self.talk_sprites or not sprite then return nil end
    local entry = self.talk_sprites[sprite]
    if type(entry) == "table" then
        return entry
    end
    return nil
end

-- for compatibility with the old talksprites, which took a number as the value instead of a table
function Actor:getTalkSpeed(sprite)
    local talk_sprite = self:getTalkSprite(sprite)
    if type(talk_sprite) == "table" then
        return talk_sprite[2]
    else
        return talk_sprite or 0.25
    end
end

return Actor