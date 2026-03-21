local PathEnemyTurner, super = Class(Event, "PathEnemyTurner")

function PathEnemyTurner:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.dir = properties["dir"] or 0
    self.chance = properties["chance"] or 1
	self.pathturner = true
end

function PathEnemyTurner:getDebugRectangle()
    return {-5, -5, 10, 10}
end

return PathEnemyTurner