local TeevieQuizSolid, super = Class(Event)

function TeevieQuizSolid:init(data)
    super.init(self, data)

    self:setHitbox(0, 0, 40, 40)
    self.solid = false
end

return TeevieQuizSolid