---@type table<string,fun(cutscene:WorldCutscene, ...)>
local enterdark = {}

function enterdark.shelter(cutscene)

    cutscene:text("* (Enter the Dark World?)")
    if cutscene:choicer({"Yes", "No"}) == 2 then return end

    Game.world:getEvents("sheltersound")[1]:remove()

    local player = Game.world.player

    cutscene:detachCamera()
    cutscene:detachFollowers()

    local party = {Game.world.player}
    for _, follower in ipairs(Game.world.followers) do
        table.insert(party,follower)
    end
    for index, value in ipairs(party) do
        -- This orders party members from left to right, but the leader should be in the center with a full team of 3.
        local xpos
        if #party == 3 and index <3 then xpos = (index == 2 and 1 or 2)
        else xpos = index end
        cutscene:slideTo(value,  320 + (60 * (xpos-(#party/2)) - 30) , 2356, 0.25)
    end
    -- cutscene:slideTo(susie, 620 + 30, 280, 0.25)
    cutscene:panTo(620, 2240, 0.25)
    cutscene:wait(0.25)
    
    local transition = LoadingDarkTransition(-500, {
        movement_table = ({
            {  0.00 },
            {  0.50, -0.50 },
            {  0.00, 0.00,  0.00 },
            {  1.00,  0.00, -1.00,  0.00 },
        })[#party]
    })
    transition.loading_callback = function(transition)
        -- Game.world:loadMap("light/hometown/apartments")
        DTRANS = transition.character_data
        Game:swapIntoMod("dpr_main", false, "floor1/main")
        if Game.world.music then
            Game.world.music:stop()
        end
        for _,party in ipairs(Game.party) do
            local char = Game.world:getCharacter(party.id) or Game.world:getCharacter(party.lw_actor.id)
            if char then
                char.visible = false
            end
        end
    end
    transition.layer = 99999
    -- Numbers gotten from CTRL+o mouse pos indicator
    transition.rx1 = 240/2
    transition.ry1 = 214/2
    transition.rx2 = 398/2
    transition.ry2 = 330/2

    Game.world:addChild(transition)
    for _, value in ipairs(party) do
        value.visible = false
    end
    local waiting = true
    local endData = nil
    transition.end_callback = function(transition, data)
        waiting = false
        endData = data
    end

    cutscene:wait(function() return not waiting end)
    
    if not Game:hasPartyMember("ralsei") then
        Game:addPartyMember("ralsei")
    end

    for _, character in ipairs(endData) do
        local char = Game.world:getPartyCharacterInParty(character.party)
        local kx, ky = character.sprite_1:localToScreenPos(character.sprite_1.width / 2, 0)
        if char then
            char:setScreenPos(kx, transition.final_y)
            char.visible = true
            char:setFacing("down")
        end
    end

    cutscene:interpolateFollowers()

    cutscene:attachCamera()
    cutscene:attachFollowers()
end

return enterdark