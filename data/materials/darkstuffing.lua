local material, super = Class(Material, "darkstuffing")

function material:init()
    super.init(self)

    self.name = "DarkStuffing"
    self.plural = "DarkStuffing"
    self.description = "Stuffing for a training dummy.\nCan be woven into cloth."

    self.rarity = 1
    self.icon = "materials/darkstuffing"
end

return material