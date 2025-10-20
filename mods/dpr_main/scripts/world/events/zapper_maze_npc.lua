---@class ZapperMazeNPC : Object
---@ZapperMazeNPC fun(...) : Object
local ZapperMazeNPC, super = Class(NPC)

function ZapperMazeNPC:init(data)
    properties = data.properties or {}
    self.button_color = Utils.parseColorProperty(properties["color"]) or COLORS.white
    super.init(self, data.properties["actor"], data.center_x, data.center_y, properties)
end

function ZapperMazeNPC:setActor(actor)
    if type(actor) == "string" then
        actor = Registry.createActor(actor)
    end

    self.actor = actor

    self.width = actor:getWidth()
    self.height = actor:getHeight()

    self.collider = Hitbox(self, self.actor:getHitbox())

    if self.sprite then
        self.sprite:remove()
    end
	
    if self.button_color then
        self.actor.button_color = self.button_color
    end

    self.sprite = self.actor:createSprite()
    self.sprite.facing = self.facing
    self.sprite.inherit_color = true
    self.sprite.on_footstep = function(s, n) self:onFootstep(n) end
    self:addChild(self.sprite)
end

return ZapperMazeNPC