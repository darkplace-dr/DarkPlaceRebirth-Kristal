local werewerewire, super = Class(Recruit)

function werewerewire:init()
    super.init(self)

    -- Display Name
    self.name = "Werewerewire"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 16

    -- Selection Display
    self.description = "It absorbed the wire with\nfighting spirit.\nGets flustered easily."
    self.chapter = 2
    self.level = 14
    self.attack = 11
    self.defense = 11
    self.element = "ELEC:FIGHT"
    self.like = "Supercharged Fighting"
    self.dislike = "Interpersonal Relationships"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/werewerewire/idle", -3, 7, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return werewerewire