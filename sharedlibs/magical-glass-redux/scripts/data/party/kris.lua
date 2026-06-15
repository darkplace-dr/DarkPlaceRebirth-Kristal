local character, super = Class("kris", true)

function character:init()
    super.init(self)
    
    -- Character flags (saved to the save file)
    self.flags["lw_battle_knife"] = false
    -- Whether the soul will be upside-down or not (optional)
    self.monster_soul = false
end

return character