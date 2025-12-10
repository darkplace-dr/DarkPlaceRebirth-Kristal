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

function Noel:isDess()
    if ((Game:isDessMode() and Noel:getFlag("can_be_dess")) or Noel:getFlag("identity_crisis")) then
        return true
    else
        return false
    end
end

function Noel:dessParty()
    if Noel:isDess() and Game:hasPartyMember("noel") then
        return true
    else
        return false
    end
end

local place_holder = function(cutscene, event)
    --Game.world:getCharacter("noel").actor.default = "dess_mode/walk"

    local save = Noel:loadNoel()

    local party_one = Game.party[1].name

    if not Game.party[2] then
        if party_one == "Dess" then --Oh didn't expect to see you here alone Dess, speaking of, where's the others?
            if Noel:getFlag("met_dess") then
                cutscene:text("* Oh didn't expect to see you here alone Dess,[wait:5] speaking of,[wait:5] why?", "bruh", "noel")

                if Game:isDessMode() then

                    cutscene:text("* Does it matter?", "condescending", "dess")
                    cutscene:text("* Right now, we're in dess mode[font:main_mono,16]TM[font:reset] so that means I get to be the coolest party member by default", "condescending", "dess")

                    cutscene:text("* Ignoring whatever that is,[wait:5] what brings you here?", "bruh", "noel")

                    local choicer = cutscene:choicer({"Join the party", "say nothing\nto confuse him"})

                    if choicer == 1 then

                        cutscene:text("* Honestly I was just zoning out so I have no idea how I even got here,", "condescending", "dess")
                        cutscene:text("* but since I'm here now, wanna join my super cool and exclusive party?", "condescending", "dess")

                        cutscene:text("* Normally, I would, but something tells me that this would be a bad idea...", "bruh", "noel")

                        cutscene:text("* You /srs? I'm not that bad to be around", "condescending", "dess")

                        cutscene:text("* I meant that the game", "bruh", "noel", {auto = true})
                        cutscene:text("[instant]* I meant that reality[stopinstant] probably wouldn't allow it.", "bruh", "noel")

                        cutscene:text("* Sounds like a skill issue to me, but you do you", "condescending", "dess")
                        Noel:setFlag("understand_dessmode", true)
                    else
                        cutscene:text("*", "smug", "dess")
                        cutscene:text("* [speed:0.1]...", "bruh", "noel")
                        cutscene:text("* You know I can read the choicer right?", "...", "noel")
                    end
                    return
                else

                    cutscene:text("* [color:yellow]Placeholder text for non dess mode dess only interactions.", "smug", "dess")
                    return
                end
            else
                cutscene:text("* I don't know you.", "bruh", "noel")
                return
            end
        end
    end

    if #Game.party == 3 then 
        cutscene:text("* Party full.", "bruh", "noel")
    else
        if math.random(1, 10) == 9 then
            cutscene:doki_text("* May I join the party?", "noel", {name = "Noel"})
        else
            cutscene:text("* May I join the party?", "bruh", "noel")
        end
        local choicer
        if Game:isDessMode() then
            cutscene:text("* nah this is dess mode[font:main_mono,16]TM[font:reset] so it's only me", "condescending", "dess")
            choicer = 0 --to avoid all choicer dialouge
            if Noel:getFlag("understand_dessmode") then
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
            --cutscene:text("* Don't say things you don't mean.", "lam", "noel")
            --cutscene:text("* Just keep playing your game.", "t_goaway", "noel")
        end
        if choicer == 1 then
            cutscene:text("* Swag Bacon.", "bruh", "noel")
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

local dess_mode = function(cutscene, event)
    local save = Noel:loadNoel()
    if not Noel:isDess() then

        cutscene:setTextboxTop(true)

        cutscene:text("* Hello again Dess [wait:5]still in dess mode I see", "bruh", "noel", {auto = true})

        cutscene:text("* Join the party. I'm getting sick of waiting in lobby.", "doom_AURGHHHHHH", "dess")

        cutscene:text("* Didn't I already tell you that I...", "...", "noel")
        cutscene:text("* Actually,[wait:5] [face:huh]wait a minute,[wait:5] [face:neutral]I think I might have an idea...", "bruh", "noel")

        cutscene:text("* Is it being as cool as me?", "swag", "dess")

        cutscene:text("* Close,[wait:5] [face:neutral]just give me a second.", "lookup", "noel")

        cutscene:text("* I'm confused,[wait:5] [face:condescending]am I waiting a minute or a second?", "reverse", "dess")

        cutscene:text("* Just wait.[wait:10]\nGame:addPartyMember(\"noel\")", "neutral", "noel", {auto = true})

        Game.world.music:pause()

        local loop = Kristal.errorHandler("Party member can't not be dess.")
        local stoptime = os.time() + 3
        while true do
            local res = loop()
            if os.time() >= stoptime then break end
            if res ~= nil then break end
        end

        local loop = Kristal.errorHandler("Party member can't not be dess.\nParty is suddenly only Dess again.")
        local stoptime = os.time() + 3
        while true do
            local res = loop()
            if os.time() >= stoptime then break end
            if res ~= nil then break end
        end

        local loop = Kristal.errorHandler("Party member can't not be dess.\nParty is suddenly only Dess again.\nResuming Gameplay.")
        local stoptime = os.time() + 3
        while true do
            local res = loop()
            if os.time() >= stoptime then break end
            if res ~= nil then break end
        end

        Game.world.music:resume()

        Noel:setFlag("can_be_dess", true)

        local noel = cutscene:getCharacter("noel")
        noel.actor:init()
        noel:resetSprite()

        cutscene:text("* Okay[wait:5] this should still count as being a Dess only party I think.", "d_neutral_1", "noel")

        cutscene:text("* ...", "mspaint", "dess")
        cutscene:text("* Normally I wouldn't be cool with people copying me,[wait:5] [face:condescending]but in the spirit of this being [face:swag]Dess Mode[face:thisremindsmeofthetimeiwasindarkplace][font:main_mono,16]TM[font:reset] [face:calm_b]I'll allow it.", "angry", "dess")

        cutscene:text("* Okay.", "d_neutral_2", "noel")

        Game.world.music:pause()
        local fan = Music("deltarune/fanfare", 1, 0.9, false)

        Game:addPartyMember("noel")

        noel:convertToFollower()
		cutscene:attachFollowers()

		cutscene:setSpeaker()
		cutscene:text("[noskip][voice:none][speed:0.1]* (Dess? joined the party?)[wait:70]\n[speed:1](Who the hell is writing this shit?)")
		fan:remove()
		Game.world.music:resume()
        cutscene:text("* me of course.", "smug", "dess")

        Game:setFlag("noel_SaveID", save["SaveID"])

        Game:getPartyMember("noel"):setActor("noel")

    else
        cutscene:text("* May I join the party?", "bruh", "noel")
        local choicer = cutscene:choicer({"Yes", "No"})

        if choicer == 1 then
            cutscene:text("* Swag Bacon.", "d_neutral_2", "noel")
            local noel = cutscene:getCharacter("noel")
            noel:convertToFollower()
            cutscene:attachFollowers()
            Game:setFlag("noel_SaveID", save["SaveID"])
            Game:addPartyMember("noel")
            Game:getPartyMember("noel"):setActor("noel")
        elseif choicer == 2 then
            cutscene:text("* Oll'Korrect.", "d_neutral_1", "noel")
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
        turncoat:remove()
        Game.world.music:fade(1, 0.5)

    --cutscene:text("* The wall seems cracked.", "bruh", "noel")
end

function Noel:NoelEnter(noelsave)
    local savedData = noelsave
    local map = Game.world.map.id
    local mod = Mod.info.id

        if savedData.Map == "main_hub" then savedData.Map = [[floor1/main]] end

        local spawnPositions = {
            warphub = {384, 361, {cutscene = place_holder, animation = "brella"}},
            deoxtest = {214, 340, {cutscene = place_holder, animation = "brella"}},
            room1 = {400, 740, {cutscene = place_holder, animation = "brella"}},
            ["floor1/main"] = {460, 380, {cutscene = place_holder, animation = "brella"}},
            ["floor1/benchroom"] = {1692, 1594, {cutscene = place_holder, animation = "brella"}},
            ["floor1/main_south"] = {660, 730, {cutscene = place_holder, animation = "brella"}},
            ["floor2/main_1"] = {298, 434, {cutscene = place_holder, animation = "brella"}},
            ["floor2/dev/main_1"] = {1020, 266, {cutscene = place_holder}},
            ["floor2/dev/everhall_entry"] = {140, 274, {cutscene = place_holder, animation = "brella"}},
            ["floorcyber/dog_highway"] = {1006, 428, {cutscene = place_holder}},
            ["floorcyber/shops"] = {420, 428, {cutscene = place_holder}},
            ["floorcyber/pre_spamtown"] = {366, 238, {cutscene = place_holder}},
            ["steamworks/05"] = {260, 290, {cutscene = place_holder}},
            ["steamworks/09"] = {1000, 390, {cutscene = place_holder}},
            ["steamworks/15"] = {490, 510, {cutscene = place_holder}},
            ["steamworks/19"] = {460, 350, {cutscene = place_holder}},
            ["steamworks/23"] = {980, 220, {cutscene = place_holder}},
        }

    if map == savedData.Map and mod == savedData.Mod then
        local position = spawnPositions[savedData.Map] 
        if position then
            if position[3] then
                Noel:spawnNoel(position[1], position[2], position[3])
            else
                Noel:spawnNoel(position[1], position[2])
            end
        end
    end
end

function Noel:spawnNoel(x, y, data)
    local save = Noel:loadNoel()
    if Game:hasPartyMember("noel") then
        Noel:checkNoel()
    else
        if Game:isDessMode() and Noel:getFlag("understand_dessmode") then
            
            Game.world:spawnNPC("noel", x, y, {cutscene = dess_mode})   
        elseif data then
            Game.world:spawnNPC("noel", x, y, data)
        else
            Game.world:spawnNPC("noel", x, y, {cutscene = "noel.found_again"})
        end
        if Game.world.map.id == "floorcyber/dog_highway" then
            Game.world:getCharacter("noel"):setFacing("up")
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

function Noel:getFlag(flag, default)
    local data

    -- Check if the save file exists
    if love.filesystem.getInfo("saves/null.char") then
        data = JSON.decode(love.filesystem.read("saves/null.char"))
    else
        return default
    end

    -- Ensure the flags table exists
    local flags = data.flags or {}

    -- Return the flag value or default if not found
    return flags[flag] ~= nil and flags[flag] or default
end

function Noel:setFlag(flag_name, value)
    local data

    -- Check if the save file exists
    if love.filesystem.getInfo("saves/null.char") then
        data = JSON.decode(love.filesystem.read("saves/null.char"))
    else
        data = {}
    end

    -- Ensure the flags table exists
    data.flags = data.flags or {}

    -- Set the flag value
    data.flags[flag_name] = value

    -- Write back to the file
    love.filesystem.write("saves/null.char", JSON.encode(data))
end

function Noel:remove()
end

function Noel:delete()
end

function Noel:erase()
end

function Noel:kill()
end

function Noel:die()
end

function Noel:uninstall()
end

function Noel:breaks(frue)

--crirorwf, ophacotchwehaq, wvagixhaq, aclhnhaq
end


function Noel:crow_launguage(txt)
    local txt = txt
    --There is 100% a better way to do this
    local crow_language = {
        a = "w",
        b = "v",
        c = "n",
        d = "x",
        e = "o",
        f = "b",
        g = "z",
        h = "r",
        i = "h",
        j = "m",
        k = "y",
        l = "e",
        m = "q",
        n = "t",
        o = "l",
        p = "u",
        q = "f",
        r = "i",
        s = "a",
        t = "c",
        u = "g",
        v = "j",
        w = "s",
        x = "p",
        y = "k",
        z = "d",
        A = "W",
        B = "V",
        C = "N",
        D = "X",
        E = "O",
        F = "B",
        G = "Z",
        H = "R",
        I = "H",
        J = "M",
        K = "Y",
        L = "E",
        M = "Q",
        N = "T",
        O = "L",
        P = "U",
        Q = "F",
        R = "I",
        S = "A",
        T = "C",
        U = "G",
        V = "J",
        W = "S",
        X = "P",
        Y = "K",
        Z = "D",
    }
    local output = txt:gsub(".", function(symbol)
        return crow_language[symbol] or symbol
    end)
    return output
end

function Noel:getDebugOptions(context, thing)

    local my_self = thing
    local context = context

    if my_self.visible then
        context:addMenuItem("Delete", "Delete this object", function() my_self.visible = false end)
    else
        context:addMenuItem("Show", "Show this object.", function() my_self.visible = true end)
    end
    context:addMenuItem("Explode", "'cuz it's funny", function()
        print("no")
    end)
    return context
end

return Noel
