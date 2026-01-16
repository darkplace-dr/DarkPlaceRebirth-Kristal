local GreenBlobTest, super = Class(Wave)

function GreenBlobTest:init()
    super.init(self)

    self.time = 360/30
end

function GreenBlobTest:onStart()
    Game.battle:swapSoul(FlashlightSoul())

    self.timer:every(10/30, function()
        local soul = Game.battle.soul
        local tempdist = 100 + MathUtils.random(40)
        local tempdir = math.rad(30 + MathUtils.random(360))

        self:spawnBullet("titan/greenblob", soul.x + MathUtils.lengthDirX(tempdist, tempdir), soul.y + MathUtils.lengthDirY(tempdist, tempdir))
    end)
end

return GreenBlobTest