---@class ActorSprite : ActorSprite
local ActorSprite, super = Utils.hookScript(ActorSprite)

function ActorSprite:init(actor)
    super.init(self, actor)

    self.run_away_2 = false
    self.run_away_timer_2 = 0

    if Game:getFlag("SHINY", {})[self.actor:getShinyID()] and Game:getFlag("SHINY", {})[self.actor:getShinyID()] == true and not Game.world.map.dont_load_shiny then
        self:setPaletteFX(0)
    end
end

function ActorSprite:setPaletteFX(line, imagedata)
    if not (imagedata or line) then
        self:removeFX(self.palettefx)
    elseif not self.palettefx then
        ---@type PaletteFX
        self.palettefx = PaletteFX(imagedata or self.actor, line, nil, 1)
        self:addFX(self.palettefx)
    else
        self.palettefx:setPalette(imagedata or self.actor, line)
    end
end

return ActorSprite