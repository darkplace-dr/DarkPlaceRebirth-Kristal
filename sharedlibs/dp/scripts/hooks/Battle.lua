---@class Battle : Battle
local Battle, super = HookSystem.hookScript(Battle)

function Battle:init()
    super.init(self)

    self.freeze_xp = 0

    self.killed = false

    self.superpower = false

    self.super_timer = 0

    if Game.pp > 0 then
        self.no_buff_loop = true
    else
        self.no_buff_loop = false
    end

    self.month = tonumber(os.date("%m"))
    self.day = tonumber(os.date("%d"))

    if self.month == 10 and self.day == 31 then
        local skeledance = Sprite("battle/skeledance/skeledance", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        skeledance:setOrigin(0.5)
        skeledance:setColor(self.color)
        skeledance:play(1/15, true)
        skeledance:setScale(5, 2)
        skeledance.alpha = 14/255
        skeledance.debug_select = false
        self:addChild(skeledance)

        skeledance.layer = BATTLE_LAYERS["bottom"]
    end
    if self.month == 10 then
        self.lines = {}
        for _=1,4 do
            self:spawnWeb(0,love.math.random(40,480), love.math.random(40,120),0)
            self:spawnWeb(640,love.math.random(40,480), 640-love.math.random(40,120),0)
        end
    end
    
    self.particles = {}
    self.particle_interval = 0
    self.particle_tex = Assets.getTexture("player/heart_menu_outline")
    self.enable_particles = false
    
    for _,party1 in ipairs(Game.party) do
        if party1:hasSpell("echo") then
            local temp = {}
            for _,party2 in ipairs(Game.party) do
                if party1 ~= party2 and party2.id ~= "noel" then
                    for _,spell in ipairs(party2.spells) do
                        table.insert(temp, spell)
                    end
                end
            end
            
            for _,spell in ipairs(party1.spells) do
                if spell.id == "echo" then
                    spell.spells = {}
                    for k,v in ipairs(temp) do
                        table.insert(spell.spells, v)
                    end
                end
            end
        end
    end
    
    self.temperature = 50
    self.max_temperature = 100
    self.min_temperature = 0
end

function Battle:postInit(state, encounter)
    super.postInit(self, state, encounter)

    if Game.bossrush_encounters and not self.encounter.no_dojo_bg then
        self.dojobg = self:addChild(DojoBG())
    end
    
    self.temperature = self.encounter.temperature
    
    Kristal.Console:log(self.temperature)
end

function Battle:incTemp(amount)
    self.temperature = math.min(self.max_temperature, self.temperature + amount)
end

function Battle:decTemp(amount)
    self.temperature = math.max(self.min_temperature, self.temperature - amount)
end

function Battle:breakSoulShield()
    Assets.playSound("mirrorbreak")
    self.soul:addChild(SoulExpandEffect())
    local shard_x_table = {-2, 0, 2, 8, 10, 12}
    local shard_y_table = {0, 3, 6}
    self.soul.shards = {}
    for i = 1, 6 do
        local x_pos = shard_x_table[((i - 1) % #shard_x_table) + 1]
        local y_pos = shard_y_table[((i - 1) % #shard_y_table) + 1]
        local shard = Sprite("player/heart_shard", self.soul.x + x_pos, self.soul.y + y_pos)
        shard.physics.direction = math.rad(MathUtils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = self.soul.layer
        shard:play(5/30)
        table.insert(self.soul.shards, shard)
        self.soul.stage:addChild(shard)
    end
end

function Battle:onDefendingState()
    -- Ceroba's shield on turn start
    if self:getPartyBattler("ceroba") and not self.no_buff_loop then
		self.wave_length = 0
		self.wave_timer = 0

        self.no_buff_loop = true
		local prev_can_move = self.soul.can_move
		for _, wave in ipairs(self.waves) do
			if self.soul.buff_freeze or wave.buff_freeze then
				self.soul.can_move = false
			end
		end
        self.soul:addChild(CerobaDiamondBuff(0, 0, function()
			for _, wave in ipairs(self.waves) do
				wave.encounter = self.encounter

				self.wave_length = math.max(self.wave_length, wave.time)

				if self.soul.buff_freeze or wave.buff_freeze then
					self.soul.can_move = prev_can_move
				end

				wave:onStart()

				wave.active = true
			end
		end))
		return
	end
	super.onDefendingState(self)
end

--- Gets a table that contains all battlers in the battle.
---@return table<PartyBattler|EnemyBattler> battlers A table containing all PartyBattler and EnemyBattler currently in the battle
function Battle:getBattlers()
    return TableUtils.mergeMany(Game.battle.party, Game.battle.enemies)
end

return Battle
