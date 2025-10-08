local FleeButton, super = Class(ActionButton)

function FleeButton:init()
    super.init(self, "flee")
    
end

function FleeButton:update()
    self.disabled = not Game.battle.encounter.can_flee
end

return FleeButton