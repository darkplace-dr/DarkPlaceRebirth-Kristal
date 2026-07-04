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

    if Kristal.Config["silly_mode"] then
        self:addFX(ShaderFX("bloom"), "bloom")
    end
	
    self.victory = false
end

function Battle:postInit(state, encounter)
    super.postInit(self, state, encounter)

    if Game.bossrush_encounters and not self.encounter.no_dojo_bg then
        self.dojobg = self:addChild(DojoBG())
    end
    
    self.temperature = self.encounter.temperature

    if Game:hasPartyMember("pink") then

        self.doki_bar = dokibar(-25, 40, true)
        self:addChild(self.doki_bar)
    end
    
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
    for i = 1, 6 do
        local x_pos = shard_x_table[((i - 1) % #shard_x_table) + 1]
        local y_pos = shard_y_table[((i - 1) % #shard_y_table) + 1]
        local shard = Sprite("player/heart_shard", self.soul.x + x_pos, self.soul.y + y_pos)
        shard.physics.direction = math.rad(MathUtils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = self.soul.layer
        shard:play(5/30)
        self:addChild(shard)
    end
end

function Battle:onDefendingState()
    -- Ceroba's shield on turn start
    local diamond_guard = false
    for _,partymember in ipairs(Game.party) do
        if partymember:hasSpell("diamond_guard") then
            diamond_guard = true
            break
        end
    end
    if diamond_guard and not self.no_buff_loop then
        self:darken()
        self:hideTargets()

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
                -- while buff is being applied, wave_timer goes up so we gotta reset it again
                self.wave_timer = 0

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

function Battle:nextTurn()
    super.nextTurn(self)
    
    if self.ally then
        self.ally:onTurnStart()
    end
end

function Battle:update()
    super.update(self)
    
    if self.ally then
        self.ally:onUpdate()
    end
end

function Battle:updateActionsDone()
    super.updateActionsDone(self)
    
    if self.ally then
        self.ally:onActionsEnd()
    end
end

function Battle:onVictory()
    self.victory = true
    for _,battler in ipairs(self.party) do
        if battler.health_rolling_to <= 0 or battler.chara:getHealth() <= 0 then
            battler:revive()
            battler.health_rolling_to = battler.chara:autoHealAmount()
        end
        battler.chara:setHealth(battler.health_rolling_to)
    end
	return super.onVictory(self)
end

function Battle:onFlee()
    self.current_selecting = 0
    local flee_complete = false

    if self.tension_bar then
        self.tension_bar:hide()
    end

    for _,battler in ipairs(self.party) do
        battler:setSleeping(false)
        battler.defending = false
        battler.action = nil

        if battler.chara:getHealth() <= 0 then
            battler:revive()
            battler.chara:setHealth(1)
        end

        if battler.actor:getAnimation("battle/flee") then
            battler:setAnimation("battle/flee")
        else
            battler:setAnimation("battle/hurt")
        end

        Assets.playSound("defeatrun")

        local sweat = Sprite("effects/defeat/sweat")
        sweat:setOrigin(0.5, 0.5)
        sweat:setScale(0.5, 0.5)
        sweat:play(5/30, true)
        sweat.layer = 100
        battler:addChild(sweat)

        Game.battle.timer:after(15/30, function()
            sweat:remove()
            battler:getActiveSprite().run_away_2 = true
            flee_complete = true
        end)

        local box = self.battle_ui.action_boxes[self:getPartyIndex(battler.chara.id)]
        box:resetHeadIcon()
    end
    if self.back_row then
        if self.back_row.actor:getAnimation("battle/flee") then
            self.back_row:setAnimation("battle/flee")
        else
            self.back_row:setAnimation("battle/hurt")
        end

        local sweat = Sprite("effects/defeat/sweat")
        sweat:setOrigin(0.5, 0.5)
        sweat:setScale(0.5, 0.5)
        sweat:play(5/30, true)
        sweat.layer = 100
        self.back_row:addChild(sweat)

        Game.battle.timer:after(15/30, function()
            sweat:remove()
            self.back_row:getActiveSprite().run_away_2 = true
            flee_complete = true
        end)
    end

    -- self.money = self.money + (math.floor(((Game:getTension() * 2.5) / 10)) * Game.chapter)

    for _,battler in ipairs(self.party) do
        for _,equipment in ipairs(battler.chara:getEquipment()) do
            self.money = math.floor(equipment:applyMoneyBonus(self.money) or self.money)
        end
    end

    self.money = math.floor(self.money)

    self.money = self.encounter:getVictoryMoney(self.money) or self.money
    self.xp = self.encounter:getVictoryXP(self.xp) or self.xp
    -- if (in_dojo) then
    --     self.money = 0
    -- end

    Game.money = Game.money + self.money
    Game.xp = Game.xp + self.xp

    if (Game.money < 0) then
        Game.money = 0
    end
    
    local earn_text = ""
    if self.money ~= 0 or self.xp ~= 0 then
        earn_text = "* Ran away with " .. self.xp .. " EXP and " .. self.money .. " "..Game:getConfig("darkCurrencyShort").."."
    end
        
    if self.used_violence and Game:getConfig("growStronger") then
        local stronger = "You"

        for _,battler in ipairs(self.party) do
            Game.level_up_count = Game.level_up_count + 1
            battler.chara:onLevelUp(Game.level_up_count)

            if battler.chara.id == Game:getConfig("growStrongerChara") then
                stronger = battler.chara:getName()
            end
        end

        earn_text = "* Ran away with " .. self.money .. " "..Game:getConfig("darkCurrencyShort")..".\n* "..stronger.." became stronger."

        Assets.playSound("dtrans_lw", 0.7, 2)
        --scr_levelup()
    end
    
    local flee_text = "* "
    
    local flee_list = {
        "I'm outta here.",
        "I've got better to do.",
        "Escaped...",
        "Don't slow me down."
    }
    
    for _,battler in pairs(Game.battle.party) do
        for _,text in pairs(battler.chara:getFleeText()) do
            table.insert(flee_list, text)
        end
    end
    
    if earn_text == "" then
        flee_text = flee_text .. Utils.pick(flee_list)
    else
        flee_text = earn_text
    end
    
    self:battleText(flee_text, function()
        for _,battler in ipairs(self.party) do
            battler:getActiveSprite().run_away_2 = false
            battler.x = battler.x - 240
        end
        self:setState("TRANSITIONOUT")
        self.encounter:onBattleEnd()
        return true
    end)
end

return Battle
