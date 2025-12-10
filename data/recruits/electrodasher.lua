local Electrodasher, super = Class(Recruit)

function Electrodasher:init()
    super.init(self)
    
    -- Display Name
    self.name = "Electrodasher"
    
    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 2
    
    -- Organize the order that recruits show up in the recruit menu
    self.index = 42
    
    -- Selection Display
    self.description = "Still a learner, it doesn't yet\nhave its license."
    self.chapter = 99
    self.level = 9
    self.attack = 9
    self.defense = 5
    self.element = "ELEC:CAR"
    self.like = "Going Fast"
    self.dislike = "Traffic Jams"
    
    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"
    
    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}
    
    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/electrodasher/idle", 0, 12, 4/30}
    
    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Electrodasher