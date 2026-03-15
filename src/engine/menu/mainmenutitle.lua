---@class MainMenuTitle : StateClass
---
---@field menu MainMenu
---
---@field logo love.Image
---@field has_target_saves boolean
---
---@field options table
---@field selected_option number
---
---@overload fun(menu:MainMenu) : MainMenuTitle
local MainMenuTitle, super = Class(StateClass)

function MainMenuTitle:init(menu)
    self.menu = menu

	self.cont_alpha = 1

    self.debounce = false
end

function MainMenuTitle:update()
    -- Do nothing?
end

function MainMenuTitle:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

-------------------------------------------------------------------------------
-- Callbacks
-------------------------------------------------------------------------------

function MainMenuTitle:onEnter(old_state)
    self.menu.heart_target_x = -40
    self.menu.heart_target_y = -40
    if old_state == "NONE" then
        self.menu.heart.x = self.menu.heart_target_x
        self.menu.heart.y = self.menu.heart_target_y
    end

    self.cont_alpha = 1

    if self.kristal_stage_title then
        self.kristal_stage_title:remove()
    end

    self.menu.kristal_stage_title = TitleLogo(320, 180, self.menu.splash)
    MainMenu.stage:addChild(self.menu.kristal_stage_title)

    self.debounce = false
end

function MainMenuTitle:onKeyPressed(key, is_repeat)
    if Input.isConfirm(key) and not self.debounce then
        self.debounce = true
		MainMenu.stage.timer:tween(0.5, self, {cont_alpha = 0})
		MainMenu.stage.timer:tween(0.5, self.menu.kristal_stage_title, {x = 140, y = 90, scale_x = 0.5, scale_y = 0.5, fade = 0}, "out-quad", function()
			self.menu:setState("SUBTITLE")
		end)
	end
end

function MainMenuTitle:draw()
    love.graphics.setFont(Assets.getFont("small"))
    love.graphics.setColor(0, 0, 0, self.cont_alpha)
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", -2, 362, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 0, 362, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 2, 362, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 2, 360, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 2, 358, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 0, 358, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", -2, 358, SCREEN_WIDTH, "center")
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", -2, 360, SCREEN_WIDTH, "center")
	love.graphics.setColor(1, 1, 1, self.cont_alpha)
    love.graphics.printf("Press " .. Input.getText("confirm") .. " to continue", 0, 360, SCREEN_WIDTH, "center")

	love.graphics.setColor(1, 1, 1, 1)
end

return MainMenuTitle
