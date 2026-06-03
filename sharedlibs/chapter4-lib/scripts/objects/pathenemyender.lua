local PathEnemyEnder, super = Class(Event, "PathEnemyEnder")

function PathEnemyEnder:init(data)
    super.init(self, data)
	self.pathender = true
end

function PathEnemyEnder:getDebugRectangle()
    return {-5, -5, 10, 10}
end

return PathEnemyEnder