local PushStone, super = Class(PushBlock, "stone")

function PushStone:init(data)
    super.init(self, data)
	
	properties = data.properties or {}

    self.default_sprite = properties and properties["sprite"] or sprite or "world/events/push_stone"
    self.solved_sprite = properties and properties["solvedsprite"] or properties["sprite"] or solved_sprite or sprite or "world/events/push_stone_solved"
	
	self:setSprite(self.default_sprite)
end

function PushStone:onInteract()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* It's a broken object...")
		if Game:getFlag("acj_quest_prog") and not Game:getFlag("acj_switch_pressed") then
			cutscene:text("* ...?[wait:10] There's a switch under it...")
			Assets.playSound("noise")
			Game.world.map:getTileLayer("TilesToRemove").visible = false
			Game.world.map:getTileLayer("AnotherLayerToRemove").visible = false
			Game.world.map:getHitbox("collision_to_remove").collidable = false
			cutscene:text("* Click!")
			Game:setFlag("acj_switch_pressed", true)
		end
	end)
end

return PushStone