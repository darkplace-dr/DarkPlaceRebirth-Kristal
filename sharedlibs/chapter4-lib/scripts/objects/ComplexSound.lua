local ComplexSound, super = Class()

function ComplexSound:init(lifetime, killall, killind)
	
	self.killall = killall ~= nil and killall or true
	self.killind = killind ~= nil and killind or false

	self.timer = 0;

	self.array_max = 11 -- GML bs I guess
	self.snd = {}
	self.pitch = {}
	self.delay = {}
	self.volume = {}
	self.looprate = {}
	self.playsnd = {}
	self.killsnd = {}
	for i=1,self.array_max do
	    self.snd[i] = nil;
	    self.pitch[i] = 1;
	    self.delay[i] = 0;
	    self.volume[i] = 1;
	    self.looprate[i] = -1;
	    self.playsnd[i] = 0;
	    self.killsnd[i] = false;
	end

	self.mastertime = 0;
	self.lifetime = lifetime or -1

	self.done = true
end

function ComplexSound:play()
	self.timer = 0;
	self.mastertime = 0;

	self.done = false
end

function ComplexSound:add(id, snd, pitch, volume, delay, looprate, killsnd)
	self.snd[id] = snd;
	self.pitch[id] = pitch or 1;
	self.delay[id] = delay or 0;
	self.volume[id] = volume or 1;
	self.looprate[id] = looprate or -1;
	self.killsnd[id] = killsnd or false;
end

function ComplexSound:update()
	if self.done then return end
	self.mastertime = self.mastertime + DTMULT
	self.timer = self.timer + DTMULT
	local count = #self.snd
	
	for i = 1, count do
		if self.looprate[i] ~= -1 then
			if MathUtils.round(self.timer) - self.delay[i] % self.looprate[i] == 0 then
				if self.snd[i] ~= -1 then
					if self.killsnd[i] then
						if self.playsnd[i] ~= 0 then
							Assets.stopSound(self.playsnd[i])
						else
							Assets.stopSound(self.snd[i])
						end
					end
					self.playsnd[i] = Assets.playSound(self.snd[i], self.volume[i], self.pitch[i])
				end
			end
		elseif MathUtils.round(self.timer) == 1 + self.delay[i] then
			if self.snd[i] ~= -1 then
				self.playsnd[i] = Assets.playSound(self.snd[i], self.volume[i], self.pitch[i])
			end
		end
	end
	if self.lifetime then
		if self.mastertime >= self.lifetime then
			self.done = true
		end
	end
	local lastdelay = 0
	local anyloop = 0
	local nothingplaying = true
	
	for i = 1, count do
		if self.snd[i] ~= -1 then
			nothingplaying = false
		end
		lastdelay = lastdelay + self.delay[i]
		if self.looprate ~= -1 then
			anyloop = true
		end
	end
	if not anyloop then
		if self.timer > lastdelay + 10 then
			local killme = true
			
			for i = 1, count do
				if self.playsnd[i] ~= 0 and self.playsnd[i]:isPlaying() then
					killme = false
				end
			end
			
			if killme then
				self.done = true
			end
		end
	end
	
	if nothingplaying then
		self.done = true
	end
end

return ComplexSound