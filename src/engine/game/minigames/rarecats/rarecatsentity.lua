---@class RareCatsEntity : Object
local RareCatsEntity, super = Class(Object)

function RareCatsEntity:init(x, y, type)
    super.init(self, x, y, 100, 100)

    self.type = type or 1
	
    self:setHitbox(0, 0, 100, 100)

    self.sprite = Sprite("cat_001/dance", 0, 0, nil, nil, "minigames/rarecats")
    self.sprite:play(1/30, true)
    self.sprite:setScale(2)
    self.sprite:setScaleOrigin(0.5, 0.5)
    self.sprite.alpha = 4
    self:addChild(self.sprite)
	
    self.width = self.sprite.width
    self.height = self.sprite.height
	
    self.point_value = 0
    self.kill_cat = false
    self.played_sound = false
	
    self.timer = Timer()
    self:addChild(self.timer)
	
    self.minigame = Game.minigame
end

function RareCatsEntity:update()
    super.update(self)
	
	--bouncing across screen
    if self.x >= SCREEN_WIDTH - 50 then
        self.physics.speed_x = -30 / 10
    elseif self.x <= -25 then
        self.physics.speed_x = 30 / 10
    end
	
    if self.y <= -25 then
        self.physics.speed_y = 30 / 10
    elseif self.y >= SCREEN_HEIGHT - 100 then
        self.physics.speed_y = -30 / 10
    end
	
	--clicking stuff
    local mx, my = Input.getMousePosition()
    if (Input.mousePressed() and not clicked) and self.minigame.cats_clicked < 100 then
        if self:clicked() and not self.kill_cat then
            self.minigame.score = self.minigame.score + self.point_value
            self.minigame.cats_clicked = self.minigame.cats_clicked + 1
			
            self.physics.speed_x = 0
            self.physics.speed_y = 0
			
            self.kill_cat = true
			
            if not self.played_sound then
                if self.type == 1 then
                    Assets.playSound("magicsprinkle")
                    self.point_value = 10
                end
                if self.type == 2 then
                    Assets.playSound("magicsprinkle", 1, 0.95)
                    self.point_value = 50
                end
                if self.type == 5 then
                    Assets.playSound("cd_bagel/susie", 1, 1.3)
                    self.point_value = 250
                end
                if self.type == 6 then
                    Assets.playSound("magicsprinkle", 1, 0.5)
                    Assets.playSound("cd_bagel/ralsei_stereo")
                    self.point_value = 1000
                end
                if self.type == 7 then
                    Assets.playSound("magicsprinkle", 1, 0.25)
                    Assets.playSound("cd_bagel/ralsei_stereo", 1, 0.8)
                    self.point_value = 3000
                end
                self.played_sound = true
            end
			
            self.points_txt = Text("+"..self.point_value, self.width/2 - 12, 0)
            self.points_txt:setScale(0.5)
            self.points_txt.alpha = 0
            self.sprite:addChild(self.points_txt)
			
            if self.y < 160 then
                self.points_txt.y = self.height - 25
                self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y + 10, alpha = 1})
                self.timer:after(0.8, function()
                    self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y + 40, alpha = 0})
                end)
            else
                self.points_txt.y = 25
                self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y - 10, alpha = 1})
                self.timer:after(0.8, function()
                    self.timer:tween(0.4, self.points_txt, {y = self.points_txt.y - 40, alpha = 0})
                end)
            end
        end
    end
	
    if self.kill_cat then
        self.sprite.alpha = self.sprite.alpha - 0.1 * DTMULT
        if self.sprite.alpha <= 0 then
            self:remove()
            self.minigame.spawn_cat = false
            self.kill_cat = false
        end
    end
end

return RareCatsEntity