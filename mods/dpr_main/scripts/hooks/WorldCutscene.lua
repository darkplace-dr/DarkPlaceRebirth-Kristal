---@class WorldCutscene : WorldCutscene
local WorldCutscene, super = Utils.hookScript(WorldCutscene)

local function waitForTVTime(self) return not self.tvtimetext or self.tvtimetext.done == true end
function WorldCutscene:itsTVTime(options)
    self:closeText()

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end

    self.tvtimetext = TennaTVTimeText(56, 344, width, height, false, options)
    self.tvtimetext.layer = WORLD_LAYERS["textbox"]
    self.world:addChild(self.tvtimetext)
    self.tvtimetext:setParallax(0, 0)

    options = options or {}
    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = self.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
        local bx, by = self.tvtimetext:getBorder()
        self.tvtimetext.y = by + 2
    end

    self.tvtimetext.active = true
    self.tvtimetext.visible = true

    if options["wait"] or options["wait"] == nil then
        return self:wait(waitForTVTime)
    else
        return waitForTVTime, self.tvtimetext
    end
end

return WorldCutscene