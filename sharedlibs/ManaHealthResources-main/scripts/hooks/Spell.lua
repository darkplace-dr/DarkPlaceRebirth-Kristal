---@class Spell : Class
---@field mana_cost integer                 The MP cost of the spell.
---@field health_cost integer               The HP cost of a spell.
local Spell, super = HookSystem.hookScript(Spell)

function Spell:init()

    super.init(self)

    --self.default_resource = "tension"

    self.mana_cost = 0
    self.health_cost = 0

end

--- *(Override)* Gets the mana cost of the spell.
---@param chara PartyMember The `PartyMember` the check is being run for
function Spell:getMPCost(chara) return self.mana_cost end

--- *(Override)* Gets the health cost of the spell.
---@param chara PartyMember The `PartyMember` the check is being run for
function Spell:getHPCost(chara) return self.health_cost end

--- *(Override)* Gets the spell resource type that the party member uses for the spell.
---@param chara PartyMember The `PartyMember` the check is being run for
function Spell:getResourceType(chara) return chara:getDefaultSpellResourceType() end

return Spell