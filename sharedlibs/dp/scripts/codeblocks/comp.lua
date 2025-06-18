---@class CodeBlock.comp : CodeBlock
local block, super = Class(CodeBlock, "comp")

function block:init()
    super.init(self)
    self.expr1 = DP:createCodeblock("safelua")
    self.expr1.value = "Game.battle.enemies[1].health"
    self.expr2 = DP:createCodeblock("safelua")
    self.expr2.value = "Game.battle.enemies[1].max_health"
    self.op = DP:createCodeblock("literal")
    self.op.value = "<"
    self.text = "[expr:expr1] [expr:op] [expr:expr2]"
end

function block:run(scope)
    local op = self.op:run(scope)
	local val1 = self.expr1:run(scope)
	local val2 = self.expr2:run(scope)
	
	if op == ">" then
		return val1 > val2
	elseif op == "<" then
		return val1 < val2
	elseif op == ">=" then
		return val1 >= val2
	elseif op == "<=" then
		return val1 <= val2
	elseif op == "==" then
		return val1 == val2
	elseif op == "~=" then
		return val1 ~= val2
	else
		error("Operator " .. op .. " not defined.")
	end
end

function block:onSave(data)
    data.expr1 = self.expr1 and self.expr1:save() or nil
    data.expr2 = self.expr2 and self.expr2:save() or nil
    data.op = self.op and self.op:save() or nil
end

function block:onLoad(data)
    if data.expr1 then
        self.expr1 = DP:createCodeblock(data.expr1.id, data.expr1)
    end
    if data.expr2 then
        self.expr2 = DP:createCodeblock(data.expr2.id, data.expr2)
    end
    if data.op then
        self.op = DP:createCodeblock(data.op.id, data.op)
    end
end

return block