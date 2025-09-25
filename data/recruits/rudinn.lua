local rudinn, super = Class(Recruit)

function rudinn:init()
    super.init(self)

    -- Display Name
    self.name = "Rudinn"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 0

    -- Organize the order that recruits show up in the recruit menu
    self.index = 1

    -- Selection Display
    self.description = "Said to be someone's best friend,\nbut maybe not. Shine on,\nyou lazy diamond!"
    self.chapter = 1
    self.level = 2
    self.attack = 4
    self.defense = 5
    self.element = "JEWEL"
    self.like = "Shiny Things"
    self.dislike = "Effort"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {128/255,0,128/255,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/rudinn/idle", 0, 12, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = true
end

return rudinn