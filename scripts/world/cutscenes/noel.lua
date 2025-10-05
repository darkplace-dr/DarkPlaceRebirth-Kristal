return {

    meet = function(cutscene)
--Game.world.camera:setZoom(2.25)
    if Game.world.map.id ~= "greyarea" then
        cutscene:text("* Hello you Hirty Dacker.", "neutral", "noel")
        cutscene:text("* Goodbye now.", "bruh", "noel")
        error("Find the GREYAREA first.")
    end
    local index = love.window.showMessageBox("???", "* Once you let me in, I will never leave.\n\n* Understood?", {"No", "Yes", escapebutton = 3}, "warning")


    local name = Game.save_name

    if index == 1 then return end

    if index == 3 then


        love.window.showMessageBox("???", "* Rude.", {"OK", escapebutton = 3}, "info")


        return
    end

        if not Noel:loadNoel() then
            if Game:isDessMode() then
                cutscene:text("* Gonna make a char file real quick.", "d_neutral_1", "noel")
            else
                cutscene:text("* Gonna make a char file real quick.", "bruh", "noel")
            end


            local data = {
                Attack = 1,
                Defense = -100,
                Equipped = {
                    weapon = {
                        flags = {},
                        id = "old_umbrella"
                    },
                    armor = {
                        [1] = {
                        flags = {},
                        id = "ironshackle"
                        }
                    }
                },
                Spells = {
                    "spare_smack",
                    "soul_send",
                    "quick_heal",
                    "life_steal",
                    --"sirens_serenade"
                },
                Kills = 0,
                SaveID = 0,
                version = 0.016,
                Map = "main_hub",
                Mod = "dpr_main",
                Health = 900,
                MaxHealth = 900,
                Magic = 1,
                Level = "-1"
            }
            
            Noel:saveNoel(data)
            Game:setFlag("noel_SaveID", 0)
            Noel:setFlag("FUN", Game:getFlag("FUN"))
            if Game:isDessMode() then
                cutscene:text("* Okay I'm done.", "d_neutral_1", "noel")
            else
                cutscene:text("* Okay I'm done.", "bruh", "noel")
            end
            local noel = cutscene:getCharacter("noel")
            if Game:isDessMode() then
                Noel:setFlag("identity_crisis", true)
                noel.actor:init()
                noel:resetSprite()
            end

         -- GO MY DARK PLACE LEGACY!
        cutscene:showNametag("Noel", { top = true, right = false})

        function writeTextWithNametag(text, swap, face)

            local len = string.len(text)
            print(len)
            for i = 1, len do

                local current = string.sub(text, 1, i - 1)
                local letter = string.sub(text, i, i)
                print("" .. current .. "")
                cutscene:showNametag("".. current ..""..string.upper(letter), { top = true, right = false})
                if i == len then
                    if swap then
                        cutscene:text("[instant]"..swap, face, "noel", {auto = false})
                    else
                        cutscene:text("[instant]".. current .."[stopinstant]".. letter, face, "noel", {auto = false})
                    end
                else
                    if swap then
                        cutscene:text("[instant]"..swap, face, "noel", {auto = true})
                    else
                        cutscene:text("[instant]".. current .."[stopinstant]"..letter, face, "noel", {auto = true})
                    end
                end
                Assets.playSound("voice/noel/"..string.lower(letter), 1, 1)
            end
        end

        cutscene:text("* (...)", "bruh")
        cutscene:text("* ([shake:1][speed:0.4]"..Game.save_name.."?[shake:0][wait:3][speed:1] Right?)", "bruh")
        cutscene:text("* (Forgive me if I'm wrong.)\n[wait:8]* (I have no real way to verify if it is honestly.)\n[wait:8]* (I really should not rely on Game.save_name for", "neutral", "noel", {auto = true})

        cutscene:showNametag("Noel", { top = true, right = false})
        
        cutscene:text("* oh, l didn't even intrOduce myseIf.[wait:8]", "bruh", "noel", {auto = true})
        cutscene:showNametag("There was no name here. You're crazy.", { top = true, right = false})
        cutscene:text("[instant]* Oh, I didn't even introduce myself.", "bruh", "noel")

        cutscene:text("* (Not like I need to, since you can read my [color:yellow]NAMETAG[color:reset] n all.)[wait:8]", "bruh", "noel", {auto = true})
        cutscene:showNametag("Oh wait, you can't.", { top = true, right = false})
        cutscene:text("[instant]* (Not like I need to, since you can read my [color:yellow]NAMETAG[color:reset] n all.)", "bruh")

        writeTextWithNametag("* Name's Noel, and you are?", "Noel", "neutral")

        if Game.party[1].id == "hero" then -- TODO

        end

        cutscene:hideNametag()

                cutscene:text("* So, may I join the [color:yellow]PARTY[color:white]?", "neutral")
                local cc = cutscene:choicer({"Yes", "No"})
                if cc == 1 then
                    if #Game.party == 4 then
                        cutscene:text("* That's nice to hear. Unfortunatly your party is full.", "neutral")
                        noel:remove()
                    else
                        cutscene:text("* Swag bacon.", "bruh")

                        noel:convertToFollower()
                        cutscene:attachFollowers()
                        local n = Game:addPartyMember("noel")
                        n:load({})
                    end
                else
                    cutscene:text("* Understood ".. Game.save_name ..".", "neutral")
                    noel:remove()
                end

        end
    end
}
