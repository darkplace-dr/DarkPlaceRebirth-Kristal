local Stage, super = Class(Stage)

function Stage:update()
    if self == Game.stage and PauseLib.paused then return end
    super.update(self)
end

return Stage