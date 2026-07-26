local Bobberry1, super = Class(Wave)

function Bobberry1:init()
    super.init(self)

    self.time = 7
end

function Bobberry1:onStart()
	local attackers = self:getAttackers()

	-- this is dumb lmao
	-- holy shit if someone looks into this code
	-- it'l look like I had a stroke while writing this part
	self:setArenaShape({0, 3*142/6}, {1*142/6, 1*142/6}, {3*142/6, 0}, {5*142/6, 1*142/6}, {6*142/6, 3*142/6}, {5*142/6, 5*142/6}, {3*142/6, 6*142/6}, {1*142/6, 5*142/6})

	for i = 0, (#attackers * 4) - 1 do
		if #attackers < 3 then
			self:spawnBullet("orbitingbullet", -16, -16, i * (90 / #attackers), 3 - #attackers)
		else
			if i > 4 then
				self:spawnBullet("orbitingbullet", -16, -16, i * (90 / #attackers), 1)
			end
		end
	end
end

function Bobberry1:update()

    super.update(self)
end

return Bobberry1