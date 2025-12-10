---@class Player : Player
---@field world World
local Player, super = HookSystem.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.state_manager:addState("CLIMB", {enter = self.beginClimb, leave = self.endClimb, update = self.updateClimb})
    ---@type "left"|"right"|"up"|"down"?
    self.last_climb_direction = nil
    self.climb_delay = 0
    self.jumpchargesfx = Assets.newSound("chargeshot_charge")
    self.jumpchargesfx:setLooping(true)
    self.jumpchargesfx:setVolume(0.3)
    self.jumpchargecon = 0
    self.jumpchargetimer = 0
	self.jumpchargeamount = 0
    self.charge_times = {
        10,
        22,
    }
    self.draw_reticle = true
    self.onrotatingtower = false
    self.climb_speedboost = -1
	self.climbmomentum = 0
	self.forceclimb = false
	self.recently_bumped = nil
	self.previous_bump = nil
	self.slip_delay = 0
	self.upbuffer = 0
	self.downbuffer = 0
	self.leftbuffer = 0
	self.rightbuffer = 0
	self.currentdir = nil
	self.neutralcon = 0
	self.facing = "down"
	self.drawoffsety = 0
	self.falling = 0
	self.fallingspeed = 0
	self.fall_speed_cap = 10
	self.grabon = true
	self.graboncon = 0
	self.grabontimer = 0
	self.siner = 0
	self.exitcon = 1
end

function Player:beginClimb(last_state)
    self:setSprite("climb/climb")
	self.climbmomentum = 0
	self.neutralcon = 1
    self.world.can_open_menu = false
end

function Player:setActor(actor)
    super.setActor(self, actor)
    local size = 34
    self.climb_collider = Hitbox(Game.world, (self.width/2) - (size/2), (self.height/2) - (size/2) + 8, (size), (size))
end

function Player:draw()
    -- Draw the player
	love.graphics.translate(0, self.drawoffsety)
    super.draw(self)
	love.graphics.translate(0, 0)

    if DEBUG_RENDER then
        self.climb_collider:drawFor(self, 1, 1, 0)
    end

    if self.state == "CLIMB" and not self.onrotatingtower then
        self:drawClimbReticle()
    end
end

function Player:endClimb(next_state)
    self:resetSprite()
    self.world.can_open_menu = true
    self.physics.move_target = nil
end

function Player:processClimbInputs()
	self.siner = self.siner + DTMULT
	local this_frame_directions = {}
	local buffer_length = math.ceil(5 - (self.climbmomentum * 2))
	if buffer_length >= 5 then
		buffer_length = 4
	end
	buffer_length = 1
	if (Input.down("up") or self.upbuffer > 0) or self.forceclimb then
		if Input.down("up") and self.facing ~= "up" then
			self.upbuffer = buffer_length
			self.leftbuffer = 0
			self.rightbuffer = 0
			self.downbuffer = 0
		end
		table.insert(this_frame_directions, "up")
	end
	if (Input.down("down") or self.downbuffer > 0) and not self.forceclimb then
		if Input.down("down") and self.facing ~= "down" then
			self.upbuffer = 0
			self.leftbuffer = 0
			self.rightbuffer = 0
			self.downbuffer = buffer_length
		end
		table.insert(this_frame_directions, "down")
	end
	if (Input.down("right") or self.rightbuffer > 0) and not self.forceclimb then
		if Input.down("right") and self.facing ~= "right" then
			self.upbuffer = 0
			self.leftbuffer = 0
			self.rightbuffer = buffer_length
			self.downbuffer = 0
		end
		table.insert(this_frame_directions, "right")
	end
	if (Input.down("left") or self.leftbuffer > 0) and not self.forceclimb then
		if Input.down("left") and self.facing ~= "left" then
			self.upbuffer = 0
			self.leftbuffer = buffer_length
			self.rightbuffer = 0
			self.downbuffer = 0
		end
		table.insert(this_frame_directions, "left")
	end
	local num_inputs = #this_frame_directions
	local used_input = nil
	local cancelled_slip = false
	if num_inputs == 0 then
		self.currentdir = nil
	elseif num_inputs == 1 or self.currentdir == nil then
		self.currentdir = this_frame_directions[1]
		used_input = self.currentdir
	else
		for i = 1, #this_frame_directions do
			if this_frame_directions[i] == self.currentdir or this_frame_directions[i] == self.recently_bumped then
				if this_frame_directions[i] == self.recently_bumped then
					cancelled_slip = true
				end
				table.remove(this_frame_directions, i)
				i = i - 1
			end
		end
		
		if #this_frame_directions > 0 then
			used_input = this_frame_directions[1]
			if used_input == self.previous_bump then
				cancelled_slip = true
			else
				cancelled_slip = false
			end
		elseif self.currentdir ~= self.previous_bump and self.currentdir ~= self.recently_bumped then
			used_input = self.currentdir
			cancelled_slip = false
		else
			used_input = self.currentdir
			cancelled_slip = true
		end
	end
	local lastdir = self.facing
	if self.used_input ~= nil then
		self.facing = used_input
		self:setFacing(self.facing)
	end
	self.upbuffer = self.upbuffer - DTMULT
	self.leftbuffer = self.leftbuffer - DTMULT
	self.rightbuffer = self.rightbuffer - DTMULT
	self.downbuffer = self.downbuffer - DTMULT
    if self.falling > 0 then
		if self.falling == 1 then			
			self:setSprite("climb/slip_fall")
            self.sprite:setFrame(1)
			self.fallingspeed = 0
			self.falling = 2
			self.neutralcon = 0
			self.jumpchargesfx:stop()
			self.jumpchargecon = 0
			self.climbmomentum = 0
			self.remx = self.x
			self.remy = self.y
		end
		if self.falling == 2 then
			Object.startCache()
			local climbarea
			local trigger
			for _, event in ipairs(self.world.stage:getObjects(Event)) do
				---@cast event Event.climbarea|Event.climbentry
				-- TODO: Find out where these numbers come from, because it sure isn't the actor
				local x,y = -17, -37
				x,y = x + self.x,y + self.y
				if self.onrotatingtower then
					x = MathUtils.wrap(x, 0, self.world.width+1)
				end
				self.climb_collider.parent = self.parent
				self.climb_collider.x, self.climb_collider.y = x, y
				if (event.climbFallLanding) and event:collidesWith(self.climb_collider) then
					self.falling = 0
					self.fallingspeed = 0
					event:climbFallLanding(self)
				end
			end
			self.fallingspeed = self.fallingspeed + 0.5 * DTMULT
			if self.fallingspeed >= self.fall_speed_cap then
				self.fallingspeed = self.fall_speed_cap
			end
			if self.fallingspeed >= 20 then
				self.naturalybias = math.min(self.naturalybias + 2 * DTMULT, 80)
			end
			if self.falldir == "down" then
				self.y = self.y + math.ceil(self.fallingspeed)
			elseif self.falldir == "right" then
				self.x = self.x + math.ceil(self.fallingspeed)
			elseif self.falldir == "up" then
				self.y = self.y - math.ceil(self.fallingspeed)
			elseif self.falldir == "left" then
				self.x = self.x - math.ceil(self.fallingspeed)
			end
			self.fallingtimer = self.fallingtimer - DTMULT
			if self.fallingtimer <= 0 then
				if self.grabon then
					local allowed, obj = self:canClimb(0, 0)
					if allowed and obj and self.y >= obj.y + 30 then
						local grabx = self.x
						local graby = self.y
						self.grabx = (MathUtils.round(grabx / 40) * 40) - 20
						self.graby = (MathUtils.round(graby / 40) * 40) + 2
						self.grabontimer = 15
						self.graboncon = 1
						self.falling = 0
					end
				end
			end
			Object.endCache()
		end
		return
	end
	if self.graboncon > 0 then
		if self.graboncon == 1 then	
			self:setSprite("climb/charge/down")
            self.sprite:setFrame(3)
			self.graboncon = 2
		end
		if self.graboncon == 2 then
			Assets.stopSound("wing")
			Assets.playSound("wing", 0.7, 0.6 + MathUtils.random(0.3))
			if Utils.round(self.siner) % 2 == 0 then
				local dust = Sprite("effects/slide_dust")
				dust:play(1 / 15, false, function () dust:remove() end)
				dust:setOrigin(0.5, 0.5)
				dust:setScale(2, 2)
				dust:setPosition(self.x, self.y - 17)
				dust.layer = self.layer - 0.01
				dust.physics.speed_y = -3
				dust.physics.speed_x = MathUtils.random(-1, 1)
				self.world:addChild(dust)
			end
			if self.fallingspeed > 7 then
				self.fallingspeed = 7
			end
			self.fallingspeed = self.fallingspeed - DTMULT
			if self.falldir == "down" then
				self.y = self.y + math.ceil(self.fallingspeed)
			elseif self.falldir == "right" then
				self.x = self.x + math.ceil(self.fallingspeed)
			elseif self.falldir == "up" then
				self.y = self.y - math.ceil(self.fallingspeed)
			elseif self.falldir == "left" then
				self.x = self.x - math.ceil(self.fallingspeed)
			end
			if self.fallingspeed <= 0 then
				self.grabonclimbtimer = 0
				self.graboncon = 3
				self.remfalleny = self.y
				self.remfallenx = self.x
			end
		end
		if self.graboncon == 3 then	
			self.grabonclimbtimer = self.grabonclimbtimer + DTMULT
			local initwait = 7
			local waittime = 8
			if self.grabonclimbtimer >= initwait then
				self:slideTo(self.grabx, self.graby, waittime/30, "in-out-quad")
			end
			if self.grabonclimbtimer >= initwait + waittime then
				self.x = MathUtils.round(self.x / 10) * 10
				self.y = MathUtils.round(self.y / 10) * 10
				self.graboncon = 0  
				if self.climb_ready_callback then
					self:climb_ready_callback()
					self.climb_ready_callback = nil
				end
				self.sprite:setFrame(MathUtils.wrap(self.sprite.frame + 1, 1, #self.sprite.frames + 1))
				if self.sprite.sprite_options[2] ~= "climb/climb" then
					self:setSprite("climb/climb")
					self.sprite:setFrame(1)
				end
				self.neutralcon = 1
			end
		end
		return
	end
    if self.slip_delay > 0 then
		if self.slip_delay > 2/30 and not cancelled_slip and (used_input ~= nil and lastdir ~= used_input) or (Input.down("confirm") or Input.down("cancel")) then
			self.slip_delay = math.min(self.slip_delay, 2/30)
			self.climbmomentum = 0
		end
        self.slip_delay = MathUtils.approach(self.slip_delay, 0, DT) 
		if self.slip_delay < 3/30 then
			self.sprite:setFrame(1)
        end
        if self.slip_delay <= 0 then
            if self.climb_ready_callback then
                self:climb_ready_callback()
                self.climb_ready_callback = nil
            end
            self.sprite:setFrame(MathUtils.wrap(self.sprite.frame + 1, 1, #self.sprite.frames + 1))
			if self.falling <= 0 then
				self.neutralcon = 1
			end
            if self.sprite.sprite_options[2] ~= "climb/climb" then
                self:setSprite("climb/climb")
                self.sprite:setFrame(1)
            end
        end
        return
    end
    if self.climb_delay > 0 then
        self.climb_delay = MathUtils.approach(self.climb_delay, 0, DT)
        if self.climb_delay <= 0 then
            if self.climb_ready_callback then
                self:climb_ready_callback()
                self.climb_ready_callback = nil
            end
            self.sprite:setFrame(MathUtils.wrap(self.sprite.frame + 1, 1, #self.sprite.frames + 1))

            if self.sprite.sprite_options[2] ~= "climb/climb" then
                self:setSprite("climb/climb")
                self.sprite:setFrame(1)
            end
        end
        return
    end
    local dist
    if self.jumpchargecon >= 1 then
        if Input.released("confirm") then
			self.jumpchargecon = 0
            self.color = COLORS.white;
            self:doClimbJump(self.facing, self.jumpchargeamount)
        else
            if self.currentdir == "left" then
                self:setFacing("left")
            elseif self.currentdir == "right" then
                self:setFacing("right")
            elseif self.currentdir == "up" then
                self:setFacing("up")
            elseif self.currentdir == "down" then
                self:setFacing("down")
            end
        end
        return
    else
		if self.jumpchargecon == -1 then
			if Input.released("confirm") then
				self.jumpchargecon = 0
			end
		else
			if Input.down("confirm") then
				self.climbmomentum = 0
				self.jumpchargecon = 1
				return
			end
		end
    end
	if self.neutralcon == 1 then
		if self.currentdir == "left" then
			self:doClimbJump("left", dist)
		elseif self.currentdir == "right" then
			self:doClimbJump("right", dist)
		elseif self.currentdir == "up" then
			self:doClimbJump("up", dist)
		elseif self.currentdir == "down" then
			self:doClimbJump("down", dist)
		else
			self.climbmomentum = self.climbmomentum * 0.5*DTMULT
		end
	end
end

function Player:processJumpCharge()
    if (self.jumpchargecon == 1) then
        -- climbmomentum = 0;
        -- x = remx;
        -- y = remy;
        -- jumpchargesfx = snd_loop(snd_chargeshot_charge);
        self.jumpchargesfx:play()
        self.jumpchargesfx:setPitch(0.4)
        -- snd_volume(jumpchargesfx, 0.3, 0);
        self.jumpchargetimer = 0;
        self.jumpchargeamount = 1;
        self.jumpchargecon = 2;
        self:setSprite("climb/charge/up")
        -- sprite_index = spr_kris_climb_new_charge;
        -- image_index = 0;s
    end

    if (self.jumpchargecon == 2) then
        local docharge = 0

        if (Input.down("confirm") or self.jumpchargetimer < 3) then
            docharge = 1;
        end

        if (Input.pressed("cancel")) then
            docharge = 2;
        end

        if (docharge == 1) then
            if (self.facing == "up" or self.facing == "down") then
                self:setSprite("climb/charge/up");
            elseif (self.facing == "right") then
                self:setSprite("climb/charge/right");
            else
                self:setSprite("climb/charge/left");
            end

            self.jumpchargetimer = self.jumpchargetimer + DTMULT;

            for i = 1, #self.charge_times-1 do
                if (self.jumpchargetimer >= self.charge_times[i]) then
                    self.sprite:setFrame(MathUtils.clamp(i+1, 1, #self.sprite.frames))
                    self.jumpchargesfx:setPitch(0.5 + (i-1)/10)
                    self.jumpchargeamount = i+1;
                    self.color = TableUtils.lerp(COLORS.white, COLORS.teal, 0.2 + (math.floor(math.sin(self.jumpchargetimer / 2)) * 0.2));
                end
            end


            if (self.jumpchargetimer >= (self.charge_times[#self.charge_times] or math.huge)) then
                self.sprite:setFrame(MathUtils.clamp(#self.charge_times+1, 1, #self.sprite.frames))
                self.jumpchargeamount = (#self.charge_times+1);
                self.jumpchargesfx:setPitch(0.5 + (#self.charge_times)/10)
                self.color = TableUtils.lerp(COLORS.white, COLORS.teal, 0.4 + (math.floor(math.sin(self.jumpchargetimer)) * 0.4));

                if ((self.jumpchargetimer % 8) == 0) then
                    self.draw_reticle = false
                    local afterimage = AfterImage(self, 0.3, ((1 / (0.2)) / 30 * 0.3));
                    self.draw_reticle = true
                    afterimage.alpha = 0.3;
                    afterimage.graphics.grow = 0.05
                    afterimage.physics.speed_y = 1
                    afterimage:setParent(self)

                    -- TODO: ahaHAHHAHAHAHHAAHAHA
                    -- if (i_ex(obj_rotating_tower_controller_new) && i_ex(obj_climb_kris)) then
                    --     afterimage.x = obj_rotating_tower_controller_new.tower_x;
                    --     afterimage.depth = obj_rotating_tower_controller_new.depth - 4;
                    -- end
                end
            end
        end

        if (docharge == 0) then
            self.jumpchargecon = 0;
            self.jumpchargetimer = 0;
            self.climb_jumping = 1;
            self.climbcon = 1;
            self.color = COLORS.white;
            self.jumpchargesfx:stop()
        end

        if (docharge == 2) then
			self:setSprite("climb/climb")
            Assets.playSound("txttor", 0.7, 0.4)
            Assets.playSound("txtal", 0.7, 0.4)
            Assets.playSound("dtrans_heavypassing", 0.2, 1.8)
            self.button2buffer = 10;
            self.jumpchargecon = -1;
            self.jumpchargetimer = 0;
            self.neutralcon = 1;
            self.color = COLORS.white;
            self.jumpchargesfx:stop()
        end
    end
end

---@return boolean allowed
---@return Object? obj The object, if any, responsible for this outcome.
function Player:canClimb(dx, dy)
    Object.startCache()
    local climbarea
    local trigger
    for _, event in ipairs(self.world.stage:getObjects(Event)) do
        ---@cast event Event.climbarea|Event.climbentry
        -- TODO: Find out where these numbers come from, because it sure isn't the actor
        local x,y = -17, -37
        x,y = x + self.x,y + self.y
        x,y = x + (dx*40),y + (dy*40)
        if self.onrotatingtower then
            x = MathUtils.wrap(x, 0, self.world.width+1)
        end
        self.climb_collider.parent = self.parent
        self.climb_collider.x, self.climb_collider.y = x, y
        if (event.preClimbEnter or event.climbable) and event:collidesWith(self.climb_collider) then
            if event.climbable then
                climbarea = event
            end
            if event.preClimbEnter then
                trigger = event
            end
        end
    end
    Object.endCache()
    if climbarea then
        return true, climbarea
    end
    return NOCLIP, trigger
end

---@param direction "up"|"down"|"left"|"right"
---@param distance integer?
function Player:doClimbJump(direction, distance)
    direction = direction or self.facing
    self:setFacing(direction)
	self.neutralcon = 0
	
    local charged = (distance ~= nil)
    distance = distance or 1
    if direction == "left" or direction == "right" then
        self.last_x_climb = direction
    end
    local dx, dy = unpack(({
        up = {0, -1},
        down = {0, 1},
        left = {-1, 0},
        right = {1, 0},
    })[direction])


    Object.startCache()
    local found_obj_dist
    for dist = distance, 1, -1 do
        local allowed, obj = self:canClimb(dx*dist, dy*dist)
        if allowed then
			self.recently_bumped = nil
			self.previous_bump = nil
            Assets.playSound("wing", 0.6, 1.1 + (love.math.random()*0.1))
            if distance > 1 then
                if self.facing == "left" then
                    self:setSprite("climb/slip_left")
                elseif self.facing == "right" then
                    self:setSprite("climb/slip_right")
                else
                    self:setSprite("climb/jump_up")
                end
                self.sprite:play(0.1, true)
            else
                self.sprite:setFrame(MathUtils.wrap(math.floor(self.sprite.frame + 1, 2), 1, #self.sprite.frames+1))
            end

			local dust_amount = 1
			if charged then
				dust_amount = 5
			end
			for i = 0, dust_amount do
				local dust = Sprite("effects/climb_dust_small")
				dust:play(1 / 15, false, function () dust:remove() end)
				dust:setOrigin(0.5, 0)
				dust:setScale(2, 2)
				local dust_x = self.x
				local dust_y = self.y - 17
				if charged then
					dust_x = dust_x + MathUtils.random(-10, 10)
					dust_y = dust_y + MathUtils.random(-10, 10)
				elseif self.facing == "up" then
					dust_x = dust_x - self.sprite.width - 10 + 10 * self.sprite.frame-1
				elseif self.facing == "down" then
					dust_x = dust_x - self.sprite.width - 20 + 15 * self.sprite.frame-1
				else
					dust_y = dust_y + 10
				end
				dust:setPosition(dust_x, dust_y)
				dust.layer = self.layer - 0.01
				dust.physics.speed_y = -1
				self.world:addChild(dust)
			end
			self.drawoffsety = 0
			if charged then
				duration = (6 + distance*2)/30
				local clipamount = 4/30
				if charged then
					clipamount = 2/30
				end
				local prevx = self.x
				local prevy = self.y
				self:slideTo(self.x + (dx*40*dist), self.y + (dy*40*dist), duration, "out-sine")
				self.climbtimer = 0
				Game.world.timer:during(duration, function()
					self.climbtimer = self.climbtimer + DT
					self.drawoffsety = -math.sin((self.climbtimer / duration) * math.pi) * (2 * (self.jumpchargeamount - 1)) 
					local afterimage = Sprite(self.sprite.texture, self.x, self.y + 16) -- for some reason the afterimage object insists on sticking directly to the player so i have to do this (sorry)
					afterimage:setOrigin(0.5, 1)
					afterimage:setScale(2,2)
					afterimage.y = afterimage.y + self.drawoffsety
					afterimage.alpha = 0.2
					afterimage:fadeOutSpeedAndRemove()
					afterimage:setLayer(self.layer - 0.1)
					Game.world:addChild(afterimage)
				end)
				Game.world.timer:after(duration/2, function ()
					if self.sprite.sprite_options[2] ~= "climb/climb" then
						if self.facing == "left" then
							self:setSprite("climb/land_left")
						elseif self.facing == "right" then
							self:setSprite("climb/land_right")
						end
					end
				end)
				Game.world.timer:after(duration-clipamount, function ()
					self:resetPhysics()
					self.x = prevx + (dx*40*dist)
					self.y = prevy + (dy*40*dist)
					self.climbmomentum = self.jumpchargeamount/2
					if self.climb_ready_callback then
						self:climb_ready_callback()
						self.climb_ready_callback = nil
					end
					self.sprite:setFrame(MathUtils.wrap(self.sprite.frame + 1, 1, #self.sprite.frames + 1))

					if self.sprite.sprite_options[2] ~= "climb/climb" then
						self:setSprite("climb/climb")
						self.sprite:setFrame(1)
					end
					if self.climb_callback then
						self:climb_callback()
						self.climb_callback = nil
					end
					self.neutralcon = 1
					if obj and obj.onClimbEnter then
						obj:onClimbEnter(self)
					end
				end)
			else
				local duration = (10)/(30*(1+self.climbmomentum))
				self:slideTo(self.x + (dx*40*dist), self.y + (dy*40*dist), duration, "in-out-quad", function ()
					if self.climb_ready_callback then
						self:climb_ready_callback()
						self.climb_ready_callback = nil
					end
					self.sprite:setFrame(MathUtils.wrap(self.sprite.frame + 1, 1, #self.sprite.frames + 1))

					if self.sprite.sprite_options[2] ~= "climb/climb" then
						self:setSprite("climb/climb")
						self.sprite:setFrame(1)
					end
					if self.sprite.sprite_options[2] ~= "climb/climb" then
						if self.facing == "left" then
							self:setSprite("climb/land_left")
						elseif self.facing == "right" then
							self:setSprite("climb/land_right")
						else
							self:setSprite("climb/jump_up")
						end
					end
					if self.climb_callback then
						self:climb_callback()
						self.climb_callback = nil
					end
					self.neutralcon = 1
					if obj and obj.onClimbEnter then
						obj:onClimbEnter(self)
						self.climb_speedboost = -1
					end
				end)
			end
        elseif dist == 1 and not obj then
            Assets.playSound("bump")
            -- TODO: use the correct sprite
            if self.last_x_climb == "left" then
                self:setSprite("climb/slip_left")
            else
                self:setSprite("climb/slip_right")
            end
            self.sprite:setFrame(2)
			if self.recently_bumped ~= self.facing then
				self.previous_bump = self.recently_bumped
				self.recently_bumped = self.facing
			end
			if charged then
				self.slip_delay = (8+(distance*3))/30
			else
				self.slip_delay = (8+(self.climbmomentum*4))/30
			end
        end
        if dist <= 1 and obj and obj.preClimbEnter then
            obj:preClimbEnter(self)
        end
        if allowed then
            break
        end
    end
    Object.endCache()
end

function Player:drawClimbReticle()
    -- TODO: Something better
    if not self.draw_reticle then
        return
    end
    local tempalpha = 1;

    love.graphics.push()
    love.graphics.translate(self.width/2, self.height - 10)

    -- I /think/ this is what global.inv is?
    if (self.world.soul.inv_timer > 0) then
        tempalpha = 0.5;
    end

    local found = 0;
    local _alph;

    if (self.jumpchargecon ~= 0) then
        local count = 1;

        for i = 1, #self.charge_times do
            if self.jumpchargetimer > self.charge_times[i] then
                count = i + 1
            end
        end

        local px = 0;
        local py = 0;

        for i = 1, count do
            -- with (instance_place(px, py, obj_climbstarter))
            -- {
            --     if ((other.dir == 2 && e_up) || (other.dir == 0 && e_down) || (other.dir == 3 && e_left) || (other.dir == 1 && e_right))
            --     {
            --         found = i;
            --         break;
            --     }
            -- }

            if (self.facing == "down") then
                py = 0+i;
            end

            if (self.facing == "right") then
                px = 0+i;
            end

            if (self.facing == "up") then
                py = 0-i;
            end

            if (self.facing == "left") then
                px = 0-i;
            end
            local s,o = self:canClimb(px, py)
            if s or o then
                found = i
            end
        end

        _alph = MathUtils.clamp(self.jumpchargetimer / 14, 0.1, 0.8);
        local angle = 0;
        local xoff = 0;
        local yoff = 0;

        if (self.facing == "down") then
            angle = 0;
            xoff = -22;
            yoff = 18;
        end

        if (self.facing == "right") then
            angle = 90;
            xoff = 18;
            yoff = 22;
        end

        if (self.facing == "up") then
            angle = 180;
            xoff = 22;
            yoff = -18;
        end

        if (self.facing == "left") then
            angle = 270;
            xoff = -18;
            yoff = -22;
        end

        -- TODO: Put these colors in the PALETTE
        local col = {200/255, 200/255, 200/255};

        if (found ~= 0) then
            col = {255/255, 200/255, 132/255};
        end
        --[[
            draw_sprite_general(
                --sprite,
                Assets.getTexture("ui/climb/hint"),
                --subimg,
                floor(current_time * 0.5) % 4,
                --left, top,
                0, 0,
                --width, height,
                22, (self.jumpchargetimer / self.charge_times[2]) * 62,
                --x, y,
                x + xoff, y + yoff,
                --xscale, yscale,
                2, 2,
                --rot,
                angle,
                --c1, c2, c3, c4,
                col, col, col, col,
                --alpha
                0.85
            );
        ]]
        -- local quad = Assets.getQuad(0, 0, 22, math.floor(MathUtils.clamp(self.jumpchargetimer / self.charge_times[2], 0, 1) * 62), 22, 62)
        Draw.setColor(col)
        local frame = MathUtils.wrap(math.floor(Kristal.getTime() * 15), 1,4)
        -- Draw.draw(Assets.getFrames("ui/climb/hint")[frame], quad, xoff/2, yoff/2, -math.rad(angle))
        love.graphics.push()
        love.graphics.translate(xoff/2, yoff/2)
        love.graphics.rotate(-math.rad(angle))
        local w = (self.jumpchargetimer / (self.charge_times[#self.charge_times] or 10)) * (#self.charge_times+1)
        for i = 0, #self.charge_times do
            local id, h = "ui/climb/hint_mid", 20
            if i == 0 then
                id = "ui/climb/hint_start"
                h = 21
            elseif i == #self.charge_times then
                id = "ui/climb/hint_end"
                h = 21
            end
            local quad = Assets.getQuad(0, 0, 22, math.floor(MathUtils.clamp(w - i, 0, 1) * h), 22, h)
            Draw.draw(Assets.getFrames(id)[frame], quad)
            love.graphics.translate(0, h)

        end
        love.graphics.pop()
    end

    if (DEBUG_RENDER) then
        local count = 0;
        local space = 10;
        local border = 8;
    end

    local drawreticle = true;

    if (drawreticle and self.jumpchargecon > 0 and found ~= 0) then
        local px = 0 - 12;
        local py = 0 - 12;

        if (self.facing == "down") then
            py = py + (20 * found);
        end

        if (self.facing == "right") then
            px = px + (20 * found);
        end

        if (self.facing == "up") then
            py = px - (20 * found);
        end

        if (self.facing == "left") then
            px = px - (20 * found);
        end

        Draw.setColor(TableUtils.lerp({1,1,0,_alph}, {1,1,1,_alph}, 0.4 + (math.sin(self.jumpchargetimer / 3) * 0.4)));
        Draw.draw(Assets.getTexture("ui/climb/reticle"), px, py)
    end
    love.graphics.pop()
end

function Player:updateClimb()
    if self:isMovementEnabled() and not self.physics.move_target then
        self:processClimbInputs()
        if self.jumpchargecon > 0 then
            self:processJumpCharge()
        else
            self.jumpchargesfx:stop()
        end
    end
    -- Placeholder, obviously.
    local o_noclip = self.noclip
    self.noclip = true
    -- self:updateWalk()
    self.noclip = o_noclip
    if self.onrotatingtower and not self.physics.move_target then
        -- TODO: Find out why I have to put 1 here and not 0
        self.x = MathUtils.wrap(self.x, 1, self.world.width)
    end
	self.climbmomentum = self.climbmomentum - 0.03*DTMULT
	if self.climbmomentum <= 0 then
		self.climbmomentum = 0
	end
    Object.startCache()
    Object.endCache()
end

function Player:onRemove(parent)
    super.onRemove(self, parent)
    self.jumpchargesfx:stop()
end

function Player:onAdd(parent)
    super.onAdd(self, parent)
    if not self.world then return end
    if not self.world.map.data then return end
    if not self.world.map.data.properties then return end
    if self.world.map.data.properties.playerstate then
        self:setState(self.world.map.data.properties.playerstate)
        if self.world.map.cyltower then
            self.onrotatingtower = true
        end
    end
end

return Player
