---@class Item.testdog : Item
local TestDog,super = Class(Item)

function TestDog:init()
    super.init(self)
    self.name = "TestDog"
    self.saved_item = "barkdurger"
    self.usable_in = "none"
end

function TestDog:getDescription()
    return "There was supposed to be a \""..(self.saved_item:gsub("_", " ")).."\" here, but instead it's just a dog."
end

function TestDog:onToss()
    Game.world:startCutscene(function (cutscene)
        cutscene:text("* Are you ABSOLUTELY sure?")
        local choice = cutscene:choicer({"Dogsposal", "Dog"})
        if choice == 1 then
            Game.inventory:removeItem(self)
        end
    end)
    return false
end

function TestDog:onLoad(data)
    self.saved_item = data.id
end

function TestDog:onSave(data)
    data.id = self.saved_item
end

return TestDog