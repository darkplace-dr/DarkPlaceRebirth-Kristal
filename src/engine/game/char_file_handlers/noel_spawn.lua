local Noel = {}
local self = Noel

function Noel:checkNoel()
    local noelsave = Noel:loadNoel()
    local noel_char = Game.world:getCharacter("noel")
    local save_id
    if Game:getFlag("noel_SaveID") then
        save_id = Game:getFlag("noel_SaveID")
    else
        save_id = 0
    end

    if noelsave and noel_char and noelsave.SaveID ~= save_id then
        Game:removePartyMember("noel")
        Game.world:removeFollower("noel")
        local noel = Game.world:getCharacter("noel")
        if noel then noel:remove() end
        Noel:NoelEnter(noelsave)

    elseif not noelsave and noel_char then
        Game:removePartyMember("noel")
        Game.world:removeFollower("noel")
        local noel = Game.world:getCharacter("noel")
        if noel then noel:remove() end

    elseif noelsave and not Game:hasPartyMember("noel") then
        Noel:NoelEnter(noelsave)

    end
end

function Noel:test()
    print("bithc")
end

local place_holder = function(cutscene, event)
    --Game.world:getCharacter("noel").actor.default = "dess_mode/walk"

    local save = Noel:loadNoel()
    if #Game.party == 3 then 
        cutscene:text("* Party full.", "bruh", "noel")
    else
        cutscene:text("* May I join the party?", "bruh", "noel")
        local choicer
        if Game:isDessMode() then
            cutscene:text("* nah this is dess mode[font:main_mono,16]TM[font:reset] so it's only me", "condescending", "dess")
            choicer = 0 --to avoid all choicer dialouge
            if save.understand and save.understand.dessmode then
            else
                if save.met_dess and save.met_dess.met then
                    cutscene:text("* Uhm,[wait:10][face:...] what???", "oh", "noel")
                    cutscene:text("* Dess, I need some context here.", "neutral", "noel")
                    cutscene:text("* You can't just say [voice:dess]dess mode[font:main_mono,16]TM[font:reset][voice:noel] and expect me to understand.", "bruh", "noel")
                else
                    cutscene:text("* Wha-[wait:10][face:huh] what?", "oh", "noel")
                    cutscene:text("* What [wait:5][face:oh](or who)[face:bruh][wait:5] in the world is dess mode?", "...", "noel")
                    cutscene:text("* Do I even know you?", "...", "noel")
                end
            end
        else
            choicer = cutscene:choicer({"Yes", "No"})
        end
        if choicer == 1 then
            cutscene:text("* Cool beans.", "bruh", "noel")
            local noel = cutscene:getCharacter("noel")
            noel:convertToFollower()
            cutscene:attachFollowers()
            Game:setFlag("noel_SaveID", save["SaveID"])
            Game:addPartyMember("noel")
        elseif choicer == 2 then
            cutscene:text("* Alright.", "bruh", "noel")
        end
    end
end

local wake = function(cutscene, event)
            Game.world.music:fade(0, 0.25)
        cutscene:wait(0.25)

            local turncoat = Music("turncoat", 1, 1)

        --local index = love.window.showMessageBox("???", "* ...", {"    "}, "info")
        --local index = love.window.showMessageBox("???", "* Hello?", {"    "}, "info")
        --local index = love.window.showMessageBox("???", "* Is anyone there?", {"    "}, "info")
        --local index = love.window.showMessageBox("???", "* Can anyone hear me?", {"    "}, "warning")


        turncoat:stop()
        Game.world.music:fade(1, 0.5)

    --cutscene:text("* The wall seems cracked.", "bruh", "noel")
end

function Noel:NoelEnter(noelsave)
    local savedData = noelsave
    local map = Game.world.map.id
    local mod = Mod.info.id

        local spawnPositions = {
            warphub = {384, 361, {cutscene = place_holder, animation = "brella"}},
            room1 = {400, 740, {cutscene = place_holder, animation = "brella"}},
            main_hub = {460, 380, {cutscene = place_holder, animation = "brella"}},
            main_hub_south = {350, 160, {cutscene = place_holder, animation = "brella"}},
            ["steamworks/05"] = {260, 290, {cutscene = place_holder}},
            ["steamworks/09"] = {1000, 390, {cutscene = place_holder}},
            ["steamworks/15"] = {490, 510, {cutscene = place_holder}},
            ["steamworks/19"] = {460, 350, {cutscene = place_holder}},
            ["steamworks/23"] = {980, 220, {cutscene = place_holder}},
        }

    if map == savedData.Map and mod == savedData.Mod then
        local position = spawnPositions[savedData.Map] 
        if position then
            print(4)
            if position[3] then
                Noel:spawnNoel(position[1], position[2], position[3])
            else
                Noel:spawnNoel(position[1], position[2])
            end
        end
    end
end

function Noel:spawnNoel(x, y, data)
    if Game:hasPartyMember("noel") then
        Noel:checkNoel()
    else
        if data then
            Game.world:spawnNPC("noel", x, y, data)
        else
            Game.world:spawnNPC("noel", x, y, {cutscene = "noel.found_again"})
        end
    end
end


function Noel:saveNoel(new_data)
    local save_dir = "saves"
    local n_save = save_dir.."/null.char"

    local data = self:loadNoel() or {}
    if new_data then
        for k, v in pairs(new_data) do
            data[k] = v
        end
    end

    love.filesystem.createDirectory(save_dir)
    love.filesystem.write(n_save, JSON.encode(data))
end

function Noel:loadNoel()
    local save_dir = "saves"
    local n_save = save_dir.."/null.char"
    if love.filesystem.getInfo(n_save) then
        return JSON.decode(love.filesystem.read(n_save))
    end
    return nil
end

function Noel:findDifferenceIndex(text, text2)
    local minLen = math.min(#text, #text2)
    for i = 1, minLen do
        if text:sub(i, i) ~= text2:sub(i, i) then
            return i
        end
    end
    return minLen
end

function Noel:noels_annoyance(cutscene)
    if not Game:getFlag("noel's_annoyance") then
        Game:setFlag("noel's_annoyance", 1)
    elseif Game:getFlag("noel's_annoyance") == 5 then
        cutscene:showNametag("Noel")
        local thing = love.math.random(1, 2)
        if thing == 1 then
            cutscene:text("* OH,[wait:5] MY,[wait:5] GOD!!!", "madloud", "noel")
            cutscene:text("* This is the dumbest puzzle ever, I'm leaving!", "madloud", "noel")
        elseif thing == 2 then
            cutscene:text("* Looks like you're in a bit of a pickle [color:yellow]"..Game.save_name.."[color:white].", "bruh", "noel")
            cutscene:text("* Don't worry.[wait:8] [face:neutral]For 12[color:yellow] PlayCoins[font:small]TM[font:main][color:white]\nI could teleport you to the nearest [color:yellow]CHECKPOINT[color:white]!", "lookup", "noel")
        -- noel random saying "this stinks, im leaving", or "playcoins or sum shit"
        end
        cutscene:hideNametag()
    else
        Game:setFlag("noel's_annoyance", Game:getFlag("noel's_annoyance") + 1)
    end
end


--Didnt think it was good enough 
--[[
        Game.world:startCutscene(function (cutscene, event)
            Game.world.music:fade(0, 0.25)

            local turncoat = Music("turncoat", 1, 1)

            local index = love.window.showMessageBox("???", "* Don't panic!", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* The game didn't crash!", {"    "}, "info")

            local index = love.window.showMessageBox("???", "* This is a prewritten message...", {"    "}, "warning")

            local index = love.window.showMessageBox("???", "* If youre reading this.", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* I'm probably not awake yet.", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* And won't be for a while.", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* ...", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* What are you waiting for!!!", {"    "}, "warning")
            local index = love.window.showMessageBox("???", "* Wake me up already "..Game.save_name.."!!!", {"    "}, "warning")

            turncoat:stop()
            Game.world.music:fade(1, 0.5)
            --cutscene:text("* The wall seems cracked.", "bruh", "noel")
        end)
]]

return Noel