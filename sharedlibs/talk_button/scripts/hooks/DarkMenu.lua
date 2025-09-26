---@class DarkMenu
local DarkMenu, super = Class("DarkMenu", true)

function DarkMenu:addButtons()
    if Game.tutorial then
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

                local status, err = pcall(function()
                    Game.world:startCutscene("_talk", "main", Game.world.map.id, Game.party[1].id)
                end)
                if not status then
                    Game.world:startCutscene("_talk")
                end
            end
        })
        return
    end
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

                local status, err = pcall(function()
                    Game.world:startCutscene("_talk", "main", Game.world.map.id, Game.party[1].id)
                end)
                if not status then
                    Game.world:startCutscene("_talk")
                end
            end
        })
    end
    
    -- APM
	if Game:hasPartyMember("apm") then
		self:addButton({
			["state"]          = "APMMENU",
			["sprite"]         = Assets.getTexture("ui/menu/btn/apm"),
			["hovered_sprite"] = Assets.getTexture("ui/menu/btn/apm_h"),
			["desc_sprite"]    = Assets.getTexture("ui/menu/desc/apm"),
			["callback"]       = function()
				self.box = DarkAPMMenu()
				self.box.layer = -1
				self:addChild(self.box)

				self.ui_select:stop()
				self.ui_select:play()
			end
		})
	end

    -- BADGES
    if #Game.inventory:getStorage("badges") > 0 then
        self:addButton({
            ["state"]          = "BADGEMENU",
            ["sprite"]         = Assets.getTexture("ui/menu/btn/badge"),
            ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/badge_h"),
            ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/badge"),
            ["callback"]       = function()
                self.box = DarkBadgeMenu()
                self.box.layer = -1
                self:addChild(self.box)

                self.ui_select:stop()
                self.ui_select:play()
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