return {
  --[[
  {
    name = "Example", -- name of the break
    actors = { "susie", "dess" }, -- actors to spawn
    actors_sprites = { dess = "teehee" }, -- sprites for actors to set
    cutscene = "breaks.susie_dess", -- path to the cutscene
    unlocked_party_checks = { "dess" }, -- available only if this list of party members is unlocked
    flag_checks = { "testflag1", "!testflag2" } -- available only is testflag1 is true, and testflag2 is false (or nil)
    -- unlocked_party_checks and flag_checks do stack
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
    actors_sprites = { dess = "teehee" },
    cutscene = "breaks.susie_dess",
    unlocked_party_checks = { "dess" }
  },
  {
    name = "1225",
    actors = { "dess" },
    actors_sprites = { dess = "teehee" },
    cutscene = "breaks.onetwotwofive",
    unlocked_party_checks = { "dess" }
  },
}
