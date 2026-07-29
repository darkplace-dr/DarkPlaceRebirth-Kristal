local Friend, super = Class(Encounter)

function Friend:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Friend attacks."

    -- Battle music ("battle" is rude buster)
    self.music = "THE FRIENDOGENY"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("room3_friend")
	
	self.flee = false
end

return Friend
