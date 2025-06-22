local board, super = Class(Map)

function board:load()
    super.load(self)
end

function board:onExit()
    super.onExit(self)
end

return board