return {
    --[[
    {
        name = "Example",                                 -- name of the break
        actors = { "susie", "dess" },                     -- actors to spawn
        actor_options = { dess = { sprite = "teehee" } }, -- options: sprite, offset = { x, y }, flip (true or false)
        cutscene = "breaks.susie_dess",                   -- path to the cutscene
        unlocked_party_checks = { "dess" },               -- available only if this list of party members is unlocked (do stack with flag_checks)
        flag_checks = { "testflag1", "!testflag2" }       -- available only is testflag1 is true, and testflag2 is false or nil (do stack with unlocked_party_checks)
    },
    ]]
    {
        name = "Hero & Susie",
        actors = { "hero", "susie" },
        cutscene = "breaks.hero_susie"
    },
    {
        name = "Susie & Dess",
        actors = { "susie", "dess" },
        actor_options = { dess = { sprite = "teehee" } },
        cutscene = "breaks.susie_dess",
        unlocked_party_checks = { "dess" }
    },
    {
        name = "Ceroba & Jamm",
        actors = { "ceroba", "jamm" },
        cutscene = "breaks.ceroba_jamm",
        unlocked_party_checks = { "ceroba", "jamm" }
    },
    {
        name = "1225",
        actors = { "dess" },
        actor_options = { dess = { sprite = "teehee" } },
        cutscene = "breaks.onetwotwofive",
        unlocked_party_checks = { "dess" }
    },
}
