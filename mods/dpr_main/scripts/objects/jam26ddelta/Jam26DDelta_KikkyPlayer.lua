--- The character controlled by the player when in the Board.
---@class Jam26DDelta_KikkyPlayer : Character
---@overload fun(chara: string|Actor, x?: number, y?: number) : Jam26DDelta_KikkyPlayer
local Jam26DDelta_KikkyPlayer, super = Class(Character)

function Jam26DDelta_KikkyPlayer:init(chara, x, y)
    super.init(self, chara, x, y)

    self.world = Game.world.kikky_world
    self.is_player = true

    self.state_manager = StateManager("WALK", self, true)
    self.state_manager:addState("WALK", { update = self.updateWalk })

    self.auto_moving = false

    self.hurt_timer = 0

    self.moving_x = 0
    self.moving_y = 0
    self.walk_speed = 4

    self.last_move_x = self.x
    self.last_move_y = self.y

    self.history_time = 0
    self.history = {}

    self.interact_buffer = 0

    self.battle_alpha = 0

    self.persistent = true
    self.noclip = false

    self.chara_state = "none"
	
	self.boardgrid = false
	
	self:setAnimation("dance")
    self.walking = false
	self:setScale(1)
end

function Jam26DDelta_KikkyPlayer:handleMovement()
    local walk_x = 0
    local walk_y = 0

    if     Input.down("left")  then walk_x = walk_x - 1
    elseif Input.down("right") then walk_x = walk_x + 1 end
    if     Input.down("up")    then walk_y = walk_y - 1
    elseif Input.down("down")  then walk_y = walk_y + 1 end

    self.moving_x = walk_x
    self.moving_y = walk_y

    local speed = self:getCurrentSpeed()

    self:move(walk_x, walk_y, speed * DTMULT)
end

function Jam26DDelta_KikkyPlayer:updateWalk()
    if self:isMovementEnabled() then
        self:handleMovement()
    end
end

function Jam26DDelta_KikkyPlayer:getBaseWalkSpeed()
    return 4
end

function Jam26DDelta_KikkyPlayer:getCurrentSpeed()
    local speed = self:getBaseWalkSpeed()
    return speed
end

function Jam26DDelta_KikkyPlayer:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "State: " .. self.state_manager.state)
    table.insert(info, "Walk speed: " .. self:getBaseWalkSpeed())
    table.insert(info, "Current walk speed: " .. self:getCurrentSpeed())
    table.insert(info, "Hurt timer: " .. self.hurt_timer)
    return info
end

function Jam26DDelta_KikkyPlayer:onAdd(parent)
    super.onAdd(self, parent)

    if parent:includes(World) and not parent.player then
        parent.player = self
    end
end

function Jam26DDelta_KikkyPlayer:onRemove(parent)
    super.onRemove(self, parent)

    if parent:includes(World) and parent.player == self then
        parent.player = nil
    end
end

function Jam26DDelta_KikkyPlayer:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)
end

function Jam26DDelta_KikkyPlayer:setActor(actor)
    super.setActor(self, actor)

    local hx, hy, hw, hh = self.collider.x, self.collider.y, self.collider.width, self.collider.height

    self.interact_collider = {
        ["left"] = Hitbox(self, hx - 13, hy, hw / 2 + 13, hh),
        ["right"] = Hitbox(self, hx + hw / 2, hy, hw / 2 + 13, hh),
        ["up"] = Hitbox(self, hx, hy - 19, hw, hh / 2 + 19),
        ["down"] = Hitbox(self, hx, hy + hh / 2, hw, hh / 2 + 14)
    }
end

function Jam26DDelta_KikkyPlayer:interact()
    if self.interact_buffer > 0 then
        return true
    end

    local col = self.interact_collider[self.facing]

    local interactables = {}
    for _, obj in ipairs(self.world.children) do
        if obj.onInteract and obj:collidesWith(col) then
            local rx, ry = obj:getRelativePos(obj.width / 2, obj.height / 2, self.parent)
            table.insert(interactables, { obj = obj, dist = Utils.dist(self.x, self.y, rx, ry) })
        end
    end
    table.sort(interactables, function (a, b) return a.dist < b.dist end)
    for _, v in ipairs(interactables) do
        if v.obj:onInteract(self, self.facing) then
            self.interact_buffer = v.obj.interact_buffer or 0
            return true
        end
    end

    return false
end

function Jam26DDelta_KikkyPlayer:setState(state, ...)
    self.state_manager:setState(state, ...)
end

function Jam26DDelta_KikkyPlayer:resetFollowerHistory()
    return
end

--- Aligns the player's followers' directions and positions.
---@param facing?   string  The direction every character should face (Defaults to player's direction)
---@param x?        number  The x-coordinate of the 'front' of the line. (Defaults to player's x-position)
---@param y?        number  The y-coordinate of the 'front' of the line. (Defaults to player's y-position)
---@param dist?     number  The distance between each follower.
function Jam26DDelta_KikkyPlayer:alignFollowers(facing, x, y, dist)
    return
end

--- Adds all followers' current positions to their movement history.
function Jam26DDelta_KikkyPlayer:interpolateFollowers()
    return
end

function Jam26DDelta_KikkyPlayer:isCameraAttachable()
    return
end

function Jam26DDelta_KikkyPlayer:isMovementEnabled()
    return not OVERLAY_OPEN
        and not Game.lock_movement
        and Game.state == "OVERWORLD"
        and self.world.state == "GAMEPLAY"
        and self.hurt_timer <= 1
        and Game.world.door_delay == 0
		and Game.world.kikky_world.gameplay_active
end

function Jam26DDelta_KikkyPlayer:isMoving()
    return self.moving_x ~= 0 or self.moving_y ~= 0
end

-- Creates a smoke puff effect.
---@param x?        number  The x-coordinate of the effect. (Defaults to player's x-position)
---@param y?        number  The y-coordinate of the effect. (Defaults to player's y-position)
---@param color?    table   The color of the effect.
function Jam26DDelta_KikkyPlayer:createPuff(x, y, color)
    local color = color or {}

    local puff = Jam26DDelta_KikkySmokePuff(x or self.moving_x, y or self.moving_y)
    puff:setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    puff:setOriginExact(8, 8)
    puff:setLayer(self.layer + 0.1)
    self:addChild(puff)
end

function Jam26DDelta_KikkyPlayer:updateHistory()
    if #self.history == 0 then
        table.insert(self.history, { x = self.x, y = self.y, time = 0 })
    end

    local moved = self.x ~= self.last_move_x or self.y ~= self.last_move_y

    local auto = self.auto_moving

    if moved then
        self.history_time = self.history_time + DT

        table.insert(self.history, 1,
            { x = self.x, y = self.y, facing = self.facing, time = self.history_time, state = self.state_manager.state,
                state_args = self.state_manager.args, auto = auto })
        while (self.history_time - self.history[#self.history].time) > (Game.max_followers * FOLLOW_DELAY) do
            table.remove(self.history, #self.history)
        end
    end

    -- Need this for ralsei
    for _, follower in ipairs(Game.world.kikky_world.followers) do
        follower:updateHistory(moved, auto)
    end

    self.last_move_x = self.x
    self.last_move_y = self.y
end

function Jam26DDelta_KikkyPlayer:update()
    self.state_manager:update()

    self:updateHistory()

    if not Game.world.cutscene and not Game.world.menu then
        self.interact_buffer = MathUtils.approach(self.interact_buffer, 0, DT)
    end

    if self.moved > 0 then
		if not self.walking then
			self:setAnimation("walk")
		end
        self.walking = true
        self.moved = 0
    else
		if self.walking then
			self:setAnimation("dance")
		end
        self.walking = false
    end
    if self.jumping then
        self:processJump()
    end

    if (self.spin_speed ~= 0) then
        self.spin_timer = self.spin_timer + (1 / self.spin_speed) * DTMULT
        local facing = self:getFacing()

        if (self.spin_timer >= 1) then
            if (facing == "down") then
                self:setFacing("left")
            elseif (facing == "left") then
                self:setFacing("up")
            elseif (facing == "up") then
                self:setFacing("right")
            elseif (facing == "right") then
                self:setFacing("down")
            end

            self.spin_timer = 0
        end
        if (self.spin_timer <= -1) then
            if (facing == "down") then
                self:setFacing("right")
            elseif (facing == "left") then
                self:setFacing("down")
            elseif (facing == "up") then
                self:setFacing("left")
            elseif (facing == "right") then
                self:setFacing("up")
            end

            self.spin_timer = 0
        end
    else
        self.spin_timer = 0
    end

    if self.alert_timer > 0 then
        self.alert_timer = MathUtils.approach(self.alert_timer, 0, DTMULT)
        if self.alert_timer == 0 then
            self.alert_icon:remove()
            self.alert_icon = nil
            if self.alert_callback then
                self.alert_callback()
                self.alert_callback = nil
            end
        end
    end

    super.super.update(self)
end

function Jam26DDelta_KikkyPlayer:preDraw()
	self.true_x = self.x
	self.true_y = self.y
	if self.boardgrid then
		self.x = MathUtils.round(self.x / 2) * 2
		self.y = MathUtils.round(self.y / 2) * 2
	end
	super.preDraw(self)
end

function Jam26DDelta_KikkyPlayer:postDraw()
	super.postDraw(self)
	self.x = self.true_x
	self.y = self.true_y
end

function Jam26DDelta_KikkyPlayer:draw()
    -- Draw the player
	super.draw(self)

    local col = self.interact_collider[self.facing]
    if DEBUG_RENDER then
        col:draw(1, 0, 0, 0.5)
    end
end

return Jam26DDelta_KikkyPlayer
