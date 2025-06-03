local Nazrin, super = Class(Event)

function Nazrin:init(data)
    super.init(self, data.center_x, data.center_y, {data.width, data.height})

    self:setOrigin(0.5, 0.5)
    self:setSprite("world/events/nazrin")
    self.hitbox = {2, 17, 12, 10}
end

function Nazrin:onInteract()
    Game.world:startCutscene(function(cutscene)

    local items_list = {
        {
            result = "peanut",
            item1 = "nut",
            item2 = "nut"
        },
        {
            result = "quadnut",
            item1 = "peanut",
            item2 = "peanut"
        },
    }
    Kristal.callEvent("setItemsList", items_list)


        cutscene:text("* Pray to Nazrin to fuse your objects?")
        local opinion = cutscene:choicer({"Yes", "No"}) == 1
        if opinion then
            if not Game:getFlag("nazrinpissed") then
                Game.world.timer:after(0, function()
                    Game.world:openMenu(FuseMenu())
                end)
            else
                cutscene:text("* Nazrin refuses.")
                cutscene:text("* She seems angry at you.")
                cutscene:showShop()
                cutscene:text("* Maybe you can donate D$?")
                local book = cutscene:choicer({"100 D$", "200 D$", "300 D$", "None"}, options)
                if book == 1 then
                    if Game.money >= 100 then
                        Game.money = Game.money - 100
                        cutscene:text("* ...")
                        cutscene:text("* No reaction")
                    else
                        cutscene:text("* You don't have enough D$...")
                    end
                else
                    local cost = (book == 2) and 200 or 300
                    if Game.money >= cost then
                        Game.money = Game.money - cost
                        cutscene:text("* ...")
                        cutscene:text("* You feel forgiven...")
                        Game:setFlag("nazrinpissed", false)
                    else
                        cutscene:text("* You don't have enough D$...")
                    end
                end
                cutscene:hideShop()
            end
        else
            cutscene:text("* You religion't.")
        end
    end)
end

return Nazrin