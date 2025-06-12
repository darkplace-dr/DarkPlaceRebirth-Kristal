local lib = {}

function lib:init()
    Utils.merge(MUSIC_VOLUMES, {
        ch4_battle = 0.7
    })
end

---@param name PaletteIndex
function lib:getPaletteColor(name)
    if Game.battle and Game.battle.encounter and Game.battle.encounter.reduced_tp then
        if name == "tension_fill" then
            return Utils.hexToRgb("#0040c0")
        elseif name == "tension_max" then
            return Utils.hexToRgb("#0060a0")
        elseif name == "tension_decrease" then
            return {0,0,1}
        elseif name == "tension_back" then
            return Utils.hexToRgb("#000080")
        end
    end
    -- Assets.stopAndPlaySound("alert")
end

---@param battler PartyBattler
---@param button ActionButton
function lib:onActionSelect(battler, button)
    if Game.battle.encounter.reduced_tp then
        if button.type == "defend" then
            Game.battle:pushAction("DEFEND", nil, {tp = -2})
            return true
        end
    end
end

return lib