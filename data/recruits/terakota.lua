local Terakota, super = Class(Recruit)

function Terakota:init()
    super.init(self)

    -- Display Name
    self.name = "Terakota"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 42

    -- Selection Display
    self.description = "An ancient armor that lives to\nprotect nature. Fears Green as\nsome kind of nature spirit."
    self.chapter = 5
    self.level = 47
    self.attack = 38
    self.defense = 46
    self.element = "PLANT:EARTH"
    self.like = "Floradinn"
    self.dislike = "Pointless combat"
    self.wish = "Nature preserve" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/terakota/attack", -3, -6, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Terakota
