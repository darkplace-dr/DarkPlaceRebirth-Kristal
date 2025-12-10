local werewire, super = Class(Recruit)

function werewire:init()
    super.init(self)

    -- Display Name
    self.name = "Werewire"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 6

    -- Organize the order that recruits show up in the recruit menu
    self.index = 12

    -- Selection Display
    self.description = "It was controlled by Queen.\nBut, it's stronger and cooler \nnow, so?"
    self.chapter = 2
    self.level = 7
    self.attack = 8
    self.defense = 7
    self.element = "ELEC"
    self.like = "Shock Therapy"
    self.dislike = "Emotional Therapy"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/werewire/idle", 10, 5, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return werewire