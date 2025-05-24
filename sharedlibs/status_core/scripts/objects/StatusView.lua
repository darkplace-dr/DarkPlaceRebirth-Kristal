local StatusView, super = Class(Object)

function StatusView:init()
    super.init(self, 92, 52, 457, 210)
	
	self.parallax_x = 0
    self.parallax_y = 0

    self.draw_children_below = 0

    self.font = Assets.getFont("main")
    self.statfont = Assets.getFont("main", 16)

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)
end

function StatusView:update()
	if Game.battle and Game.battle.party and Game.battle.party[Game.battle.current_selecting] and Input.down("menu") and (Game.battle.state == "ACTIONSELECT") then
		self.bg.alpha = 1
	else
		self.bg.alpha = 0
	end
    super.update(self)
end

function StatusView:draw()
	if Game.battle and Game.battle.party and Game.battle.party[Game.battle.current_selecting] and Input.down("menu") and (Game.battle.state == "ACTIONSELECT") then
		super.draw(self)
		love.graphics.setFont(self.font)
		love.graphics.printf(string.upper(Game.battle.party[Game.battle.current_selecting].chara.name), 0, 0, 457, "center")
		local y = 0
		love.graphics.setFont(self.statfont)
		for _, status in pairs(Game.battle.party[Game.battle.current_selecting].statuses) do
			if not status.statcon.hidden then
				local width, wrappedtext = self.statfont:getWrap( string.upper(status.statcon.name) .. " - " .. status.statcon.desc, 433 )
				love.graphics.printf(wrappedtext, 24, y + 40, 433)
				love.graphics.draw(Assets.getTexture(status.statcon.icon), 0, y + 40)
				
				y = y + 6 + math.max((#wrappedtext*16) + 8, 24)
			end
		end
	end
end

return StatusView