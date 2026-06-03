local Slasher, super = Class(Wave)

function Slasher:init()
	super.init(self)
	
	self.time = 180/30
end

function Slasher:onStart()
    local attackers = self:getAttackers()
    for _, attacker in ipairs(attackers) do
        attacker.visible = false

		local attacker_x, attacker_y = attacker:getRelativePos(attacker.width, attacker.height)
		self:spawnBullet("rudinnranger/slasher", attacker_x + 5, attacker_y + 20)
	end
end

function Slasher:onEnd()
    for _, attacker in ipairs(self:getAttackers()) do
        attacker.visible = true
    end
end

return Slasher