return {

    meet = function(cutscene)
--Game.world.camera:setZoom(2.25)
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
                version = 0.015,
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
            Game:addPartyMember("noel")
        end
    end
}
