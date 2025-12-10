local rudinnranger, super = Class(Recruit)

function rudinnranger:init()
    super.init(self)

    -- Display Name
    self.name = "Rudinn Ranger"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 0

    -- Organize the order that recruits show up in the recruit menu
    self.index = 7

    -- Selection Display
    self.description = "Obsessed with ranger shows,\nit lets everyone know\nit's better than Rudinn."
    self.chapter = 1
    self.level = 5
    self.attack = 4
    self.defense = 5
    self.element = "JEWEL:BLADE"
    self.like = "Sucking Up"
    self.dislike = "Show Getting Taped Over"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {128/255,0,128/255,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/rudinnranger/idle", 0, 12, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = true
end

return rudinnranger