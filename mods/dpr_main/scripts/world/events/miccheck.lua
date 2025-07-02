local MicCheck, super = Class(Event)

function MicCheck:init(data)
    super.init(self, data)

    self.solid = true

    self:setOrigin(0.5, 0.5)
    self:setSprite("world/events/savepoint", 1/6)

    properties = properties or {}

    self.text_once = properties["text_once"] or true
	self.nomic = false
	
	self.text = {"* (It's a mysterious microphone-shaped crystal.)", "* (Peering into the crystal ball,[wait:5] the thoughts of microphones cross your mind...)"}
end

function MicCheck:onInteract(player, dir)
	if Kristal.isConsole() then
		local result_text = ""
		local must_reassign = false
		local shoulder_r_bound = false
		local shoulder_l_bound = false
		for aliasname, lalias in pairs(Input.gamepad_bindings) do
			for keyindex, lkey in ipairs(lalias) do
				if Utils.equal(lkey, "gamepad:rightshoulder") then
					shoulder_r_bound = true
				end
				if Utils.equal(lkey, "gamepad:leftshoulder") then
					shoulder_l_bound = true
				end
			end
		end
		if shoulder_l_bound and shoulder_r_bound then
			must_reassign = true
		end
		if must_reassign then
			self.world:showText({"* (It's a mysterious microphone-shaped crystal.)", "* (The crystal vibrates intensely. Please reassign buttons set to [button:leftshoulder] or [button:rightshoulder]!)"})			
		else
			local button_text = "[button:rightshoulder]"
			if shoulder_r_bound then
				button_text = "[button:leftshoulder]"
			end
			self.world:showText({"* (It's a mysterious microphone-shaped crystal.)", "* (It's engraved with buttons shaped like "..button_text.." and the letters \"VOL\".)", "* (When pressed in,[wait:5] the whole room seems to make a noise...!)"})
		end
		self.nomic = true
	else
		self.nomic = false
		if self.text_once and Game:getFlag("mic_crystal_used", false) then
			self:onTextEnd()
			return
		end
		if self.text_once then
			Game:setFlag("mic_crystal_used", true)
		end

		super.onInteract(self, player, dir)
	end
	return true
end

function MicCheck:onTextEnd()
    if not self.world then return end

	if not self.nomic then
		Mod:openMicMenu()
	end
end

return MicCheck