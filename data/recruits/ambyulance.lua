local ambyulance, super = Class(Recruit)

function ambyulance:init()
    super.init(self)

    -- Display Name
    self.name = "Ambyu-Lance"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 4

    -- Organize the order that recruits show up in the recruit menu
    self.index = 9

    -- Selection Display
    self.description = "An aggressive antivirus.\nIt's not down with the sickness."
    self.chapter = 2
    self.level = 8
    self.attack = 8
    self.defense = 8
    self.element = "ORDER:ELEC"
    self.like = "Loud Sirens"
    self.dislike = "Funny Sound Effects"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/ambyulance/idle", -3, 13, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return ambyulance