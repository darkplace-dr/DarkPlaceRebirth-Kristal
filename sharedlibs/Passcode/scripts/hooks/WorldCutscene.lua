---@diagnostic disable: redundant-parameter
local WorldCutscene, super = Utils.hookScript(WorldCutscene)

local function waitForPasscode(self) return self.passcodebox.done, self.passcodebox:checkCorrect(), self.passcodebox:getSelectedCharacters() end
--- Creates a passcode input with rows to input choices
---@param rows  [table|string] A table of either tables containing different values for the row or strings for default row options. The string value can be `numbers`, `alphabet`, or `alphabet_upper`
---@param options? table A table defining additional properties to control the passcode input.
---|"top"                   # Override for the default textbox position, defining whether the passcode box should appear at the top of the screen.
---|"default_row"           # An integer determining the initital row to be selected. (Defaults to 1)
---|"spacing"               # The spacing between each rows. (Defaults to 16)
---|"color"                 # The main color to set for unselected. rows. (Defaults to `COLORS.white`)
---|"highlight"             # The color to highlight when the row is selected. (Defaults to `COLORS.white`)
---|"correct_color"         # The color to highlight when the passcode entered is correct. (Defaults to `COLORS.yellow`)
---|"incorrect_color"       # The color to highlight when the passcode entered is incorrect. (Defaults to `COLORS.red`)
---|"correct_func"          # A function to override the default check for correct input. Accepts a table containing the entered values.
---|"check_correct"         # Whether to do the check for correct input. (Defaults to `true`)
---|"wait"                  # Whether the cutscene should automatically suspend itself until the player confirms their input. (Defaults to `true`)
---@return boolean|function selected A boolean determining whether the input was correct if wait is `false`, otherwise a function.
---@return Passcodebox|table choicer A table containing the values entered if wait is `false`, otherwise the passcode object.
function WorldCutscene:passcode(rows, options)
    self:closeText()

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end

    self.passcodebox = Passcodebox(56, 344, width, height, options)
    self.passcodebox.layer = WORLD_LAYERS["textbox"]
    self.world:addChild(self.passcodebox)
    self.passcodebox:setParallax(0, 0)

    for _, row in ipairs(rows) do
        self.passcodebox:addRow(row)
    end

    options = options or {}
    if options["top"] == nil and self.textbox_top == nil then
        local _, player_y = self.world.player:localToScreenPos()
        options["top"] = player_y > 260
    end
    if options["top"] or (options["top"] == nil and self.textbox_top) then
        local bx, by = self.passcodebox:getBorder()
        self.passcodebox.y = by + 2
    end

    self.passcodebox.active = true
    self.passcodebox.visible = true

    if options["wait"] or options["wait"] == nil then
        return self:wait(waitForPasscode)
    else
        return waitForPasscode, self.passcodebox
    end
end

function WorldCutscene:closeText()
    super.closeText(self)

    if self.passcodebox then
        self.passcodebox:remove()
        self.passcodebox = nil
    end
end

return WorldCutscene