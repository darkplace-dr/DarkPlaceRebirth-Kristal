---@class PartyMember : Class
---
---@field stats {health: number, attack: number, defense: number, magic: number, mana: number}
---
---@field max_stats {health: number, attack: number, defense: number, magic: number, mana: number}
---
---@field lw_stats {health: number, attack: number, defense: number, mana: number}
---
---@field default_spell_resource string
---
---@field uses_mana boolean
---@field mana number
---@field lw_mana number
---
---@field mana_bar_color        table?
---@field mana_message_color    table?
---@field mana_sparkle_color    table?
local PartyMember, super = HookSystem.hookScript(PartyMember)

function PartyMember:init()

    super.init(self)

    -- Current mana (saved to the save file)
    self.mana = 0
    -- Current light world mana (saved to the save file)
    self.lw_mana = 0

    -- Mana stats set to 0 automatically if not set in `PartyMember.stats` / `PartyMember.lw_stats` on new save

    -- The default resource the party member uses for their spells. \
    -- Any subsequent spells the party member gets will have their default resource type set to this automatically.
    self.default_spell_resource = "tension"

    self.spell_used = nil                       --The spell that the party member (will) use[d] for the turn

    self.uses_mana = false                      --Whether the party member uses mana (defaults to false)

    self.mana_bar_color = nil                   --The color of the mana bar
    self.mana_message_color = nil               --The color of mana-related messages
    self.mana_sparkle_color = nil               --The color of the sparkle in mana-related messages

end

function PartyMember:usesMana() return self.uses_mana end
function PartyMember:getMana() return Game:isLight() and self.lw_mana or self.mana end
function PartyMember:getDefaultSpellResourceType() return self.default_spell_resource end

--------------------------Color Funcitons-------------------------------

function PartyMember:getManaBarColor()
    if self.mana_bar_color then
        return Utils.unpackColor(self.mana_bar_color)
    else
        return ManaHealthResources.PALETTE["mana_bar_fill"]
    end
end

function PartyMember:getManaMessageColor()
    if self.mana_message_color then
        return Utils.unpackColor(self.mana_message_color)
    else
        return ManaHealthResources.PALETTE["mana_msg"]
    end
end

function PartyMember:getManaSparkleColor()
    if self.mana_sparkle_color then
        return Utils.unpackColor(self.mana_sparkle_color)
    else
        return ManaHealthResources.PALETTE["mana_sparkle"]
    end
end

--------------------------Resource Functions-----------------------------

--- Sets the default spell resource type of the party member.
---@param resource string
function PartyMember:setDefaultSpellResourceType(resource)
    self.default_spell_resource = resource
end

--------------------------Mana Functions---------------------------------

--- Set this party member's mana user status
---@param status    boolean
function PartyMember:setManaUserStatus(status) self.uses_mana = status end

--- Regenerates mana for this party member
---@param amount        number
---@param playsound?    boolean
---@return boolean full_heal
function PartyMember:regenMana(amount, playsound)
    if playsound == nil or playsound then
        Assets.stopAndPlaySound("pmd2_pp_up", 0.6)
    end
    self:setMana(math.min(self:getStat("mana"), self:getMana() + amount))
    return self:getStat("mana") == self:getMana()
end

--  Simple mana removal function.
---@param amount number
function PartyMember:removeMana(amount)
    self:setMana(self:getMana() - amount)
end
--- Sets this party member's mana value
---@param mana number
function PartyMember:setMana(mana)
    if Game:isLight() then
        self.lw_mana = mana
    else
        self.mana = mana
    end
end


return PartyMember