---@class CameraClimbState: StateClass
local CameraClimbState, super = Class(StateClass, "CameraClimbState")

---@param camera Camera
function CameraClimbState:init(camera)
    super.init(self)
    self.camera = camera
end

function CameraClimbState:registerEvents(master)
    self:registerEvent("update", self.update)
end

function CameraClimbState:update()
    local cameralerpspeed = 0.16
    -- TODO: Support overriding lerpstrength like how
    -- gml_Object_obj_climb_kris_Step_0:1506 responds to obj_camera_nudger
    local tx, ty = self.camera:getTargetPosition()
    local cx, cy = self.camera:getPosition()

	if Game.world.player.onrotatingtower then
		self.camera.y = MathUtils.roundToMultiple(MathUtils.lerp(cy, ty, cameralerpspeed * DTMULT), 2)
	else
		self.camera:setPosition(
			MathUtils.roundToMultiple(MathUtils.lerp(cx, tx, cameralerpspeed * DTMULT), 2),
			MathUtils.roundToMultiple(MathUtils.lerp(cy, ty, cameralerpspeed * DTMULT), 2)
		)
	end
end

return CameraClimbState
