local Room1, super = Class(Map)

function Room1:load()
    super.load(self)
end

function Room1:onEnter()
    super.onEnter(self)
    local cityscape_bg = Sprite("world/maps/cyber/bg_cityscape", 0, 80)
    cityscape_bg:setParallax(0.7, 0)
    cityscape_bg.wrap_texture_x = true
    Game.world:addChild(cityscape_bg)
    cityscape_bg:setLayer(Game.world:parseLayer("objects_bg"))
	self.fireworks_timer = 0
	self.room_width = (Game.world.map.width * Game.world.map.tile_width)
	self.room_height = (Game.world.map.height * Game.world.map.tile_height)
	self.has_firework_shadows = true
	self.fw_shadows_active = false
	self.fw_shadows_alpha = 0
	self.fw_shadows_timer = 0
	self:getTileLayer("tiles"):addFX(ColorMaskFX({0,0,0}, 0), "shadow")
	self:getTileLayer("tiles2"):addFX(ColorMaskFX({0,0,0}, 0), "shadow")
	self:getTileLayer("tiles3"):addFX(ColorMaskFX({0,0,0}, 0), "shadow")
	self:getTileLayer("tiles4"):addFX(ColorMaskFX({0,0,0}, 0), "shadow")
	self.can_kill = Game:getFlag("can_kill", false)
end

function Room1:update()
    super.update(self)
	if self.can_kill then return end
	self.fireworks_timer = self.fireworks_timer + DTMULT
	if self.fireworks_timer >= 60 and Game.world.player.x >= 640 and Game.world.player.x <= 2560 then
		local xpos = Game.world.player.x - 240 + MathUtils.random(480)
		local ypos = self.room_height * 0.5
		local shape = {"default"}
		local actor = Game.world.player.actor
		if actor then shape = {actor.id} end
		for _, party in ipairs(Game.world.followers) do
			local actor = party.actor
			if actor and actor.id then
				table.insert(shape, actor.id)
			end
		end
		for _, party in ipairs(Game.party) do
			local assist = party:getAssistID() or nil
			if assist then
				table.insert(shape, assist)
			end
		end
		local firework = Firework(xpos, ypos, "world/firework/shape_"..TableUtils.pick(shape), TableUtils.pick({0,2,1})) -- why not .random???
		firework.layer = Game.world:parseLayer("objects_bg")+1
		Game.world:addChild(firework)
		self.fireworks_timer = 0
	end
    for _,chara in ipairs(Game.world.stage:getObjects(Character)) do
        if not chara.no_shadow and not chara:getFX("shadow") then
            chara:addFX(ShadowFX(), "shadow")
        end
    end
	if self.fw_shadows_active == true then
		self.fw_shadows_timer = self.fw_shadows_timer + DTMULT
		if self.fw_shadows_timer >= 25 then
			if self.fw_shadows_alpha <= 0 then
				self.fw_shadows_alpha = 0
				self.fw_shadows_timer = 0
				self.fw_shadows_active = false
			else
				self.fw_shadows_alpha = MathUtils.lerp(0.6, 0, (self.fw_shadows_timer-25)/15)
			end
		else
			if self.fw_shadows_alpha >= 0.6 then
				self.fw_shadows_alpha = 0.6
			else
				self.fw_shadows_alpha = MathUtils.lerp(0, 0.6, self.fw_shadows_timer/5)
			end
		end
		self:getTileLayer("tiles"):getFX("shadow").amount = self.fw_shadows_alpha
		self:getTileLayer("tiles2"):getFX("shadow").amount = self.fw_shadows_alpha
		self:getTileLayer("tiles3"):getFX("shadow").amount = self.fw_shadows_alpha
		self:getTileLayer("tiles4"):getFX("shadow").amount = self.fw_shadows_alpha
	end
    for _,chara in ipairs(Game.world.stage:getObjects(Character)) do
        if not chara.no_shadow and not chara:getFX("shadow") then
            chara:addFX(ShadowFX(), "shadow")
        else
			if chara:getFX("shadow") then
				chara:getFX("shadow").alpha = self.fw_shadows_alpha
			end
		end
    end
end

function Room1:onExit()
    super.onExit(self)
end

return Room1