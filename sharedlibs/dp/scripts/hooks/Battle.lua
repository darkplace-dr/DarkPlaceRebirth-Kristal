---@class Battle : Battle
local Battle, super = Utils.hookScript(Battle)

function Battle:init()
    super.init(self)

    self.freeze_xp = 0

    self.killed = false

    self.superpower = false

    self.super_timer = 0
    
    -- Base pitch for the music to return to when not using timeslow.
    -- This must be changed along with music.pitch in order to correctly change the music's pitch.
    -- TODO: Relocate 
    self.music.basepitch = self.music.pitch

    if Game:getSoulPartyMember().pp > 0 then
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
end

function Battle:postInit(state, encounter)
    super.postInit(self, state, encounter)

    if Game.bossrush_encounters and not self.encounter.no_dojo_bg then
        self.dojobg = self:addChild(DojoBG())
    end
end

return Battle