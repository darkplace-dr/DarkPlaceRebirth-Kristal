local actor, super = Class(Actor, "cafe_cat")

function actor:init()
    super.init(self)

    self.name = "rarecat"

    self.width = 41
    self.height = 40

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {10, 34, 22, 12}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "minigames/rarecats"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "cat_dance"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {0, 0}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
    }

    -- Table of sprite animations
    self.animations = {
        ["cat_dance"] = {"cat_dance", 1/12, true},
    }

    self.offsets = {
    }
end

function actor:onWorldDraw(chara)

    --local r, g, b = Utils.hslToRgb(Kristal.getTime() / 4 % 1, 1, 0.5)

end

function actor:onSpriteInit(sprite)

    local r = math.random(3, 12)/ 10
    local g = math.random(3, 12)/ 10
    local b = math.random(3, 12)/ 10

    sprite:setColor(r, g, b)

end


function actor:onWorldUpdate(chara)
end

return actor