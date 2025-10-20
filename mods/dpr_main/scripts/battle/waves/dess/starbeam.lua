local Starbeam, super = Class(Wave)

function Starbeam:init()
    super.init(self)
    self.time = 8
    self:setArenaSize(160, 120)
end

function Starbeam:onStart()
    Assets.playSound("knight_drawpower", 3, 1.3)
    Assets.playSound("rocket_long", 1, 0.6)
    local dess = Game.battle:getEnemyBattler("dess")
    local orig_x, orig_y = dess.x, dess.y
    dess:setSprite("point")
    dess:slideTo(460, 220, 0.3)
    local starsummoner
    self.timer:after(1.5, function()
        starsummoner = self.timer:every(1/7, function()
            Assets.playSound("stardrop", 0.5, 0.5)
            local direction = love.math.random(135, 225)
            self:spawnBullet("smallbullet", 430, 180, math.rad(direction), 7)
        end)
    end)
    self.timer:after(5, function()
        self.timer:cancel(starsummoner)
        dess:setAnimation("idle")
        dess:slideTo(orig_x, orig_y, 0.3)
    end)
end

function Starbeam:update()

    super.update(self)
end

return Starbeam