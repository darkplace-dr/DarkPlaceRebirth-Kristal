-- VENDor CUSTomizations (Android reference)
-- (an awful name that doesn't even fit, I know...)
-- See also /conf.lua

-- The "target mod"'s ID. (- the one in mod.json) \
-- If set, the start menu is modified to direct the player to start/load a game \
-- of the designated mod, instead of letting them choose which mod to play. \
-- Also set if command parameter `--mod <id>` is passed to the engine. \
-- (The value set here overrides that)
---@type string
TARGET_MOD = "dpr_main"

-- From which Github organisation should Kristal fetches the DLCs from
-- If nil, will fallback to GITHUB_REPOS
GITHUB_ORGANISATION = nil

-- Additional DLCs that aren't in the organisation above for some reason
-- (like the organisation not existing yet)
GITHUB_REPOS = {
	Simbel0={
		"Temple-Of-Creativity"
	},
	AcousticJammYT={
		"dpr_jamm_dlc",
		"DPR_Dark_Pit",
		"dlc_future"
	},
	Hyperboid={
		"dlc_test"
	},
	NelleMonelle={
		"dlc_yellow"
	},
	BrendaK7200={
		"dlc_forest"
	},
	JustAnotherRandomGithubUser={
		"dpr_spamtown_dlc",
		"dpr_underground_dlc"
	},
	DiamondBor={
		"dlc_trials"
	}
}

-- Disables Kristal's built-in Main menu and \
-- immediately loads the target mod.
---@type boolean
AUTO_MOD_START = false
