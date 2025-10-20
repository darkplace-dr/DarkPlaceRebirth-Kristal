local wave, super = Class(Wave)

function wave:onStart()
    
end

function wave:update()
    -- Code here gets called every frame

    super.update(self)
end

return wave