local PauseOverlay, super = Class("PauseOverlay", "PauseOverlay")

function PauseOverlay:init()
    super.init(self)
    self.text:setText("Press "..Input.getText("pause").." to resume.")
    self.rect = Rectangle(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    self.rect:setColor(COLORS.black(0))
    self.rect:fadeTo(0.4,.3)
    self.rect:setLayer(-99999)
    self:addChild(self.rect)
    self.header = Text("PAUSE",0,0,nil,nil,{auto_size = true})
    self.header:setOrigin(.5,0)
    self.header:setScale(2)
    self.header:setPosition(310, 14)
    self:addChild(self.header)
    local advice = Utils.pick{
        "DID YOU KNOW?\nThis menu is stolen from Deltaruined",
    }
    self.cooladvice = Text(advice,314,149,SCREEN_WIDTH/2,nil)
    self:addChild(self.cooladvice)
end

function PauseOverlay:onAdd(parent)
    super.onAdd(self, parent)
    local msuics = nil
    do
        local ok, msuics_opts = pcall(modRequire, "scripts.jukebox_songs")
        if not ok then
            msuics_opts = {}
        end
        Utils.filterInPlace(msuics_opts, function (v) return Assets.getMusicPath(v.file) ~= nil end)
        Utils.filterInPlace(msuics_opts, function (v) return v.file ~= Game:getActiveMusic().current end)
        Utils.filterInPlace(msuics_opts, function (v) return (not v.flag) or (Game:getFlag(v.flag)) end)
        msuics = Utils.pick(msuics_opts)
    end
    if msuics then
        self.pause_music = self.pause_music or Music(msuics.file)
        self.pause_music:play()
        self.nowplaying = Text("Currently Playing:\n\""..(msuics.name).."\"\nBy "..msuics.composer.."\n"..msuics.origin)
        self.nowplaying:setPosition(0,249)
        self:addChild(self.nowplaying)
    end
end

function PauseOverlay:close()
    if self.pause_music then
        self.pause_music:remove()
        self.nowplaying:remove()
    end
    super.close(self)
end

return PauseOverlay