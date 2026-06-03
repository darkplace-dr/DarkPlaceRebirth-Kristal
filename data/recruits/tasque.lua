local tasque, super = Class(Recruit)

function tasque:init()
    super.init(self)

    -- Display Name
    self.name = "Tasque"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 5

    -- Organize the order that recruits show up in the recruit menu
    self.index = 11

    -- Selection Display
    self.description = "This cat loves you!"
    self.chapter = 2
    self.level = 7
    self.attack = 8
    self.defense = 6
    self.element = "CAT:ELEC"
    self.like = "Cat Food"
    self.dislike = "Cat Food"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/tasque/idle_cafe", -3, 30, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return tasque