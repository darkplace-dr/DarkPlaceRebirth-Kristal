local actor, super = Class(Actor, "gus")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "GUS"

    -- Width and height for this actor, used to determine its center
    self.width = 22
    self.height = 27

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/cliffside/gus"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        ["idle"] = {"idle", 1/4, true},
        ["talk"] = {"talk", 0.2, true},
        ["asleep"] = {"asleep", 1/4, true},
    }

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {}
end

function actor:onTalkStart(text, sprite)
    if sprite.sprite == "idle" then
        sprite:setAnimation("talk")
    end
end

function actor:onTalkEnd(text, sprite)
    if sprite.sprite == "talk" then
        sprite:setAnimation("idle")
    end
end

return actor