local VoidspawnActorSprite, super = Class(ActorSprite)

function VoidspawnActorSprite:init(actor)
    super.init(self, actor)

    self.animsiner = 0

    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.iris = Sprite(self:getTexturePath("iris"), 31, 31)
    self.iris:setOrigin(0.5, 0.5)
    self.iris.debug_select = false
    self:addChild(self.iris)

    self.eye = Sprite(self:getTexturePath("eye"), 31, 31)
    self.eye:setOrigin(0.5, 0.5)
    self.eye.debug_select = false
    self:addChild(self.eye)
    
	self.eye_init_x = self.width/2
	self.eye_init_y = self.height/2

    self.max_dist_x = 300
    self.max_dist_y = 200

    self.eye_state = "CAMO" -- FOLLOWING, SET, CAMO
    self.body.alpha = 0
    self.eye.alpha = 0

    self.eye_x = 0
    self.eye_y = 0
    self.iris_x = 0
    self.iris_y = 0
end

function VoidspawnActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function VoidspawnActorSprite:setAnimation(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function VoidspawnActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function VoidspawnActorSprite:setEyeState(state, x, y)
    if self.eye_state ~= state then
        if self.eye_state == "CAMO" then
            Game.stage.timer:tween(0.5, self.body, {alpha = 1})
            Game.stage.timer:tween(0.5, self.eye, {alpha = 1})
        end
        if state == "CAMO" then
            Game.stage.timer:tween(0.5, self.body, {alpha = 0})
            Game.stage.timer:tween(0.5, self.eye, {alpha = 0})
        end
        self.eye_state = state
    end
    if state == "SET" then
        if x == nil then x = 0 end
        if y == nil then y = 0 end
        self.eye_x = (x*(29/31))
        self.eye_y = (y*(29/31))
        self.iris_x = x
        self.iris_y = y
    end
end

function VoidspawnActorSprite:update()
    super.update(self)

    local origin_x, origin_y = self.parent:getOrigin()
    if origin_y ~= 0.5 then self.parent:setOrigin(0.5, 0.5) end

    -- TODO: Make the limit a circular boundary instead of a square one, so the eye doesn't go off the body
    if Game.world.player and self.eye_state == "FOLLOWING" then
        local dist_x, dist_y = self.parent.x - Game.world.player.x, self.parent.y - Game.world.player.y
        if dist_x > self.max_dist_x then dist_x = self.max_dist_x end
        if dist_x < -self.max_dist_x then dist_x = -self.max_dist_x end
        if dist_y > self.max_dist_y then dist_y = self.max_dist_y end
        if dist_y < -self.max_dist_y then dist_y = -self.max_dist_y end

        self.eye_x = -(dist_x/self.max_dist_x) * 29
        self.eye_y = -(dist_y/self.max_dist_y) * 29
        self.iris_x = -(dist_x/self.max_dist_x) * 31
        self.iris_y = -(dist_y/self.max_dist_y) * 31
    elseif Game.world.player and self.eye_state == "CAMO" then
        local px, py = Game.world.player.x + (Game.world.player.width), Game.world.player.y
        local eye_angle = MathUtils.angle(self.parent.x + self.eye_init_x, self.parent.y + self.eye_init_y, px, py)
        self.eye_x = MathUtils.lengthDirX(30 - 16, -eye_angle)
        self.eye_y = MathUtils.lengthDirY(10 - 6, -eye_angle)
        self.iris_x = self.eye_x
        self.iris_y = self.eye_y
    end

    self.eye.x = MathUtils.lerp(self.eye.x, self.eye_init_x + self.eye_x, 0.25)
    self.eye.y = MathUtils.lerp(self.eye.y, self.eye_init_y + self.eye_y, 0.25)

    local eye_scale_x = 0 + (self.iris.x - 31)/31
    local eye_scale_y = 0 + (self.iris.y - 31)/31
    if eye_scale_x < 0 then eye_scale_x = -eye_scale_x end
    if eye_scale_y < 0 then eye_scale_y = -eye_scale_y end
    self.eye:setScale((2 - eye_scale_x/1.5)/2, (2 - eye_scale_y/1.5)/2)
    if self.eye_state ~= "CAMO" then
        self.iris:setScale((2 - eye_scale_x/1.5)/2, (2 - eye_scale_y/1.5)/2)
        self.iris.x = MathUtils.lerp(self.iris.x, self.eye_init_x + self.iris_x, 0.25)
        self.iris.y = MathUtils.lerp(self.iris.y, self.eye_init_y + self.iris_y, 0.25)
    else
        self.iris:setScale(1, 1)
        self.iris.x = self.eye_init_x + self.iris_x
        self.iris.y = self.eye_init_y + self.iris_y
    end
end

return VoidspawnActorSprite