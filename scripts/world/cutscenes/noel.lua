return {

    meet = function(cutscene)
        if not Noel:loadNoel() then
            cutscene:text("* Gonna make a char file real quick.", "bruh", "noel")
            cutscene:text("* This is just placeholder text okay?", "bruh", "noel")


            local data = {
                Attack = 1,
                Defense = -100,
                Equipped = {
                    weapon = {
                        flags = {},
                        id = "old_umbrella"
                    }
                },
                Spells = {
                    "spare_smack",
                    "soul_send",
                    "quick_heal",
                    "life_steal"
                },
                Kills = 0,
                SaveID = 0,
                version = 0.01,
                Map = "main_hub",
                Mod = "dpr_main",
                Health = 900,
                MaxHealth = 900,
                Magic = 1,
                Level = "-1"
            }
            
            Noel:saveNoel(data)
            Game:setFlag("noel_SaveID", 0)
            cutscene:text("* Okay I'm done.", "bruh", "noel")
            local noel = cutscene:getCharacter("noel")
            noel:convertToFollower()
            cutscene:attachFollowers()
            Game:addPartyMember("noel")
        end
    end
}
