---@class Item : Class
---@field bonuses {attack: number, defense: number, health: number, magic: number, graze_time: number, graze_size: number, graze_tp: number, mana: number}
---@overload fun(...) : Item
local Item, super = HookSystem.hookScript(Item)

--- *(Override)* Applies bonus mana regen to regen actions performed by a party member in battle
---@param current_regen number   The current mana regen amount with other bonuses applied
---@param base_regen number      The original mana regen amount
---@param regener PartyMember    The character performing the regen
---@return number new_heal      The new mana regen amount affected by this item
function Item:applyManaRegenBonus(current_regen, base_regen, regener)
    return current_regen
end

return Item