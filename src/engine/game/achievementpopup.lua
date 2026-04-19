local AchievementPopUp, super = Class(Object)

function AchievementPopUp:init(achievement)
    super.init(self, SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	
	self.achievement = achievement
	
    if type(self.achievement.border) == "userdata" or type(self.achievement.border) == "table" then
        self.raritysprite = Sprite(self.achievement.border, 0, 0)
    elseif self.achievement.border then
        self.raritysprite = Sprite("achievements/frames/"..self.achievement.border, 0, 0)
    else
        self.raritysprite = Sprite("", 0, 0)
    end
    if type(self.achievement.icon) == "userdata" or type(self.achievement.icon) == "table" then
        self.iconsprite = Sprite(self.achievement.icon, 8, 8)
    elseif self.achievement.icon then
        self.iconsprite = Sprite("achievements/"..self.achievement.icon, 8, 8)
    else
        self.iconsprite = Sprite("", 8, 8)
    end
	self.raritysprite:setScale(2,2)
	self.iconsprite:setScale(2,2)
	self:addChild(self.raritysprite)
	self:addChild(self.iconsprite)
	
	self.phase = 1
	self.timer = 0
	
	Assets.playSound("achievement")
end

function AchievementPopUp:update()
	super.update(self)
	
	if self.phase == 1 then
		self.x = self.x - (4 * DTMULT)
		if self.x < SCREEN_WIDTH - 80 then
			self.x = SCREEN_WIDTH - 80
			self.phase = 2
		end
	elseif self.phase == 2 then
		self.timer = self.timer + DT
		if self.timer >= 4 then
			self.phase = 3
		end
	else
		self.x = self.x + (4 * DTMULT)
		if self.x > SCREEN_WIDTH then
			self:remove()
		end
	end
end

return AchievementPopUp
