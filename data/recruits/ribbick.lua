local Ribbick, super = Class(Recruit)

function Ribbick:init()
    super.init(self)

    -- Display Name
    self.name = "Ribbick"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 22

    -- Selection Display
    self.description = "A real dust... frog. Known to\nplay dirty, but loves to\nplay... dirty."
    self.chapter = 3
    self.level = 16
    self.attack = 15
    self.defense = 12
    self.element = "FROG:DUST"
    self.like = "Dusty Places"
    self.dislike = "Imposter"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/ribbick/idle", -3, 29, 1/8}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Ribbick