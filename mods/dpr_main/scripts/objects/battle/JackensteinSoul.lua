local JackensteinSoul, super = Class(Soul)

function JackensteinSoul:init(x,y,color)
    super.init(self, x, y, color)

    self.sprite:setSprite("player/heart_dodge_small")
    self.outline:setSprite("player/heart_invert_small")
    self.sprite_focus:setSprite("player/heart_dodge_small_focus")
    self.collider = CircleCollider(self, 0, 0, 3)
    self.graze_sprite.texture = Assets.getTexture("player/graze_small")
    self.graze_sprite.width = self.graze_sprite.texture:getWidth()
    self.graze_sprite.height = self.graze_sprite.texture:getHeight()
    self.graze_collider = CircleCollider(self, 0, 0, 12 * self.graze_size_factor)
end

function JackensteinSoul:update()
    super.update(self)
	
	if Input.down("cancel") and not self.blue then
		self.collider.radius = 1.5
		self.sprite_focus.alpha = 1
	else
		self.collider.radius = 3
		self.sprite_focus.alpha = 0
	end
	if Game.battle.encounter.heartlight then
		local light = Game.battle.encounter.heartlight
		light.x = self.x
		light.y = self.y
	end

    local collided_collectibles = {}
    Object.startCache()
    for _,collectible in ipairs(Game.stage:getObjects(GhostHouseDot)) do
        if collectible:collidesWith(self.collider) then
            table.insert(collided_collectibles, collectible)
        end
	end
    for _,collectible in ipairs(Game.stage:getObjects(GhostHouseKey)) do
        if collectible:collidesWith(self.collider) then
            table.insert(collided_collectibles, collectible)
        end
	end
    for _,collectible in ipairs(Game.stage:getObjects(GhostHouseExit)) do
        if collectible:collidesWith(self.collider) then
            table.insert(collided_collectibles, collectible)
        end
	end
    for _,collectible in ipairs(Game.stage:getObjects(GhostHouseTrigger)) do
        if collectible:collidesWith(self.collider) then
            table.insert(collided_collectibles, collectible)
        end
	end
    Object.endCache()
    for _,collectible in ipairs(collided_collectibles) do
        collectible:onCollide(self)
    end
end

function JackensteinSoul:setFacing(face)
    if self.sprite then
        if face then
            self.sprite:setSprite("player/"..face.."/heart_dodge_small")
        else
            self.sprite:setSprite("player/heart_dodge_small")
        end
    end
    if self.graze_sprite then
        if face then
            self.graze_sprite.texture = Assets.getTexture("player/"..face.."/graze_small")
        else
            self.graze_sprite.texture = Assets.getTexture("player/graze_small")
        end
    end
end

return JackensteinSoul