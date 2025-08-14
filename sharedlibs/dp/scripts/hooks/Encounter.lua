---@class Encounter : Encounter
local Encounter, super = Utils.hookScript(Encounter)

function Encounter:init()
    super.init(self)

    -- Can the player flee the battle?
    self.flee = true
    -- Chance out of 100 that the player can flee this battle (x/100)
    self.flee_chance = 60

    ---@type boolean
    -- Prevents the Dojo background from being added on Boss Rushes and Boss Refights
    self.no_dojo_bg = false
end

---@return "up"|"down"|"left"|"right"?
function Encounter:getSoulFacing() end

function Encounter:createSoul(x, y, color)
    if Game:isSpecialMode "BLUE" then
        return BlueSoul(x, y, color)
    else
        return super.createSoul(self,x, y, color)
    end
end

function Encounter:addEnemy(enemy, x, y, ...)
    local enemy_obj
    if type(enemy) == "string" then
        enemy_obj = Registry.createEnemy(enemy, ...)
    else
        enemy_obj = enemy
    end
    
    if enemy_obj.milestone and enemy_obj.experience > 0 then
        self.milestone = true
    end
    
    return super.addEnemy(self, enemy, x, y, ...)
end

return Encounter
