---@class PickupPlush : Event
---@overload fun(...) : PickupPlush
local PickupPlush, super = Class(Event, "plush")

function PickupPlush:init(data)
    super.init(self, data.x, data.y, {40, 40})

    local properties = data.properties or {}

    self.char = properties["character"]
	
    self.can_pickup = properties["can_pickup"] ~= false
	self.collectable = properties["collectable"]
	self.cutscene = properties["cutscene"]

    self.sprite = Sprite("world/events/pickup_plush/" ..self.char.. "_plush")
    self:addChild(self.sprite)
    self:setSize(self.sprite:getSize())
    self:setHitbox(1, 10, 18, 12)

    self:setOrigin(0.5, 1)
    self:setScale(2)

    self.solid = true

	self.held = false
	self.place_math = {
		["up"] = {0, -22},
		["down"] = {0, 42},
		["left"] = {-42, 0},
		["right"] = {42, 0},
	}

	self.onPickup = nil
	self.onPlace = nil
	self.onTryPlace = nil
end

function PickupPlush:postLoad()
	self.old_parent = self.parent
end

function PickupPlush:onAddToStage(stage)
	super.onAddToStage(self, stage)
	
    if not self.collectable and not Game:getFlag(self.char.."_plush") then
        self:remove()
		return
    end
end

function PickupPlush:playPickupSound()
	local path = "voice/"..self.char
	if (Assets.hasSound(path)) then
		Assets.playSound(path)
	else
		Assets.playSound("swallow")
	end
end

function PickupPlush:collect()
	if Game.world:hasCutscene() then return end
	if self.cutscene then Game.world:startCutscene(self.cutscene) return end

	Game.world:startCutscene(function (cutscene)
		Assets.playSound("achievement")
		cutscene:text("* You found the "..(self.name or StringUtils.titleCase(self.char)).." Plush!")
		Assets.playSound("item")
		self:remove()
		Game:setFlag(self.char.."_plush", true)
	end)
end

function PickupPlush:onInteract(player, dir)
	if not self.can_pickup or Game.world:hasCutscene() then return false end
	if self.collectable then self:collect() return end

	self:playPickupSound()
    self:setParent(player)
	self.x = player.width/2
	self.y = 6
	self:setScale(1.25, 0.75)
	self.target_scale_x = 1
	self.target_scale_y = 1
	
	self.held = true
	player.holding = player.holding or {}
	table.insert(player.holding, self)
	if (player.holding[(#player.holding)-1]) then
		self.y = player.holding[(#player.holding)-1].y - (player.holding[(#player.holding)-1].height - 8)
	end

	if (self.onPickup) then self:onPickup() end

    return true
end

function PickupPlush:update()
	super.update(self)

	if (self.target_scale_x) then
		self.scale_x = MathUtils.lerp(self.scale_x, self.target_scale_x, 0.3*DTMULT)
	end
	if (self.target_scale_y) then
		self.scale_y = MathUtils.lerp(self.scale_y, self.target_scale_y, 0.3*DTMULT)
	end
	
	if self.held and Input.pressed("confirm") and self:canPlace(Game.world.player) and ((not Game.world.player.holding) or Game.world.player.holding[#Game.world.player.holding] == self) then
		self:playPickupSound()
		self:place()
		self.x = Game.world.player.x + self.place_math[Game.world.player.facing][1]
		self.y = Game.world.player.y + self.place_math[Game.world.player.facing][2]
		self:setScale(2.5, 1.5)
		self.target_scale_x = 2
		self.target_scale_y = 2
		if (self.onPlace) then self:onPlace() end
	end
end

function PickupPlush:place()
	local new_x, new_y = Game.world.player:getRelativePos(self.x, self.y, Game.world)
	self:setParent(Game.world)
	self.held = false
	Game.world.player.holding = Game.world.player.holding or {}
	TableUtils.removeValue(Game.world.player.holding, self)
	self:setScale(2, 2)
	self.target_scale_x = nil
	self.target_scale_y = nil
	self.x = new_x
	self.y = new_y
end

function PickupPlush:canPlace(player)
	return not Game.world:checkCollision(player.interact_collider[player.facing]) or (self.onTryPlace and self:onTryPlace())
end

function PickupPlush:onRemove(parent)
	self.data = nil
    if parent:includes(World) or parent.world then
        self.world = nil
    end
end

return PickupPlush