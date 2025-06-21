return {

    meet = function(cutscene)
--Game.world.camera:setZoom(2.25)


    local index = love.window.showMessageBox("???", "* Once you let me in, I will never leave.\n\n* Understood?", {"No", "Yes", escapebutton = 3}, "warning")


    local name = Game.save_name

    if index == 1 then return end

    if index == 3 then


        love.window.showMessageBox("???", "* Rude.", {"OK", escapebutton = 3}, "info")


        return
    end

        if not Noel:loadNoel() then
            if Game:isDessMode() then


            else
                cutscene:text("* Gonna make a char file real quick.", "bruh", "noel")
                cutscene:text("* This is just placeholder text okay?", "bruh", "noel")
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
                    "sirens_serenade"
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
            noel:convertToFollower()
            cutscene:attachFollowers()
            local n = Game:addPartyMember("noel")
            n:load({})
        end
    end
}
