---@class GreenBlob : Bullet
---@overload fun(...) : GreenBlob
local GreenBlob, super = Class(Bullet)

function GreenBlob:init(x, y)
    super.init(self, x, y, "battle/bullets/titan/darkshape_transform")
    self.sprite:stop()

    self.layer = BATTLE_LAYERS["top"]
	self:setScale(1,1)
    self.collidable = false
    self.grazed = true
    self.size = 2
    self.damage = 90

    self.prime_speed = 4
    self.max_speed = 5
    self.acc = 20

    self.image_index = 1
    self.image_speed = 0.5
    self.r = 1
    self.g = 1
    self.b = 1
end

function GreenBlob:prime()
    local size_to = 0.6
    if self.size == 1 then
        size_to = 0.4
    end
    if self.size == 3 then
        size_to = 0.8
    end
    if self.size == 0 then
        size_to = 0
    end

    Game.battle.timer:lerpVar(self, "scale_x", self.scale_x, size_to, 20)
    Game.battle.timer:lerpVar(self, "scale_y", self.scale_y, size_to, 20)
    
    if self.size == 0 then
        Game.battle.timer:after(20/30, function()
		    self:remove()
        end)
    else
        Game.battle.timer:lerpVar(self, "r", self.r, 1, 20)
        Game.battle.timer:lerpVar(self, "g", self.g, 1, 20)
        Game.battle.timer:lerpVar(self, "b", self.b, 0, 20)

        Game.battle.timer:after(20/30, function()
		    self.collidable = true
        end)
    end
    
    self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y) + -math.rad(180)
    self.physics.speed = self.prime_speed

    --Assets.playSound("hurt_bc", nil, 0.5)
end

function GreenBlob:partiallyPrime()
    Game.battle.timer:lerpVar(self, "scale_x", self.scale_x, 1, 20)
    Game.battle.timer:lerpVar(self, "scale_y", self.scale_y, 1, 20)
    Game.battle.timer:lerpVar(self, "r", self.r, 0.5, 20)
    Game.battle.timer:lerpVar(self, "g", self.g, 0.5, 20)
    Game.battle.timer:lerpVar(self, "b", self.b, 0.5, 20)
end
function GreenBlob:update()
    super.update(self)
	
    self.image_index = self.image_index + (1/(30 * self.image_speed)) * DTMULT

    self:setColor({self.r, self.g, self.b})
    self.sprite:setFrame(1 + math.floor(self.image_index % 6))
    self.physics.speed = self.physics.speed * 0.85
	
    if self.collidable then
        local accel = self.acc / Utils.dist(self.x, self.y, Game.battle.soul.x + 2, Game.battle.soul.y + 2)
        self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        self.physics.speed = Utils.approach(self.physics.speed, self.max_speed, accel*DTMULT)
    end
end

function GreenBlob:onCollide()
    Game.battle.tension_bar:flash()

    Assets.stopAndPlaySound("swallow", self.size * 0.2)
    Assets.stopAndPlaySound("eye_telegraph", self.size * 0.2, 2)
    local tensionscale = 1
    local tensionscale_perloss = 1
	
    self:finisherExplosion()
    self:remove()
    Game:giveTension((self.size * 2 * tensionscale * tensionscale_perloss) / 2.5)
end

function GreenBlob:finisherExplosion()
    local boom = Sprite("effects/titan/finisher_explosion", self.x, self.y)
    boom.rotation = math.rad(0)
    boom:setOrigin(0.5, 0.5)
    boom:setScale(0.0625, 0.0625)
    boom:setLayer(BATTLE_LAYERS["top"])
    Game.battle.timer:lerpVar(boom, "scale_x", boom.scale_x, boom.scale_x * 3, 4)
    Game.battle.timer:lerpVar(boom, "scale_y", boom.scale_y, boom.scale_y * 3, 4)
    boom:setFrame(3)
    boom:play(1/30, false)
    boom:setColor(COLORS.yellow)
    Game.battle:addChild(boom)

    Game.battle.timer:after(5/30, function()
	    boom:remove()
    end)
end

return GreenBlob