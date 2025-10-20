local froggitbullet_1, super = Class(Bullet)

function froggitbullet_1:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/snowflake")
    self.sprite:play(0.2, true)
    self:setScale(1)
    self.color = {0.9, 0.5, 0.9}
	self.timer = 30
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.destroy_on_hit = false
    self.m4 = 0
    --self.rotation = dir
    self.remove_offscreen = false
end

function froggitbullet_1:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.timer = self.timer - (DT*60)
    if self.timer <= 0 and self.m4 == 0  then
        Assets.playSound("icespell")
        self.physics.speed = 18
        self.m4 = 1
        --self.m1 = 0
        --self.m2 = 0
        --self.m3 = 0
    end
    super.update(self)
end

return froggitbullet_1