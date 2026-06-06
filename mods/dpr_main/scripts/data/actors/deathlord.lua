local actor, super = Class(Actor, "deathlord")

function actor:init()
    super.init(self)

    self.name = "DEATH LORD"

    self.width = 34
    self.height = 34

    self.hitbox = {2, 18, 30, 16}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "battle/enemies/deathlord"
    self.default = "idle"
	
    self.disallow_replacement_texture = true
end

function actor:onSpriteInit(sprite)
    sprite.body = Assets.getTexture(sprite.path.."/body")
    sprite.face = Assets.getTexture(sprite.path.."/face")
	sprite.gunflash = Assets.getTexture(sprite.path.."/gunflash")
	
    sprite.vibratex = 0
    sprite.vibratey = 0
    sprite.vibrationtimer = 0
	sprite.show_gunflash = false
end

function actor:onSpriteDraw(sprite)
    sprite.vibrationtimer = sprite.vibrationtimer + 0.1 * DTMULT
    if sprite.vibrationtimer >= 0.1 then
        sprite.vibrationtimer = 0
        sprite.vibratex = MathUtils.random(2)
        sprite.vibratey = MathUtils.random(2)
    end

    Draw.draw(sprite.body, sprite.vibratex, sprite.vibratey, 0, 1, 1)
    Draw.draw(sprite.face, sprite.vibratex/2, sprite.vibratey/2, 0, 1, 1)
	if sprite.show_gunflash then
		Draw.draw(sprite.gunflash, sprite.vibratex - 6, sprite.vibratey + 15, 0, 1, 1)	
	end
end

return actor