local Nazrin, super = Class(Event)

function Nazrin:init(data)
    super:init(self, data.center_x, data.center_y, data.width, data.height)

    self:setOrigin(0.5, 0.5)
    self:setSprite("nazrin")
    self.hitbox = {2, 17, 12, 10}
end

function Nazrin:onInteract()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* Pray to Nazrin to fuse your objects?")
        opinion = cutscene:choicer({"Yes", "No"}) == 1
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
                book = cutscene:choicer({"100 D$", "200 D$", "300 D$", "None"}, options)
                if book == 1 then
                    if Game.money >= 100 then
                        Game.money = Game.money - 100
                        cutscene:text("* ...")
                        cutscene:text("* No reaction")
                    else
                        cutscene:text("* You don't have enough D$...")
                    end
                end
                if book == 2 then
                    if Game.money >= 200 then
                        Game.money = Game.money - 200
                        cutscene:text("* ...")
                        cutscene:text("* You feel forgiven...")
                        Game:setFlag("nazrinpissed", false)
                    else
                        cutscene:text("* You don't have enough D$...")
                    end
                end
                if book == 3 then
                    if Game.money >= 300 then
                        Game.money = Game.money - 300
                        cutscene:text("* ...")
                        cutscene:text("* You feel forgiven...")
                        Game:setFlag("nazrinpissed", false)
                    else
                        cutscene:text("* You don't have enough D$...")
                    end
                end
                cutscene:hideShop()
            end
        end
    end)
end

return Nazrin