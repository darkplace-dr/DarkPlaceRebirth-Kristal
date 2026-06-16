local RankingHubSign, super = Class(Object)

function RankingHubSign:init(x, y, board, rank)
    super.init(self, x, y)
	self.board = board or nil
	self.rank = rank or nil
	self.txt = self.board and "BOARD " .. self.board or "PRESHOW"
	self.rank_txt = self.rank and self.rank .. "-RANK" or "NO RANK"
	self.main_font = Assets.getFont("main")
	self.pxwhite = Assets.getTexture("bubbles/fill")
end

function RankingHubSign:draw()
    super.draw(self)
	local margin = 4
	love.graphics.setFont(self.main_font)
	Draw.setColor(0, 0, 0, 0.5)
	Draw.draw(self.pxwhite, 10, 0, 0, 140, 68)
	Draw.setColor(1,1,1,1)
	local tx = 0
	local kern = 2
	local text_canvas = Draw.pushCanvas(self.main_font:getWidth(self.txt)/2+(kern * StringUtils.len(self.txt)), self.main_font:getHeight(self.txt)/2)
	for i = 1, StringUtils.len(self.txt) do
		local ch = StringUtils.sub(self.txt, i, i)
		love.graphics.print(ch, tx, 0, 0, 0.5, 0.5)
		tx = tx + self.main_font:getWidth(ch)/2
		tx = tx + kern
	end
	Draw.popCanvas()
	tx = -self.main_font:getWidth(StringUtils.sub(self.txt, 1, 1))/4
	for i = 1, StringUtils.len(self.txt) do
		local ch = StringUtils.sub(self.txt, i, i)
		local x_pos = 57 + tx
		local y_pos = margin + 10
		local current_text = ch
		Draw.setColor(ColorUtils.hexToRGB("#21277C"))
		love.graphics.print(current_text, x_pos + 2, y_pos + 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos - 2, y_pos - 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos, y_pos + 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos + 2, y_pos, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos, y_pos - 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos - 2, y_pos, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos + 2, y_pos - 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos - 2, y_pos + 1, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos + 2, y_pos + 2, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos - 2, y_pos - 2, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos, y_pos + 2, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos, y_pos - 2, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos + 2, y_pos - 2, 0, 0.5, 0.5)
		love.graphics.print(current_text, x_pos - 2, y_pos + 2, 0, 0.5, 0.5)
		tx = tx + self.main_font:getWidth(ch)/2
		tx = tx + kern
	end	
	Draw.setColor(1,1,1,1)
	local shader = Kristal.Shaders["GradientV"]
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(shader)
	shader:sendColor("from", COLORS.white)
	shader:sendColor("to", COLORS.yellow)
	Draw.draw(text_canvas, 57 - self.main_font:getWidth(StringUtils.sub(self.txt, 1, 1))/4, margin + 10)
	love.graphics.setShader(last_shader)
	local current_text = self.rank_txt
	local text_canvas_2 = Draw.pushCanvas(self.main_font:getWidth(self.rank_txt), self.main_font:getHeight(self.rank_txt))
	love.graphics.print(current_text, 0, 0, 0, 1, 1)
	Draw.popCanvas()
	local x_pos = 80
	x_pos = x_pos - self.main_font:getWidth(self.rank_txt)/2
	local y_pos = margin + 10 + 10
	Draw.setColor(ColorUtils.hexToRGB("#21277C"))
	love.graphics.print(current_text, x_pos + 2, y_pos + 2, 0, 1, 1)
	love.graphics.print(current_text, x_pos - 2, y_pos - 2, 0, 1, 1)
	love.graphics.print(current_text, x_pos, y_pos + 2, 0, 1, 1)
	love.graphics.print(current_text, x_pos + 2, y_pos, 0, 1, 1)
	love.graphics.print(current_text, x_pos, y_pos - 2, 0, 1, 1)
	love.graphics.print(current_text, x_pos - 2, y_pos, 0, 1, 1)
	love.graphics.print(current_text, x_pos + 2, y_pos - 2, 0, 1, 1)
	love.graphics.print(current_text, x_pos - 2, y_pos + 2, 0, 1, 1)
	Draw.setColor(1,1,1,1)
	local shader = Kristal.Shaders["GradientV"]
	local last_shader = love.graphics.getShader()
    love.graphics.setShader(shader)
    shader:sendColor("from", COLORS.white)
    shader:sendColor("to", COLORS.yellow)
	Draw.draw(text_canvas_2, x_pos, y_pos)
    love.graphics.setShader(last_shader)
	Draw.setColor(1,1,1,1)
end

return RankingHubSign