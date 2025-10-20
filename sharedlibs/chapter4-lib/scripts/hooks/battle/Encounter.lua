---@class Encounter : Encounter
local Encounter, super = Utils.hookScript(Encounter)

local old_prop_name = "reduced_tp"

function Encounter:hasReducedTension()
    -- For compatibility with reduced_tp property. You should still change it but you technically don't have to.
    if self[old_prop_name] ~= nil then
        Kristal.Console:warn("Encounter \""..(self.id or "nil").."\" uses old reduced_tp field! Please change \n[color:yellow]          it to reduced_tension.")
        self.reduced_tension = self[old_prop_name] or false
        -- Whine once
        self[old_prop_name] = nil
    end
    return super.hasReducedTension(self)
end

return Encounter