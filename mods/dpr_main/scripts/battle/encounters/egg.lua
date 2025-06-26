local Egg, super = Class(Encounter)

function Egg:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* The air hatches with freedom."

    -- Battle music ("battle" is rude buster)
    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "knight"
        -- Enables the purple grid battle background
        self.background = false
    end

    -- Add the Egg enemy to the encounter
    self:addEnemy("egg", 450, 244)
end

function Egg:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end

    local eggs = Sprite("battle/egg_background", 0, 0)
    local gradient = Sprite("battle/gradient_background", 0, 0)
    local handu = Sprite("battle/enemies/egg/handu", 0, 0)
    local chain = Sprite("battle/enemies/egg/chain", 0, 10)
    local chain2 = Sprite("battle/enemies/egg/chain", 0, 310)
    chain.wrap_texture_x = true
    chain.physics.speed_x = 2
    chain2.wrap_texture_x = true
    chain2.physics.speed_x = 2
    eggs.wrap_texture_x = true
    eggs.wrap_texture_y = true
    eggs.physics.speed_x = 2
    eggs.physics.speed_y = 3
    eggs.layer = BATTLE_LAYERS["below_battlers"]
    gradient.layer = BATTLE_LAYERS["bottom"]
    handu.layer = BATTLE_LAYERS["below_battlers"]
    chain.layer = BATTLE_LAYERS["below_battlers"]
    chain2.layer = BATTLE_LAYERS["below_battlers"]
    eggs.alpha = 1
    handu.wrap_texture_x = true
    handu.physics.speed_x = -2
    Game.battle:addChild(eggs)
    Game.battle:addChild(gradient)
    Game.battle:addChild(handu)
    Game.battle:addChild(chain)
    Game.battle:addChild(chain2)
    eggs:addFX(ShaderFX("cyl", {squishiness = 1, squish_softening = 0.04, center_y = 0}))
    handu:addFX(ShaderFX("cyl", {squishiness = 1, squish_softening = 0.04, center_y = 0}))
    chain:addFX(ShaderFX("cyl", {squishiness = 1, squish_softening = 0.04, center_y = 0}))
    chain2:addFX(ShaderFX("cyl", {squishiness = 1, squish_softening = 0.04, center_y = 0}))
end

function Egg:onReturnToWorld(events)
    -- check whether the enemies were killed
    if Game.battle.killed then
        -- run this code for each event in the table
        for _,event in ipairs(events) do
            for _,event in ipairs(event:getGroupedEnemies(true)) do
                -- set a 'dont_load' flag to true for the event,
                -- which is a special flag that will prevent the event from loading
                event:setFlag("dont_load", true)
            end
        end
    end
end

return Egg