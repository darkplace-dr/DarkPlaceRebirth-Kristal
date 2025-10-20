local JekuGameOver, super = Class(GameOver)

function JekuGameOver:update()
	if ((self.timer >= 80) and (self.timer < 150)) then
        if Input.pressed("confirm") then
        	Input.clear("confirm")
            self.skipping = self.skipping + 1
        end
        if (self.skipping >= 4) then
        	Mod.jeku_memory["skipped_death"] = true
        	-- Those stupid 3 lines caused Jeku's memory to be saved
        	local shop = Registry.createShop("jeku_shop")
        	shop:onRemoveFromStage()
        	shop:remove()
            Game:loadQuick()
        end
    end
    super.update(self)
end

return JekuGameOver