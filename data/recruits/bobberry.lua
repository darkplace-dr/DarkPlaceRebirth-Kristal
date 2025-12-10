local Bobberry, super = Class(Recruit)

function Bobberry:init()
    super.init(self)

    -- Display Name
    self.name = "Bobberry"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 6

    -- Organize the order that recruits show up in the recruit menu
    self.index = 40

    -- Selection Display
    self.description = "Once a usual Bob without a berry,\nnow Bob with a berry. But\neveryone just call them\n\"Bobberry\"."
    self.chapter = 99
    self.level = 5
    self.attack = 8
    self.defense = 0
    self.element = "BALL"
    self.like = "Berries"
    self.dislike = "Stealing"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {1,177/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/bobberry/idle", 0, 0, 1}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Bobberry