local ponman, super = Class(Recruit)

function ponman:init()
    super.init(self)

    -- Display Name
    self.name = "Ponman"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 0

    -- Organize the order that recruits show up in the recruit menu
    self.index = 3

    -- Selection Display
    self.description = "A simple organism that takes\nlife one square at a time."
    self.chapter = 1
    self.level = 3
    self.attack = 4
    self.defense = 5
    self.element = "ORDER"
    self.like = "Sleeping"
    self.dislike = "Moving Backwards"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {128/255,0,128/255,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/ponman/idle", 0, 12, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = true
end

return ponman