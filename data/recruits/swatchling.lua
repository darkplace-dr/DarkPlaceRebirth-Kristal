local swatchling, super = Class(Recruit)

function swatchling:init()
    super.init(self)

    -- Display Name
    self.name = "Swatchling"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 5

    -- Organize the order that recruits show up in the recruit menu
    self.index = 15

    -- Selection Display
    self.description = "Colorful and dandy,\nyou can always count\non him to work hard."
    self.chapter = 2
    self.level = 9
    self.attack = 9
    self.defense = 9
    self.element = "COLOR"
    self.like = "Paint by Numbers"
    self.dislike = "Mixed Messages"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/swatchling/walk", -1, 0, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return swatchling