---@class XSlashSpell: Object
---@overload fun(...): XSlashSpell
local XSlashSpell, super = Class(Object)

function XSlashSpell:init(user,target)
    super.init(self)
    self.user = user
    self.target = target
    ---@type fun(self: XSlashSpell, hit_action_command: boolean)
    self.damage_callback = function () end
    self.clock = -0.05
    self.antispam = 0
    self.action_command_timer = math.huge
    self.action_command_threshold = 0.2
    self.slashes_count = 2
    self.slash_flipped = false
    self.damage_delay = 0
end

function XSlashSpell:update()
    super.update(self)
    self.clock = self.clock + DT
    self.action_command_timer = self.action_command_timer + DT
    if Input.pressed("confirm") then
        self.antispam = self.antispam + 1
        self.action_command_timer = 0
    end
    if self.clock > 0 and self.slashes_count > 0 then
        self:generateSlash((self.slash_flipped) and -1 or 1)
        self.slash_flipped = not self.slash_flipped
        self.slashes_count = self.slashes_count - 1
        self.clock = self.clock - .5
        Game.battle.timer:after(self.damage_delay, function ()
            local hit_action_command = self.action_command_timer < self.action_command_threshold and self.antispam <= 2
            self.antispam = 0
            self:damage_callback(hit_action_command)
        end)
    elseif self.clock > 1 then
        self:remove()
        Game.battle:finishAction()
    end
end

function XSlashSpell:generateSlash(scale_x)
    local cutAnim = Sprite("effects/attack/cut")
    Assets.playSound("scytheburst")
    Assets.playSound("criticalswing", 1.2, 1.3)
    self.user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
    self.user:toggleOverlay(true)
    local afterimage1 = AfterImage(self.user, 0.5)
    local afterimage2 = AfterImage(self.user, 0.6)
    self.user:toggleOverlay(false)
    afterimage1.physics.speed_x = 2.5
    afterimage2.physics.speed_x = 5
    afterimage2:setLayer(afterimage1.layer - 1)
    self.user:setAnimation("battle/attack", function()
        self.user:setAnimation("battle/idle")
    end)
    self.user:flash()
    cutAnim:setOrigin(0.5, 0.5)
    cutAnim:setScale(2.5 * scale_x, 2.5)
    cutAnim:setPosition(self.target:getRelativePos(self.target.width/2, self.target.height/2))
    cutAnim.layer = self.target.layer + 0.01
    cutAnim:play(1/15, false, function(s) s:remove() end)
    self:addChild(cutAnim)
    self:addChild(afterimage1)
    self:addChild(afterimage2)
end

return XSlashSpell