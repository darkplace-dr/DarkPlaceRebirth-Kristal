local Elnina, super = Class(Recruit)

function Elnina:init()
    super.init(self)

    -- Display Name
    self.name = "Elnina"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 25

    -- Selection Display
    self.description = "The weather girl who really\n\"makes it rain.\" Like... with\nwater, though."
    self.chapter = 3
    self.level = 22
    self.attack = 21
    self.defense = 22
    self.element = "WATER:ICE"
    self.like = "Lanino"
    self.dislike = "Being Alone"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/elnina/idle_left", -3, 14}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Elnina