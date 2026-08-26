---@class Jam26DDelta_KikkyFader: Fader
local Jam26DDelta_KikkyFader, super = Class(Fader, "Jam26DDelta_KikkyFader")

function Jam26DDelta_KikkyFader:init()
    super.init(self)
	self.timer = 0
    self.default_speed = 1
    self.speed = 3
	self.tilescovered = 0
	self.width = 24
	self.height = 16
	self.tile = {}
	for i = 0, self.width-1 do
		self.tile[i+1] = {}
		for j = 0, self.height-1 do
			self.tile[i+1][j+1] = 0
		end
	end
	self.type = 0
	self.prefill = 0	
	self.s_curcol = COLORS.black
end

function Jam26DDelta_KikkyFader:preFill()
	for i = 1, self.width do
		for j = 1, self.height do
			self.tile[i][j] = 1
		end
	end
end

function Jam26DDelta_KikkyFader:transition(middle_callback, end_callback, pausetime, options)
    options = options or {}
	pausetime = pausetime or 15
	if Game.world.kikky_world.type == 1 then
		self.s_curcol = Game.world.kikky_world.screencolor
	end
    self:fadeOut(function()
        if middle_callback then
            middle_callback()
        end
        options.alpha = nil
        options.music = nil
		Game.world.timer:after(pausetime/30, function()
			self:fadeIn(end_callback, options)
		end)
    end, options)
end

function Jam26DDelta_KikkyFader:update()
    if self.state == "FADEOUT" then
		self.timer = self.timer + DTMULT
		if Game.world.kikky_world.type == 1 then
			local amt = ColorUtils.mergeColor(self.s_curcol, COLORS.black, (self.tilescovered + 1) / 8)
			Game.world.kikky_world.screencolor = amt
		end
		for i = 0, self.width-1 do
			self.tile[math.min(i, self.width-1)+1][math.min(self.tilescovered, self.height-1)+1] = 1
			self.tile[math.min(i, self.width-1)+1][math.min((self.height - 1) - self.tilescovered, self.height-1)+1] = 1
			self.tile[math.min(self.tilescovered, self.width-1)+1][math.min(i, self.height-1)+1] = 1
			self.tile[math.min((self.width - 1) - self.tilescovered, self.width-1)+1][math.min(i, self.height-1)+1] = 1
		end
        if (self.timer >= self.speed) then
			self.timer = 0
			self.tilescovered = self.tilescovered + 1
		end
		if self.tilescovered >= 8 then
            self.state = "NONE"
			self.timer = 0
			self.tilescovered = 8
            if self.callback_function then
                self.callback_function()
            end
            self.callback_function = nil
        end
    end
    if self.state == "FADEIN" then
		self.timer = self.timer + DTMULT
		if Game.world.kikky_world.type == 1 then
			local mynewcolor = nil
			local amt = self.tilescovered / 8
			for _,screencol in ipairs(Game.world.kikky_world:getEvents("screencolorchanger")) do
				local cola, rowa = Game.world.kikky_world.area_column, Game.world.kikky_world.area_row
				local colb, rowb = Game.world.kikky_world:getArea(screencol.x, screencol.y)
				if cola == colb and rowa == rowb then
					mynewcolor = screencol
				end
			end
			if mynewcolor then
				Game.world.kikky_world.screencolor = ColorUtils.mergeColor(mynewcolor.color, COLORS.black, amt)
			end
		end
        if (self.timer >= self.speed) then
			self.timer = 0
			self.tilescovered = self.tilescovered - 1
		end
		for i = math.floor(self.width/2), (self.tilescovered * 2), -1 do
			for j = math.floor(self.height/2), self.tilescovered, -1 do
				self.tile[math.min(i, self.width-1)+1][math.min(j, self.height-1)+1] = 0
				self.tile[math.min(i, self.width-1)+1][math.min((self.height - 1) - j, self.height-1)+1] = 0
				self.tile[math.min((self.width - 1) - i, self.width-1)+1][math.min(j, self.height-1)+1] = 0
				self.tile[math.min((self.width - 1) - i, self.width-1)+1][math.min((self.height - 1) - j, self.height-1)+1] = 0
			end
		end
		if self.tilescovered <= 0 then
            self.state = "NONE"
			self.timer = 0
			self.tilescovered = 0
            if self.callback_function then
                self.callback_function()
				self.callback_function = nil
            end
        end
    end
    if self.state == "NONE" then
        self:setColor(0, 0, 0)
        self.fade_color = self.color
    end
end

function Jam26DDelta_KikkyFader:draw()
    Draw.setColor(self.color, 1)
	for i = 0, self.width-1 do
		for j = 0, self.height-1 do
			if self.tile[i+1][j+1] == 1 then
				love.graphics.rectangle("fill", i * 16, j * 16, 16, 16)
			end
		end
	end
end

return Jam26DDelta_KikkyFader