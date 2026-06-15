local ChurchLightTrigger, super = Class(Event)

function ChurchLightTrigger:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
	
    self.solid = false

    self.markers = TiledUtils.parsePropertyList("marker", properties)
    self.xpos = properties["lightx"] or self.x
    self.ypos = properties["lighty"] or self.y

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.once = properties["once"] ~= false
    self.temp = properties["temp"] or false
    self.fadeintime = properties["fadetime"] or 30
    self.lightsize = properties["size"] or 120
end

function ChurchLightTrigger:onLoad()
    super.onLoad(self)
    if self.once and not self.temp and self:getFlag("used_once", false) then
		if #self.markers > 0 then
			for i, marker in ipairs(self.markers) do
				local xx, yy = self.world.map:getMarker(marker)
				local light = Registry.createLegacyEvent("lightfollowing", {x = xx, y = yy})
				light.target = nil
				light.size = self.lightsize
				self.world:spawnObject(light)
			end
		else
			local light = Registry.createLegacyEvent("lightfollowing", {x = self.xpos, y = self.ypos})
			light.target = nil
			light.size = self.lightsize
			self.world:spawnObject(light)
		end
		self:remove()
    end
end

function ChurchLightTrigger:onEnter(chara)
    if chara.is_player then
		if #self.markers > 0 then
			for _, marker in ipairs(self.markers) do
				local xx, yy = self.world.map:getMarker(marker)
				local light = Registry.createLegacyEvent("lightfollowing", {x = xx, y = yy})
				light.target = nil
				light.size = self.lightsize
				self.world.timer:lerpVar(light, "size", 1, self.lightsize, self.fadeintime, -1, "out")
				self.world:spawnObject(light)
			end
		else
			local light = Registry.createLegacyEvent("lightfollowing", {x = self.xpos, y = self.ypos})
			light.target = nil
			light.size = self.lightsize
			self.world.timer:lerpVar(light, "size", 1, self.lightsize, self.fadeintime, -1, "out")
			self.world:spawnObject(light)
		end
		Assets.playSound("noise", 0.4, 0.6)
		Assets.playSound("spearappear", 0.7, 1.4)
        if self.set_flag then
            Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
        end
        if self.once then
            self:setFlag("used_once", true)
            self:remove()
        end
        return true
    end
end

function ChurchLightTrigger:draw()
    super.draw(self)
    if DEBUG_RENDER then
        self.collider:draw(0, 1, 1)
    end
end

return ChurchLightTrigger