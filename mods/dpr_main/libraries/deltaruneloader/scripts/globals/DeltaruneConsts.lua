local DeltaruneConsts = {}

DeltaruneConsts.ITEM_IDS = {
    [ 1] = "dark_candy",
    [ 2] = "revivemint",
    [ 3] = "glowshard",
    [ 4] = "manual",
    [ 5] = "brokencake",
    [ 6] = "top_cake",
    [ 7] = "spincake",
    [ 8] = "darkburger",
    [ 9] = "lancercookie",
    [10] = "gigasalad",
    [11] = "clubssandwich",
    [12] = "heartsdonut",
    [13] = "chocdiamond",
    [14] = "favwich",
    [15] = "rouxlsroux",
    [16] = "cd_bagel",
    [17] = "mannequin",
    [18] = "kris_tea",
    [19] = "noelle_tea",
    [20] = "ralsei_tea",
    [21] = "susie_tea",
    [22] = "dd_burger",
    [23] = "lightcandy",
    [24] = "butjuice",
    [25] = "spagetticode",
    [26] = "javacookie",
    [27] = "tensionbit",
    [28] = "tensiongem",
    [29] = "tensionmax",
    [30] = "revivedust",
    [31] = "revivebrite",
    [32] = "s_poison",
    [33] = "dogdollar"
}

DeltaruneConsts.KEY_ITEM_IDS = {
    [ 1] = "cell_phone",
    [ 2] = "egg",
    [ 3] = "brokencake",
    [ 4] = "broken_key_a",
    [ 5] = "door_key",
    [ 6] = "broken_key_b",
    [ 7] = "broken_key_c",
    [ 8] = "lancer",
    [ 9] = "rouxls_kaard",
    [10] = "emptydisk",
    [11] = "loadeddisk",
    [12] = "keygen",
    [13] = "shadowcrystal",
    [14] = "starwalker",
    [15] = "purecrystal"
}

DeltaruneConsts.WEAPON_IDS = {
    [ 1] = "wood_blade",
    [ 2] = "mane_ax",
    [ 3] = "red_scarf",
    [ 4] = "everybodyweapon",
    [ 5] = "spookysword",
    [ 6] = "brave_ax",
    [ 7] = "devilsknife",
    [ 8] = "trefoil",
    [ 9] = "ragger",
    [10] = "daintyscarf",
    [11] = "twistedswd",
    [12] = "snowring",
    [13] = "thornring",
    [14] = "bounceblade",
    [15] = "cheerscarf",
    [16] = "mechasaber",
    [17] = "autoaxe",
    [18] = "fiberscarf",
    [19] = "ragger2",
    [20] = "brokenswd",
    [21] = "puppetscarf",
    [22] = "freezering"
}

DeltaruneConsts.ARMOR_IDS = {
    [ 1] = "amber_card",
    [ 2] = "dice_brace",
    [ 3] = "pink_ribbon",
    [ 4] = "white_ribbon",
    [ 5] = "ironshackle",
    [ 6] = "mousetoken",
    [ 7] = "jevilstail",
    [ 8] = "silver_card",
    [ 9] = "twinribbon",
    [10] = "glowwrist",
    [11] = "chainmail",
    [12] = "bshotbowtie",
    [13] = "spikeband",
    [14] = "silver_watch",
    [15] = "tensionbow",
    [16] = "mannequin",
    [17] = "darkgoldband",
    [18] = "skymantle",
    [19] = "spikeshackle",
    [20] = "frayedbowtie",
    [21] = "dealmaker",
    [22] = "royalpin"
}

DeltaruneConsts.LIGHT_ITEM_IDS = {
    [ 1] = "light/hot_chocolate",
    [ 2] = "light/pencil",
    [ 3] = "light/bandage",
    [ 4] = "light/bouquet",
    [ 5] = "light/ball_of_junk",
    [ 6] = "light/halloween_pencil",
    [ 7] = "light/lucky_pencil",
    [ 8] = "light/egg",
    [ 9] = "light/cards",
    [10] = "light/box_of_heart_candy",
    [11] = "light/glass",
    [12] = "light/eraser",
    [13] = "light/mech_pencil",
    [14] = "light/wristwatch"
}

DeltaruneConsts.ROOM_IDS = {
    [  3] = "Queen's Mansion - Rooftop",
    [ 27] = "Kris's Room",
    [ 64] = "Castle Town",
    [ 70] = "Castle Town",
    [ 71] = "My Castle Town",
    [ 87] = "Cyber Field - Entrance",
    [ 92] = "Cyber Field - Arcade Machine",
    [ 98] = "Cyber Field - Music Shop",
    [121] = "Cyber City - Entrance",
    [124] = "Cyber City - First Alleyway",
    [130] = "Cyber City - Music Shop",
    [135] = "Cyber City - Mouse Alley",
    [137] = "Cyber City - Second Alleyway",
    [142] = "Cyber City - Heights",
    [161] = "Queen's Mansion - Guest Hall",
    [166] = "Queen's Mansion - Entrance",
    [180] = "Queen's Mansion - Basement",
    [196] = "Queen's Mansion - 3F",
    [202] = "Queen's Mansion - Acid Tunnel",
    [205] = "Queen's Mansion - 4F",
    [282] = "Kris's Room",
    [315] = "??????",
    [320] = "Eye Puzzle",
    [325] = "Castle Town",
    [329] = "Field - Great Door",
    [336] = "Field - Maze of Death",
    [339] = "Field - Seam's Shop",
    [348] = "Field - Great Board",
    [351] = "Field - Great Board 2",
    [353] = "Forest - Entrance",
    [362] = "Forest - Bake Sale",
    [370] = "Forest - Before Maze",
    [376] = "Forest - After Maze",
    [377] = "Forest - Thrashing Room",
    [387] = "Card Castle - Prison",
    [391] = "Card Castle - ???",
    [394] = "Card Castle - 1F",
    [403] = "Card Castle - 5F",
    [406] = "Card Castle - Throne"
}

DeltaruneConsts.TEAM_NAMES = {
    [0] = "Guys",
    [1] = "$!$? Squad",
    [2] = "Lancer Fan Club",
    [3] = "Fun Gang"
}

DeltaruneConsts.TITLE_NAMES = {
    -- Kris
    [  0] = "Human",
    [  1] = "Leader",
    [  2] = "Bed Inspector",
    [  3] = "Tactician",
    [  4] = "Moss Finder",
    [  5] = "Leader",
    -- Susie
    [100] = "Mean Girl",
    [101] = "Dark Knight",
    [102] = "Healing Master",
    [103] = "Moss Enjoyer",
    -- Ralsei
    [200] = "Lonely Prince",
    [201] = "Prickly Prince",
    [202] = "Fluffy Prince",
    [203] = "Dark Prince",
    [204] = "Hug Prince",
    [205] = "Pose Prince",
    [206] = "Rude Prince",
    [207] = "Blank Prince",
    -- Noelle
    [300] = "Snowcaster",
    [301] = "Frostmancer",
    [302] = "Ice Trancer",
    [303] = "Moss Neutral"
}

DeltaruneConsts.TITLE_DESCRIPTIONS = {
    -- Kris
    [  0] = "Body contains a\nhuman SOUL.",
    [  1] = "Commands the party\nwith various ACTs.",
    [  2] = "Inspects all beds\ninexplicably.",
    [  3] = "Commands the party\nby ACTs. Sometimes.",
    [  4] = "Basic moss-finding\nabilities.",
    [  5] = "Commands.",
    -- Susie
    [100] = "Won't do anything\nbut fight.",
    [101] = "Does damage using\ndark energy.",
    [102] = "Can use ultimate\nhealing. (Losers!)",
    [103] = "Supports those\nthat find moss.",
    -- Ralsei
    [200] = "Dark-World being.\nHas no subjects.",
    [201] = "Deals damage with\nhis rugged scarf.",
    [202] = "Weak, but has nice\nhealing powers.",
    [203] = "Dark-World being.\nHas friends now.",
    [204] = "Receives and\ngives many hugs.",
    [205] = "Poses for photos\nat times.",
    [206] = "Friends with a\nrude gesturer.",
    [207] = "Doesn't even\nhave a photo.",
    -- Noelle
    [300] = "Might be able to\nuse some cool moves.",
    [301] = "Freezes the enemy.",
    [302] = "Receives pain to\nbecome stronger.",
    [303] = "Neither chaotic nor\nlawful to moss."
}

return DeltaruneConsts