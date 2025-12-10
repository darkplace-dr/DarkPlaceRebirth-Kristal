local RalseiChallengeController, super = Class(Object)

function RalseiChallengeController:init()
    super.init(self)

    self.camera_collider = nil
    
    local limit = {
        left = 160,
        right = 480,
        up = 100,
        down = 300
    }
    for i = 1, 16 do
        local x, y = Utils.random(limit.left, limit.right), Utils.random(limit.up, limit.down)
        self:addChild(CharacterWalker('ralseiimpostor', x, y, limit, true))
    end
    local x, y = Utils.random(limit.left, limit.right), Utils.random(limit.up, limit.down)
    self.ralsei_real = CharacterWalker('ralsei', x, y, limit)
    self:addChild(self.ralsei_real)
end

function RalseiChallengeController:update()
    super.update(self)

    local positions = {}
    local children = self.children
    for _, child in ipairs(children) do
        local x, y = child:getSortPosition()
        positions[child] = {x = x, y = y}
    end
    table.stable_sort(children, function(a, b)
        local a_pos, b_pos = positions[a], positions[b]
        local ax, ay = a_pos.x, a_pos.y
        local bx, by = b_pos.x, b_pos.y
        return a.layer < b.layer or
            (a.layer == b.layer and (math.floor(ay) < math.floor(by)))
    end)
end

function RalseiChallengeController:getCameraSpawn()
    return SCREEN_WIDTH / 2, 175
end

function RalseiChallengeController:checkSuccessAction()
    return false
end

function RalseiChallengeController:checkSuccessFinal()
    return self.camera_collider:collidesWith(self.ralsei_real.collider)
end

return RalseiChallengeController