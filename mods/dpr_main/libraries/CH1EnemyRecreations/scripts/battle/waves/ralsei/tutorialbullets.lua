local TutorialBullets, super = Class(Wave)

function TutorialBullets:init()
	super.init(self)

    self.time = 130/30
end

function TutorialBullets:onStart()
    self:spawnBullet("ralsei/tutorialbullet", Game.battle.soul.x + 150, Game.battle.soul.y)

    self.timer:after(35/30, function()
        self:spawnBullet("ralsei/tutorialbullet", Game.battle.soul.x - 150, Game.battle.soul.y)
        
        self.timer:after(35/30, function()
            self:spawnBullet("ralsei/tutorialbullet", Game.battle.soul.x, Game.battle.soul.y - 150)
        end)
    end)
end

return TutorialBullets