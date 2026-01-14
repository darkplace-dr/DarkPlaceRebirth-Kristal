local BeanSpot, super = Class(Event, "beanspot")

function BeanSpot:init(data)
    super.init(self, data)

	self.name = data.properties["name"]
	self.flag_inc = data.properties["inc_flag"]
	self.color = TiledUtils.parseColorProperty(data.properties["color"]) or ColorUtils.hexToRGB("#212136FF")
	self.bean_color = data.properties["bean_col"] and TiledUtils.parseColorProperty(data.properties["bean_col"]) or COLORS.white
	self.bean_star_color = data.properties["bean_starcol"] and TiledUtils.parseColorProperty(data.properties["bean_starcol"]) or self.bean_color
	self.bean_sprite = data.properties["bean_spr"] or "world/events/beans/bean"

    self:setOrigin(0.5, 0.5)
    self:setSprite("world/events/bean_spot")
	self.sprite:setColor(self.color)
end

function BeanSpot:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Bean Type: " .. self.name .. " (" .. self.flag_inc .. ")")
    return info
end

function BeanSpot:onInteract(chara, dir)
	Game.world:startCutscene("shared_cutscenes.bean_spot", self, self.bean_color, self.bean_star_color, self.bean_sprite)
    return true
end

return BeanSpot