local mauswheel, super = Class(Recruit)

function mauswheel:init()
    super.init(self)

    -- Display Name
    self.name = "Mauswheel"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 18

    -- Selection Display
    self.description = "You recruited 3 big mice\nand you're stuck with it."
    self.chapter = 2
    self.level = 13
    self.attack = 10
    self.defense = 11
    self.element = "MOUSE:MOUSE:MOUSE"
    self.like = "Pretending To Be A Tire"
    self.dislike = "Losing Momentum"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/mauswheel/idle", 0, 0, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return mauswheel