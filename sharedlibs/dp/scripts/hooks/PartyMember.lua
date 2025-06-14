---@class PartyMember : PartyMember
local PartyMember, super = Utils.hookScript(PartyMember)

function PartyMember:init()
    super.init(self)
    self.flee_text = {}

    self.has_command = false

    -- Combos
    self.combos = {}

    self.love = 1
    self.exp = 0
    self.max_exp = 99999
    self.kills = 0

    -- Party member specific EXP requirements
    -- The size of this table is the max LV
    self.exp_needed = {
        [ 1] = 0,
        [ 2] = 10,
        [ 3] = 30,
        [ 4] = 70,
        [ 5] = 120,
        [ 6] = 200,
        [ 7] = 300,
        [ 8] = 500,
        [ 9] = 800,
        [10] = 1200,
        [11] = 1700,
        [12] = 2500,
        [13] = 3500,
        [14] = 5000,
        [15] = 7000,
        [16] = 10000,
        [17] = 15000,
        [18] = 25000,
        [19] = 50000,
        [20] = 99999
    }

    self.future_heals = {}

    self.ribbit = false

    self.opinions = {}
    self.default_opinion = 50

    -- this fucking sucks but i don't care lol
    -- based
    --   -char
    self.mhp_damage = 0

    -- protection points for soul shield mechanic
    self.pp = 0

    -- whether or not the next attack should be reflected
    self.reflectNext = false

    -- did this character graduate high school?
    self.graduate = false

    -- their TV name
    self.tv_name = nil
end

function PartyMember:getSavedMHP() return self.saved_mhp end

function PartyMember:getStarmanTheme() return "default" end

function PartyMember:getTVName()
	if self.tv_name then return self.tv_name end
	local first_three = string.sub(self.name, 1, 3)
	return string.upper(first_three)
end

return PartyMember