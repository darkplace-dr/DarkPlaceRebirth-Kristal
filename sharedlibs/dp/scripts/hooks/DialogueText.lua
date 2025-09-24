---@class DialogueText : DialogueText
local DialogueText, super = Utils.hookScript(DialogueText)

function DialogueText:init(text, x, y, w, h, options)
    super.init(self, text, x or 0, y or 0, w or SCREEN_WIDTH, h or SCREEN_HEIGHT, options)
	self.draw_children_below = 0 -- funnytext draws below the text
end

function DialogueText:processModifier(node, dry)
    super.processModifier(self, node, dry)
    if node.command == "funnytext" then
        self.state.typed_characters = self.state.typed_characters + 1
    end
end

return DialogueText