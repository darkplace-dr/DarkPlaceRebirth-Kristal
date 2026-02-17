local Rabbit, super = Class(Bullet)

function Rabbit:init(x, y)
    super.init(self, x, y, "bullets/rabbick/rabbit")
    self.sprite:stop()

    self.collider = CircleCollider(self, 15, 20, 5)
    self:setOriginExact(15, 20)

	self.alpha = 0
	self:fadeTo(1, 0.1)

    self.tp = 3.6
    self.time_bonus = 3
    self.destroy_on_hit = false
    self.grazed = false
	
    self.jumpsiner = MathUtils.random(100)
    self.physics.speed_x = -3 - MathUtils.random(1)
    self.jumpspeed = 8 + MathUtils.random(4)
    self.jumpheight = 50 + MathUtils.random(10)
end

function Rabbit:update()
	super.update(self)
	
    self.jumpsiner = self.jumpsiner + DTMULT
	
    local bottom_y = Game.battle.arena.y + Game.battle.arena.height / 2 - 20
    local jsine = (math.sin(self.jumpsiner / self.jumpspeed)) * self.jumpheight + DTMULT
    self.y = (bottom_y + jsine) - self.jumpheight
    self.sprite:setFrame(2)
	
    if jsine > 0 then
        self.sprite:setFrame(3)
    end
    if jsine > (self.jumpheight / 2) then
        self.sprite:setFrame(1)
    end
	
    if self.x <= (Game.battle.arena.x - Game.battle.arena.width / 2 - 40) then
        self.alpha = self.alpha - 0.1 * DTMULT
    end
end

return Rabbit