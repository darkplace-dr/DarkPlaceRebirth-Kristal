local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Evil horse."

    -- Battle music ("battle" is rude buster)
    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "horsesong"
        -- Enables the purple grid battle background
        self.background = true
    end

    -- Add the dummy enemy to the encounter
    self:addEnemy("horse")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")


end

function Dummy:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end
end



return Dummy