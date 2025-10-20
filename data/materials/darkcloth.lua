local material, super = Class(Material, "darkcloth")

function material:init()
    super.init(self)

    self.name = "DarkCloth"
    self.plural = "DarkCloth"
    self.description = "Cloth woven from DarkStuffing.\nUsed to craft cloaks and scarves."

    self.rarity = 1
    self.icon = "materials/darkcloth"
end

return material