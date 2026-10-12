local Shi, super = Class(Recruit)

function Shi:init()
    super.init(self)

    -- Display Name
    self.name = "Shi"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 4

    -- Organize the order that recruits show up in the recruit menu
    self.index = 37

    -- Selection Display
    self.description = "An immobile scarecrow who yells \nout the names of his special \nsuper hero attacks. He believes \nthey are famous, but only \nKawkaw is a fan. Idolizes \nYellow and Orange."
    self.chapter = 5
    self.level = 44
    self.attack = 40
    self.defense = 36
    self.element = "SCYTHE"
    self.like = "Showing his moves"
    self.dislike = "Kikky & Kawkaw"
    self.wish = "Stop pesticide use" -- not implemented yet

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = COLORS.yellow

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = { "recruits/shi/spare", -3, 10, 4 / 30 }

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Shi
