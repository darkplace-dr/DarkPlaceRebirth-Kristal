---@class Encounter : Encounter
local Encounter, super = Utils.hookScript(Encounter)

function Encounter:init()
    super.init(self)
    -- Reduces TP gained from defending, recolors the TensionBar, and I think that's actually it. Doesn't seem to affect FIGHTing in Deltarune?
    self.reduced_tp = false
end

return Encounter