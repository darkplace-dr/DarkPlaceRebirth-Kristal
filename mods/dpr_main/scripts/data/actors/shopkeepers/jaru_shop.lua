local actor, super = Class(Actor, "jaru_shop")

function actor:init()
    super.init(self)

    self.name = "JARU"

    self.width = 93
    self.height = 105

    self.path = "shopkeepers/jaru"
    self.default = "idle"

    self.voice = "jaru"

    self.animations = {
        ["idle"]          = {"body", 1, true},
        ["annoyed"]       = {"body", 1, true},
        ["eyebrow_raise"] = {"body", 1, true},
        ["suspicious"]    = {"body", 1, true},
        ["happy"]         = {"body", 1, true},
        ["point"]         = {"body", 1, true},
        ["thumbs_up"]     = {"body", 1, true},
        ["bye"]           = {"body", 1, true},
    }

    self.offsets = {}
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)

    sprite.animsiner = 0

    sprite.shake_x = 0
    sprite.shake_y = 0
    sprite.shake_timer = 0

    sprite.init_x = 0
    sprite.init_y = 0

    sprite.eyes = self.path.."/eyes/annoyed_1"
    sprite.eyes_x = 0
    sprite.eyes_y = 0
    sprite.eyes_timer = 0

    sprite.hand_r = self.path.."/hand_r/default_1"
    sprite.hand_r_x = -6
    sprite.hand_r_y = 96
end

function actor:onSpriteDraw(sprite)
    super.onSpriteDraw(sprite)
	
    sprite.eyes = self.path.."/eyes/annoyed"
    sprite.hand_r = self.path.."/hand_r/default"

    if sprite.anim == "annoyed" then
        sprite.eyes = self.path.."/eyes/annoyed"

        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        sprite.hand_r_y = 96

        Draw.draw(Assets.getTexture(sprite.eyes), sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)

    elseif sprite.anim == "eyebrow_raise" then
        sprite.eyes = self.path.."/eyes/eyebrow_raise"

        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        sprite.hand_r_y = 96

        Draw.draw(Assets.getTexture(sprite.eyes), sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)

    elseif sprite.anim == "suspicious" then
        sprite.eyes_timer = sprite.eyes_timer + (1 * DTMULT)
        sprite.eyes = Assets.getFrames(self.path.."/eyes/suspicious")
        local frame = math.floor((sprite.eyes_timer/20) * 2) % #sprite.eyes + 1

        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        sprite.hand_r_y = 96

        Draw.draw(sprite.eyes[frame], sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)

    elseif sprite.anim == "point" then
        sprite.eyes = self.path.."/eyes/eyebrow_raise"
        sprite.hand_r = self.path.."/hand_r/point"

        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        sprite.hand_r_y = 86

        Draw.draw(Assets.getTexture(sprite.eyes), sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)

    elseif sprite.anim == "thumbs_up" then
        sprite.hand_r = self.path.."/hand_r/thumbs_up"
        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        Game.stage.timer:lerpVar(sprite, "hand_r_y", sprite.hand_r_y, 76, 10, 2, "out")

        Draw.draw(Assets.getTexture(sprite.eyes), sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)

    else
        sprite.eyes_x = 0
        sprite.eyes_y = 0
        sprite.hand_r_x = -6
        sprite.hand_r_y = 96

        Draw.draw(Assets.getTexture(sprite.eyes), sprite.eyes_x, sprite.eyes_y)
        Draw.draw(Assets.getTexture(sprite.hand_r), sprite.hand_r_x, sprite.hand_r_y)
    end
end

return actor