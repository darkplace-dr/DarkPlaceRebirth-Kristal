---@class DarkAPMMenu : Object
---@overload fun(...) : DarkAPMMenu
local DarkAPMMenu, super = Class(Object)

function DarkAPMMenu:init()
    super.init(self, 82, 112, 477, 277)

    self.draw_children_below = 0

    if #Game.party == 4 then
		self.y = self.y - 12
	end
    self.font = Assets.getFont("main")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    -- MAIN,
    self.state = "MAIN"

    self.currently_selected = 0
end

function DarkAPMMenu:onKeyPressed(key)
    
end

function DarkAPMMenu:update()
    if Input.pressed("cancel") then
        self.ui_cancel_small:stop()
        self.ui_cancel_small:play()
        Game.world.menu:closeBox()
        return
    end

    super.update(self)
end

function DarkAPMMenu:draw()
    
    super.draw(self)
end

return DarkAPMMenu
