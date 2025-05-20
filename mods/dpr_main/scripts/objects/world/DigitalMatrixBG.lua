local DigitalMatrixBG, super = Class(Object)

-- Soul sprite used in the fountain sealing cutscene
function DigitalMatrixBG:init(x, y)
    self.font = Assets.getFont("ja_main")
    super.init(self, x, y)
	
	self.matrix_char = {}
	self.matrix_spawned = {}
	self.matrix_lifetime = {}
    for j = 1, 20 do
		self.matrix_char[j] = {}
		self.matrix_spawned[j] = {}
		self.matrix_lifetime[j] = {}
		for i = 1, 17 do
			self.matrix_lifetime[j][i] = 0
			self.matrix_char[j][i] = DigitalMatrixBG:getChar()
			self.matrix_spawned[j][i] = true
		end
	end
	local jrand = -1
	local lastjrand = -1
	for j = 1, 20 do
		jrand = Utils.pick({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}, function(value) return value ~= lastjrand end)
		lastjrand = jrand
		local lrand = love.math.random(255,300)
		for k = 0, 6 do
			self.matrix_lifetime[j][math.max(jrand-k,0)] = math.max(lrand-(50*k),0)
		end
		self.matrix_spawned[j][jrand] = false
	end
	self.matrix_time = 0
end

function DigitalMatrixBG:getChar()
	local chars = "０１２３４５６７８９ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ，．：；！？＂＇｀＾～￣＿＆＠＃％＋－＊＝＜＞（）［］｛｝｟｠｜￤／＼￢＄￡￠￦￥"
	local pos = love.math.random(1, 103)
	return Utils.sub(chars, pos, pos)
end

function DigitalMatrixBG:update()
	super.update(self)
	for j = 1, 20 do
		for i = 1, 17 do
			self.matrix_lifetime[j][i] = self.matrix_lifetime[j][i] - 2 * DTMULT
			if self.matrix_lifetime[j][i] < 0 then
				self.matrix_lifetime[j][i] = 0
			end
			if self.matrix_lifetime[j][i] <= 250 and self.matrix_spawned[j][i] == false then
				self.matrix_char[j][math.min(i+1,17)] = DigitalMatrixBG:getChar()
				self.matrix_lifetime[j][math.min(i+1,17)] = 300
				self.matrix_spawned[j][i] = true
				self.matrix_spawned[j][math.min(i+1,17)] = false
				if self.matrix_spawned[j][16] == false then
					self.matrix_lifetime[j][1] = 300
					self.matrix_spawned[j][1] = false
				end
				self.matrix_time = 0
			end
		end
	end
    self.matrix_time = self.matrix_time + 1 * DTMULT
end

function DigitalMatrixBG:draw()
    super.draw(self)
	love.graphics.setFont(self.font)
    for j = 1, 20 do
		for i = 1, 16 do
			if self.matrix_lifetime[j][i] > 0 then
				if self.matrix_lifetime[j][i] >= 150 then
					love.graphics.setColor(Utils.mergeColor(COLORS["white"], COLORS["green"], 1-((self.matrix_lifetime[j][i]-150)/150)))
				else
					love.graphics.setColor(Utils.mergeColor(COLORS["green"], COLORS["black"], 1-(self.matrix_lifetime[j][i]/150)))
				end
				love.graphics.print(self.matrix_char[j][i],(j-1)*32,(i-2)*32,0,1,1)
			end
		end
	end
end

return DigitalMatrixBG