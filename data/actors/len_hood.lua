local actor, super = Class(Actor, "len_hood")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Len Hoodie"

    -- Width and height for this actor, used to determine its center
    self.width = 36
    self.height = 31

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 18, 18, 14}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10, 24}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {208/255, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/len_hood"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "battle/idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "len_hoodie"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = "face/len"
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        ["spear/idle"]         = {"spear/idle", 0.25, true},
        ["spear/point"]        = {"spear/point", 0.25, true},

        ["spear_only/idle"]    = {"spear_only/idle", 0.25, true},

        -- Battle animations
        ["battle/idle"]        = {"spear/battle/idle", 1/6, true},
        ["battle/attackready"] = {"spear/battle/attackready", 0.25, true},
        ["battle/attack"]      = {"spear/battle/attack", 1/14, false, next = "battle/attackready"},
    }

    -- Table of sprites to be used as taunts for the Taunt/Parry mechanic.
    self.taunt_sprites = {"pose", "peace", "t_pose", "sit"}

    self.menu_anim = "peace"
    
    -- self:addExpressionPart("head", "face/len", 0, 0, {layer = 2, default = "head"})
    -- self:addExpressionPart("face", "face/len/face", 0, 0, {layer = 3, default = "neutral", side_b = {-1, 0}})
    -- self:addExpressionPart("mouth", "face/len/mouth", 0, 0, {layer = 4, default = "neutral"})
end

function actor:onSpriteInit(sprite)
    sprite:setScaleOrigin(0.5, 1)
    sprite:setScale(1.4, 1.4)
end

return actor
