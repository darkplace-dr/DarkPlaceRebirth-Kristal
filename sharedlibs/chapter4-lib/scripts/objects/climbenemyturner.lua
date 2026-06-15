local ClimbEnemyTurner, super = Class(Event, "ClimbEnemyTurner")

function ClimbEnemyTurner:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.dir = properties["dir"] or 0
    self.chance = properties["chance"] or 1
	self.pathturner = true
end

return ClimbEnemyTurner