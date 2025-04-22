local mb_map, super = Class(Map)

function mb_map:load()
	self.return_map = Kristal.mb_map_dest
	if not Game:getFlag("mb_partySet", nil) then
	    self.old_party = {}
	    for _,v in ipairs(Game.party) do
	    	table.insert(self.old_party, v.id)
	    end
		Game:setPartyMembers("kris")
		Game:setFlag("mb_partySet", true)
	end

	self.stepback = 0.01
	Game.world.camera.keep_in_bounds = false

	self.limit_timer = 900

	self.movement_was_locked = false

	super.load(self)
end

function mb_map:onEnter()
	for i,follower in ipairs(Game.world.followers) do
    	follower.visible = false
    end

    for key,_ in pairs(Assets.sound_instances) do
		Assets.stopSound(key, true)
	end
	if Game.lock_movement then
		self.movement_was_locked = true
		Game.lock_movement = false
	end
	Kristal.callEvent(KRISTAL_EVENT.onDPMbStart)
end

function mb_map:update()
	super.update(self)
	if self.back then
		local player = Game.world.player
		local mb_ev = Game.world:getEvent(10)
		mb_ev.x = Utils.approach(mb_ev.x, player.x-mb_ev.width/2, self.stepback*DTMULT)
		mb_ev.y = Utils.approach(mb_ev.y, player.y-mb_ev.height*2, self.stepback*DTMULT)
		local limit = not Game.party[1]:checkArmor("pizza_toque")
		self.stepback = Utils.clamp(self.stepback + 0.1*DTMULT, 0.01, limit and 12 or math.huge)
		if player:collidesWith(mb_ev) then
			Game:setFlag("s", true)
			Game:setPartyMembers(Utils.unpack(self.old_party))
			player:remove()
			self.back = false
			Game.world:closeMenu()
			for key,_ in pairs(Assets.sound_instances) do
				Assets.stopSound(key, true)
			end
			Game.lock_movement = true
			local c = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			c:setLayer(WORLD_LAYERS["above_bullets"])
			c:setParallax(0, 0)
			c:setColor(0, 0, 0)
			Game.world:addChild(c)
			Game.world.timer:after(10+1/120, function()
				Game.world.music:play("TAEFED", 0)
				Game:setFlag("mb_partySet", nil)
				for i,v in ipairs(Game.stage:getObjects(Character)) do
					v:remove()
				end
				Game.world.timer:tween(10, Game.world.music, {volume=1}, "in-cubic", function()
					local t = Text("You lost, Kris.", 200, 200, 300, 200)
					t:setLayer(WORLD_LAYERS["textbox"])
					t:setParallax(0, 0)
					Game.world:addChild(t)

					Game.world.timer:after(1/60, function()
						t:remove()
						Game.world.fader.alpha = 0
						Game.world.camera.keep_in_bounds = true
						Game.lock_movement = self.movement_was_locked
						if type(Kristal.mb_marker_dest) == "table" then
							Game.world:loadMap(Kristal.mb_map_dest, Kristal.mb_marker_dest[1], Kristal.mb_marker_dest[2], Kristal.mb_facing_dest, Kristal.mb_callback_dest)
						else
							Game.world:loadMap(Kristal.mb_map_dest, Kristal.mb_marker_dest, Kristal.mb_facing_dest, Kristal.mb_callback_dest)
						end
					end)
				end)
			end)
		end
	else
		if not Game:getFlag("mb_finish") then
			self.limit_timer = self.limit_timer - DTMULT
			if self.limit_timer <= 0 then
				self:casuallyApproachChild()
			end
		end
	end
end

function mb_map:onExit()
	if Game:getFlag("mb_partySet", nil) then
		Game:setPartyMembers(Utils.dump(self.old_party))
		for i,follower in ipairs(Game.world.followers) do
	    	follower.visible = true
	    end
		Game:setFlag("mb_partySet", nil)
	end
	Game.world.camera.keep_in_bounds = true
	Game.lock_movement = self.movement_was_locked
	Kristal.callEvent(KRISTAL_EVENT.onDPMbEnd)
end

function mb_map:casuallyApproachChild()
	if not Game:getFlag("mb_finish", false) then
		Game:setFlag("mb_finish", true)
	end
	self.back = true
	for i=#self.collision, 1, -1 do
		table.remove(self.collision, i)
	end
	local mb = Game.world:getEvent(10)
	mb:setHitbox(0, 0, mb.width, mb.height)
	Game.world.camera.keep_in_bounds = false
end

return mb_map