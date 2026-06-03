local DialogueText, super = HookSystem.hookScript(DialogueText)

function DialogueText:init(text, x, y, w, h, options)
    options = options or {}
    self.default_sound = options["default_sound"] or "default"
    self.no_sound_overlap = options["no_sound_overlap"] or false
    if options["no_sound_overlap"] == nil and Game.battle and Game.battle.light then
        self.no_sound_overlap = true
    end

    super.init(self, text, x, y, w, h, options)
end

function DialogueText:resetState()
    super.resetState(self)
    self.state["typing_sound"] = self.default_sound
end

function DialogueText:playTextSound(current_node)
    if self:isSkipping() and (Input.down("cancel") and Kristal.getLibConfig("magical-glass", "undertale_text_skipping") ~= true or self.played_first_sound) then
        return
    end

    if current_node.type ~= "character" then
        return
    end

    local no_sound = { "\n", " ", "^", "!", ".", "?", ",", ":", "/", "\\", "|", "*" }

    if (TableUtils.contains(no_sound, current_node.character)) then
        return
    end

    if (self.state.typing_sound ~= nil) and (self.state.typing_sound ~= "") then
        self.played_first_sound = true
        if Kristal.callEvent(KRISTAL_EVENT.onTextSound, self.state.typing_sound, current_node, self.state) then
            return
        end
        if self:getActor()
        and (self:getActor():getVoice() or "default") == self.state.typing_sound
        and self:getActor():onTextSound(current_node, self.state) then
            return
        end

        if not self.no_sound_overlap then
            Assets.playSound("voice/" .. self.state.typing_sound)
        else
            Assets.stopAndPlaySound("voice/" .. self.state.typing_sound)
        end
    end
end

function DialogueText:skip()
    if Kristal.getLibConfig("magical-glass", "undertale_text_skipping") ~= true or Input.pressed("cancel") then
        super.skip(self)
    end
end

function DialogueText:skipHeld()
    if Kristal.getLibConfig("magical-glass", "undertale_text_skipping") == true then
        return Input.down("cancel")
    end
    return super.skipHeld(self)
end

return DialogueText