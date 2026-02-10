---@class PickupPlush : Pickup
---@overload fun(...) : PickupPlush
local PickupPlush, super = Class(Event, "plush")

function PickupPlush:init(data)
    super.init(self, data.x, data.y, {data.w, data.h})

    local properties = data.properties or {}

    self.char = data.properties["character"]	
    self.sprite = Sprite("world/events/pickup_plush/" ..self.char.. "_plush")
    self:addChild(self.sprite)
    self:setSize(self.sprite:getSize())
    self:setHitbox(1, 2, 18, 17)

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.solid = true
	
	self.held = false
	
	self.place_math = {
		["up"] = {0, -42},
		["down"] = {0, 20},
		["left"] = {-42, -20},
		["right"] = {42, -20},
	}

    if Game:getFlag("" ..self.char.. "_plush") then
    else
        self.kill_me = true
    end
end

function PickupPlush:postLoad()
	self.old_parent = self.parent
end

function PickupPlush:playPickupSound()
    if self.char == "hero" then
	    Assets.playSound("voice/hero")
    elseif self.char == "dess" then
	    Assets.playSound("voice/dess")
    end
end

function PickupPlush:onInteract(player, dir)
	self:playPickupSound()
    self:setParent(player)
	self.x = player.width/2
	self.y = -6
	self:setScale(1,1)
	
	self.held = true
	player.holding = self

    return true
end

function PickupPlush:update()
	super.update(self)
	
	if self.held and Input.pressed("confirm") and self:canPlace(Game.world.player) then
		self:playPickupSound()
		self:setParent(Game.world)
		self.held = false
		Game.world.player.holding = nil
		self.x = Game.world.player.x + self.place_math[Game.world.player.facing][1]
		self.y = Game.world.player.y + self.place_math[Game.world.player.facing][2]
		self:setScale(2,2)
	end
    if self.kill_me then 
        self:remove()
    end
end

function PickupPlush:canPlace(player)
	return not Game.world:checkCollision(player.interact_collider[player.facing])
end

function PickupPlush:onRemove(parent)
	self.data = nil
    if parent:includes(World) or parent.world then
        self.world = nil
    end
end

return PickupPlush