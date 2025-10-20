local farm_tile, super = Class(Event)

local function h(hex)
    return {tonumber(string.sub(hex, 2, 3), 16)/255, tonumber(string.sub(hex, 4, 5), 16)/255, tonumber(string.sub(hex, 6, 7), 16)/255, value or 1}
end

function farm_tile:init(data)
    super.init(self, data.center_x, data.center_y, {data.width, data.height})

    self:setOrigin(0.5, 0.5)
    self.tile = Sprite("world/events/minecraft_soil_b")
    self:addChild(self.tile)
    self.tile:setScale(2)
    self.hitbox = {0, 0, 20, 20}
    self.solid = false
end

function farm_tile:postLoad()
    self.plant = self:getFlag("planted")
    if self.plant then
        if self.plant[1] == "banana" then
            self.crop = Sprite("kristal/banana")
            self:addChild(self.crop)
            self.crop:setScale(2)

            self.crop:setOrigin(0.5, 0.5)
            self.crop.x, self.crop.y = 21, 10
            self.crop:play(1/8, true)
            self:bananaCheck(true)
        end
    end
end

function farm_tile:onInteract()
    Game.world:startCutscene(function(cutscene)

    if not self.plant then
        cutscene:text("* There's loose soil here.")
    end

    if not self.plant and Game.inventory:hasItem("banana") then --TODO: unhardcode this and add more plants
        cutscene:text("* Plant something?")
        local option = cutscene:choicer({"Yes", "No"})
        if option == 1 then
            local time = Game.playtime + 10 --(60*24)
            self:setFlag("planted", {"banana", time})
            Assets.playSound("item")
            Game.inventory:removeItem("banana")
            self:postLoad()
        end
    elseif self.plant then
        if not self.grown then
            cutscene:text("* The Banana is growing.")
        else
            cutscene:text("* The Banana has evolved into a Blue Java Banana.")
            cutscene:text("* Take it?")
            local option = cutscene:choicer({"Yes", "No"})
            if option == 1 then
                Game.inventory:addItem("blue_java")

                Assets.playSound("item")
                self.plant = nil
                self:setFlag("planted", nil)
                self.crop:remove()
                self.crop = nil
                self.grown = nil
            end
        end
    end
    end)
end

function farm_tile:update()
    super.update(self)
    if self.plant and not self.grown then
        self:bananaCheck()
    end
end

function farm_tile:bananaCheck(nosound)
    if not self.grown and Game.playtime > self.plant[2] then
        self.grown = true

    self.crop:addFX(PaletteFX({
        h '#f8d808',
        h '#f8ad08',
    }, {
        h '#08d8f8',
        h '#08adf8',
    }))

        if not nosound then
            Assets.playSound("barrel_jump", 0.6)
        end
    end
end

return farm_tile