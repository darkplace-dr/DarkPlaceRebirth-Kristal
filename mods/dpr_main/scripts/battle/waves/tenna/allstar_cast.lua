local AllStarCast, super = Class(Wave)

function AllStarCast:init()
    super.init(self)

    self.time = 200/30
    self.made = false
	
    self.difficulty = 0
end

function AllStarCast:onStart()
    local arena = Game.battle.arena
	
    local allstars = self:spawnObject(AllStarsManager(arena.x, 0))
    allstars.difficulty = self.difficulty
    allstars.damage = 65
	
    --local allstar_test = self:spawnBullet("tenna/allstars_bullet", arena.x + 100, arena.y)
    --allstar_test.size = 1
end

return AllStarCast