---@class LightBattleUI : LightBattleUI
---@field action_displays Object[]
local LightBattleUI, super = Class("LightBattleUI", true)

local DESELECTED_Y = 410
local SELECTED_Y = 425

function LightBattleUI:setupActionDisplays()
    if #Game.party <= 1 and Kristal.getLibConfig("mg2party", "useUndertaleWhenAlone") then return super.setupActionDisplays(self) end
    local status_x, status_y = (SCREEN_WIDTH / 2) - 0.5, DESELECTED_Y
    local box_gap = 10

    local total_spacing = 0
    for index, value in ipairs(Game.battle.party) do
        local status = LightSmallStatusDisplay(status_x, status_y, value, (564.5/3)-(box_gap/2))
        total_spacing = status.width + box_gap
        status_x = status_x + box_gap + status.width
        self:addChild(status)
        table.insert(self.action_displays, status)
    end
    if #Game.battle.party > 1 then
        for index, value in ipairs(self.action_displays) do
            value.x = value.x - (total_spacing / (4 - #Game.battle.party))
        end
    end
end

function LightBattleUI:update()
    super.update(self)
    self.layer = 40
end

function LightBattleUI:setupActionSelect(member, activate)
    super.setupActionSelect(self, member, activate)
    if #Game.party <= 1 and Kristal.getLibConfig("mg2party", "useUndertaleWhenAlone") then return end
    for index, display in ipairs(self.action_displays) do
        if Game.battle.state == "ACTIONSELECT" and Game.battle.party[index] == member then
            display.selected = true
            display:setLayer(1)
            display:slideTo(display.x, SELECTED_Y, 0.1, "in-out-quad")
        else
            display.selected = false
            display:setLayer(-1)
            display:slideTo(display.x, DESELECTED_Y, 0.1, "in-out-quad")
        end
    end
end

return LightBattleUI
