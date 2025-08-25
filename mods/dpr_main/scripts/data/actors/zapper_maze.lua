local actor, super = Class(Actor, "zapper_maze")

function actor:init()
    super.init(self)

    self.name = "Zapper"

    self.width = 48
    self.height = 76

    self.hitbox = {4, 52, 40, 24}

    self.color = {1, 0, 0}

    self.flip = "right"

    self.path = "world/npcs/zapper"
    self.default = "talk"

    self.animations = {}

    self.talk_sprites = {
        ["talk"] = 0.15
    }

    self.offsets = {}

    self.button_color = COLORS.white or {1, 1, 1}
end

function actor:onSpriteInit(sprite)
    sprite.draw_children_above = 0
    sprite.draw_children_below = 0

    sprite.buttons = Sprite(self.path.."/maze/talk_colmask")
    sprite.buttons:setFrame(sprite.frame)
    sprite.buttons:setColor(self.button_color)
    sprite.buttons.debug_select = false
    sprite:addChild(sprite.buttons)
end

function actor:onSpriteUpdate(sprite)
    sprite.buttons:setFrame(math.floor(sprite.frame))
end

return actor