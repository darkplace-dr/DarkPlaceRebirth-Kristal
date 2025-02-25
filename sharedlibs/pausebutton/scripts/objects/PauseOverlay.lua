---@class PauseOverlay : Object
---@overload fun():PauseOverlay
local PauseOverlay, super = Class(Object)

function PauseOverlay:init()
    super.init(self)
    self.text = Text("Game Paused. Press "..Input.getText("pause", nil, nil, true).."to resume.", 0,0,nil,nil, {auto_size = true})
    self.text:setPosition(SCREEN_WIDTH/2,SCREEN_HEIGHT)
    self.text:setOrigin(.5,1)
    self.text:addFX(AlphaFX(.5))
    self:addChild(self.text)
end

function PauseOverlay:onKeyPressed(key)
    if Input.is("pause", key) then
        if self.transitionOut then
            self:transitionOut()
        else
            self:close()
        end
    end
end

function PauseOverlay:close()
    PauseLib:setPaused(false)
    self:remove()
end

return PauseOverlay