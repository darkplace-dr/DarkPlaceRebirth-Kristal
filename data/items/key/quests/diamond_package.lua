local item, super = Class(Item, "diamond_package")

function item:init()
    super.init(self)

    self.name = "DimondPack"
    self.use_name = nil

    self.type = "key"
    self.icon = nil

    self.effect = ""

    self.shop = ""

    self.description = "* A package built out of solid diamond."
    self.price = 0
    self.can_sell = false
    self.target = "none"
    self.usable_in = "world"
    self.result_item = nil
    self.instant = false
    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil
    self.can_equip = {}
    self.reactions = {}
end

function item:onWorldUse()
    local plr = Game.world.player
    local tag = "len"
    local lenParty = Game:getPartyMember(tag)
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* You tried to open the package,[wait:5] but...")
        cutscene:text("* ...[wait:5]nothing happened.")
        cutscene:text("* You would need to be some kind of giant to open this thing.")
        if plr.actor == lenParty.actor then
            cutscene:text("* (I could use my dark magic to open it...","neutral_opened",tag)
            cutscene:text("* (I may break it tho)","neutral_opened_b",tag)
            local c = cutscene:choicer({"Open it", "Do not"})
            if c == 2 then return end
            Assets.playSound("laz_c_len")
            cutscene:wait(1)
            -- TODO: Add a chance/LV variation to this
            local success = false
            if success then
                Assets.playSound("item")
                -- Uhh something else
            else
                Assets.playSound("hurt")
                cutscene:wait(0.2)
                Assets.playSound("break2")
                Game.inventory:removeItem(self)
                Game:setFlag("diamondPackageBroken", true)
                cutscene:wait(0.5)
                cutscene:text("* (...[wait:5] Oops)","nervous",tag)
            end
        end
    end)
end

return item