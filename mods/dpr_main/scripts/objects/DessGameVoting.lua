local DessGameVoting, super = Class(Object)

function DessGameVoting:init()
	super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.data = {}
	for i,member in ipairs(Game.party) do
		self.data[member.id] = {
			agree = nil,
			head = Assets.getTexture(member.menu_icon),
			name = member.name,
			box = UIBox(0, 45, 0, 50),
			index = i,
			timerMove = nil
		}

		local data = self.data[member.id]
		local box = self.data[member.id].box

		box.width = data.head:getWidth()*2

		local center_x = (SCREEN_WIDTH/2)-25
		local spacing = box.width+200

	    local index = (#Game.party + 1) / 2
	    box.x = center_x + (i - index) * spacing

		self:addChild(box)
	end

	self.font = Assets.getFont("main_mono")

	self.top_text = "Destroy reality for shits and giggles?"
end

function DessGameVoting:setChoice(id, vote)
	if type(id) ~= "string" then
		id = id.party or id.id
	end
	print(id, vote, self.data[id])
	self.data[id].agree = vote
end

function DessGameVoting:getResults()
	local votes = 0
	for member,data in pairs(self.data) do
		votes = votes + (data.agree and 1 or -1)
	end
	return votes
end

function DessGameVoting:getNextIndex()
	local index = 0
	for member,data in pairs(self.data) do
		if data.index > index then
			index = data.index
		end
	end
	return index+1
end

function DessGameVoting:addVoter(member)
	if type(member) == "string" then
		member = Game:getPartyMember(member)
	end

	self.data[member.id] = {
		agree = nil,
		head = Assets.getTexture(member.menu_icon),
		name = member.name,
		box = UIBox(SCREEN_WIDTH, 45, 0, 50),
		index = self:getNextIndex(),
		timerMove = nil
	}

	for member,data in pairs(self.data) do
		if data.timeMove then
			Game.world.timer:cancel(data.timeMove)
			data.timeMove = nil
		end

		local box = data.box

		box.width = data.head:getWidth()*2

		local center_x = (SCREEN_WIDTH/2)-25
		local spacing = box.width+200

	    local index = (#self.data + 1) / 2
	    new_x = center_x + (data.index - index) * spacing
	    print(data.name, data.index, new_x)

	    data.timeMove = Game.world.timer:tween(1, box, {x=new_x}, "out-cubic", function()
	    	data.timeMove = nil
	    end)
	end
end

function DessGameVoting:getChoiceText(choice)
	if choice == true then
		return "O", COLORS.green
	elseif choice == false then
		return "X", COLORS.red
	end
	return "?", COLORS.grey
end

function DessGameVoting:draw()
	super.draw(self)

	love.graphics.setFont(self.font)
	for member,data in pairs(self.data) do
		Draw.setColor(COLORS.white)
		Draw.draw(data.head, data.box.x, data.box.y-10, 0, 2, 2)

		local icon, color = self:getChoiceText(data.agree)

		Draw.setColor(color)
		love.graphics.print(icon, data.box.x+(data.box.width/2-8), data.box.y+30)
	end
end

return DessGameVoting