---@class Map.hell_3c : Map
local map, super = Class(Map, "hell_3c")

function map:init(world, data)
    super.init(self, world, data)
end

function map:onEnter()
    self.world.color = COLORS.black
    for _, a in ipairs(Game.party) do
    local actr = a:getActor()
    if actr.id == "noel" then return end
    Game.world:getCharacter(actr.id).sprite:addFX(OutlineFX(actr.color))
end
end

function map:onExit()
    self.world.color = COLORS.white
end

---@param char Player
function map:onFootstep(char, num)
    if not char.is_player then return end
    Assets.playSound("step"..num)
    ---@type RippleEffect
    local effect = RippleEffect(char, {Game.party[1]:getColor()})
    local x, y = char:getRelativePos(18/2, 72/2)
    -- TODO: I couldn't find the right numbers
    if Input.down("cancel") then
        RippleEffect:MakeRipple(x,y, 60, nil, 192, 1, 15):applySpeedFrom(char, 0.75)
    else
        RippleEffect:MakeRipple(x,y, 30, nil, 192/2, 1, 8):applySpeedFrom(char, 0.75)
        RippleEffect:MakeRipple(x,y, 30, nil, 192/3, 1, 8):applySpeedFrom(char, 0.75)
    end
end

return map