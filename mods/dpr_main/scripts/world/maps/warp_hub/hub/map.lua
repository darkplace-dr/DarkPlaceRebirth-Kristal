local hub, super = Class(Map)

function hub:onEnter()
    super.onEnter(self)
end

local function convertToGameTime(real_seconds, sec_per_hour)
    local sec_per_minute = sec_per_hour / 60  -- Calculate how many real seconds per in-game minute

    local in_game_hours = real_seconds / sec_per_hour
    local in_game_days = math.floor(in_game_hours / 24)
    local remaining_hours = math.floor(in_game_hours % 24)

    -- Calculate remaining real-world seconds after extracting full hours
    local remaining_seconds = real_seconds % sec_per_hour
    local in_game_minutes = math.floor(remaining_seconds / sec_per_minute)

    return in_game_days, remaining_hours, in_game_minutes
end

function hub:draw()
    super.draw(self)
    Draw.setColor(1, 1, 1, 1)

    local time = Game.playtime

    time = math.floor(time)

    local days, hours, minutes = convertToGameTime(time, 60)

    local MM = "AM"

    if hours >= 12 then 
        MM = "PM"
    end

    local jim = ""
    if minutes < 10 then 
        jim = "0"
    end

    if hours > 12 then 
        hours = hours - 12
    elseif hours == 0 then
        hours = 12
    end
    local weed = days%7
    local day = { [0] = "SUNDAY", "MONDAY", "TUESDAY", "THURSDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"}
    weed = day[weed] or weed


    love.graphics.print(string.format(weed.. "\n%d : " ..jim.. "%d " ..MM, hours, minutes), 20, 20)
end


function hub:diamond_hole() -- this should be an event... but i really dont feel like making one right now
    local p = Game.world.player
    if p and p.x > 120 and p.x < 240 and p.y < 200 and p.y > 120 then
        local diamond = Game.world:getCharacter("diamond_giant")
        local option = diamond.sprite.sprite_options
        if option[2] == "hole_empty" then
            diamond:setAnimation("rise")
        end
    else
        local diamond = Game.world:getCharacter("diamond_giant")
        local option = diamond.sprite.sprite_options
        if option[1] == "hole_idle" then

            diamond:setAnimation("fall")
        end
    end
end

function hub:update()
    super.update(self)

    self:diamond_hole()
end

function hub:onFootstep(char, num)
    local brenda = Game.world:getCharacter("brenda")
    if (brenda and Game:getPartyMember("brenda").love >= 5)
        and (love.math.random(1, 1000) == 55 and not Game:getFlag("thoughts"))
    then
        Game.world:startCutscene("thoughts", "b")
    end
end

return hub