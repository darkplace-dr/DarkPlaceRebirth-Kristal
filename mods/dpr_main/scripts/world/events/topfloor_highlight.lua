local TopFloorHighlightArea, super = Class(Event)

function TopFloorHighlightArea:init(data)
	super.init(self, data)

	local properties = data.properties or {}
    self.left_x = properties["leftx"] or self.width/2
    self.right_x = properties["rightx"] or self.width/2
    self.highlight = TiledUtils.parseColorProperty(properties["highlight"]) or ColorUtils.hexToRGB("#9F9FFFFF")
    self.darkcol = TiledUtils.parseColorProperty(properties["darkness"]) or ColorUtils.hexToRGB("#404040FF")
	self.actind = 0
end

function TopFloorHighlightArea:update()
	super.update(self)
    for _,chara in ipairs(self.stage:getObjects(Character)) do
		if not chara.no_shadow then
			local hfx = chara:getFX("highlight")
			if hfx then
				if chara.y >= self.y and chara.y <= self.y + self.height then
					if chara.x >= self.x and chara.x <= self.x + self.left_x then
						hfx.alpha = MathUtils.lerp(0, 1, (chara.x-self.x)/(self.left_x))
					elseif chara.x >= self.x + (self.width - self.right_x) and chara.x <= self.x + self.width then
						hfx.alpha = MathUtils.lerp(1, 0, (chara.x-(self.x+(self.width - self.right_x)))/(self.right_x))
					elseif chara.x >= self.x + self.left_x and chara.x <= self.x + (self.width - self.right_x) then
						hfx.alpha = 1
					end
				end
			else
				chara:addFX(ChurchHighlightFX(0, self.highlight, {darkcol = self.darkcol}, 1), "highlight")
			end
        end
    end
end

function TopFloorHighlightArea:onExit(chara)
    local hfx = chara:getFX("highlight")
    if hfx then
        hfx.alpha = 0
    end
end

return TopFloorHighlightArea