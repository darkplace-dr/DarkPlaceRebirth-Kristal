---@class DarkMenu
local DarkMenu, super = Class("DarkMenu", true)

function DarkMenu:getButtonSpacing()
    if #self.buttons <= 4 then
        return 105
    else
        return 105 - (#self.buttons * #self.buttons)
    end
end

function DarkMenu:addButtons()
    -- ITEM
    self:addButton({
        ["state"]          = "ITEMMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/item"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/item_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/item"),
        ["callback"]       = function()
            self.box = DarkItemMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- EQUIP
    self:addButton({
        ["state"]          = "EQUIPMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/equip"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/equip_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/equip"),
        ["callback"]       = function()
            self.box = DarkEquipMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- POWER
    self:addButton({
        ["state"]          = "POWERMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/power"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/power_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/power"),
        ["callback"]       = function()
            self.box = DarkPowerMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })
    --Only add if not alone(If the config is false)
    if (Kristal.getLibConfig("talk_button", "have_talk_when_alone") or #Game.world.followers > 0) then
        -- TALK
        self:addButton({
            ["state"]          = "TALK",
            ["sprite"]         = Assets.getTexture("ui/menu/btn/talk"),
            ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/talk_h"),
            ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/talk"),
            ["callback"]       = function()
                Input.clear("confirm")
                Game.world:closeMenu()

                self.ui_select:stop()
                self.ui_select:play()

                Game.world:startCutscene("_talk")
            end
        })
    end

    -- CONFIG
    self:addButton({
        ["state"]          = "CONFIGMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/config"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/config_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/config"),
        ["callback"]       = function()
            self.box = DarkConfigMenu()
            self.box.layer = -1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })
end

return DarkMenu