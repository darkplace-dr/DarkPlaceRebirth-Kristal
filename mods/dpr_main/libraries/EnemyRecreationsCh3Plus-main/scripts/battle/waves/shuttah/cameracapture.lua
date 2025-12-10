local CameraCapture, super = Class(Wave)

function CameraCapture:onStart()
    self.time = 8
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        attacker:setAnimation("pose")
    end

    if #attackers == #Game.battle.enemies then
        local bullet_wave = Utils.random(1, 3, 1)
        if bullet_wave == 1 then
            local black_bullets = {}
            local white_bullets = {}
            local function spawnDiamondBullet()
                local x = Utils.random(Game.battle.arena.left - 100, Game.battle.arena.right + 100)
                local y = Utils.random(Game.battle.arena.top - 20, Game.battle.arena.top - 70)
                local bullet = self:spawnBullet("shuttah/diamond_black", x, y)
                table.insert(black_bullets, bullet)
                self.timer:script(function(wait)
                    wait(1/3)
                    if bullet:isRemoved() then return end
                    bullet.targeting = false
                    bullet.graphics.grow = 0
                    wait(1/3)
                    if bullet:isRemoved() then return end
                    local bullet2 = self:spawnBullet("shuttah/diamond_white", bullet.x, bullet.y, bullet.rotation)
                    bullet2:setLayer(bullet.layer - 0.01)
                    table.insert(white_bullets, bullet2)
                    wait(1/4)
                    if bullet:isRemoved() then return end
                    bullet.graphics.grow = 0.2
                    bullet:fadeOutAndRemove(0.2)
                end)
            end

            spawnDiamondBullet()
            self.timer:every(8/30, spawnDiamondBullet, 9)

            self.timer:script(function(wait)
                wait(8 * 8/30 + 7/30)
                local x, y = self:getOriginPosition("corners", 20)
                local origin_x, origin_y = 0.5 + (x - Game.battle.arena.x) / 180, 0.5 + (y - Game.battle.arena.y) / 180

                local bullet = self:spawnBullet("shuttah/photobullet", x, y)
                bullet:setOrigin(origin_x, origin_y)
                bullet.rotation_per_second = -120
                bullet.rotation_windup = true

                wait(18/30) -- When the camera snaps
                for _, black_bullet in ipairs(black_bullets) do
                    black_bullet:remove()
                end

                for _, white_bullet in pairs(white_bullets) do
                    white_bullet:drop()
                end

                wait(24/30)

                spawnDiamondBullet()
                self.timer:every(2/3, spawnDiamondBullet)
            end)
        elseif bullet_wave == 2 then
            self.timer:every(6/30, function()
                local x, y = Game.battle.arena.x, 10
                local direction = math.rad(Utils.random(-35, 35) + 90)
                local speed = Utils.random(3, 8)
                self:spawnBullet("shuttah/waterdrop", x, y, direction, speed)
            end)

            self.timer:every(50/30, function()
                local x, y = Game.battle.arena.x, Game.battle.arena.y

                local bullet = self:spawnBullet("shuttah/photobullet", x, y)
                bullet.lifetime = 1
            end)
        elseif bullet_wave == 3 then
            local function spawnBullets()
                local side = Utils.random(1, 4, 1)
                local direction = math.rad(90 * (side - 1))
                local x, y = Game.battle.arena.x, Game.battle.arena.y
                local x_diff, y_diff = 0, 0
                local distance, diff = 60, 32
                if side == 1 then
                    y_diff = diff
                    x = Game.battle.arena.left - distance
                elseif side == 2 then
                    x_diff = diff
                    y = Game.battle.arena.top - distance
                elseif side == 3 then
                    y_diff = -diff
                    x = Game.battle.arena.right + distance
                elseif side == 4 then
                    x_diff = -diff
                    y = Game.battle.arena.bottom + distance
                end
                for i = -2, 2 do
                    self:spawnBullet("shuttah/waterdrop", x + x_diff * i, y + y_diff * i, direction, (2 + (i + 2) / 2) * 2/3)
                end
            end

            spawnBullets()
            self.timer:after(1, function()
                spawnBullets()
                self.timer:every(2, spawnBullets)
            end)
            
            self.timer:every(2, function()
                local x, y = self:getOriginPosition("corners", 75)

                local bullet = self:spawnBullet("shuttah/photobullet", x, y)
                bullet.lifetime = 1
                bullet.total_rotation = Utils.pick({-22.5, 22.5})
            end)
        end
    else
        local function snap()
            local x, y = self:getOriginPosition(40)

            local bullet = self:spawnBullet("shuttah/photobullet", x, y)
            bullet.lifetime = 1
            bullet.total_rotation = Utils.pick({-45, 45})
        end
        self.timer:after(1.5, function()
            snap()
            self.timer:every(3, snap)
        end)
    end
end

function CameraCapture:update()
    -- Code here gets called every frame
    super.update(self)
end

function CameraCapture:getOriginPosition(point_type, spacing_x, spacing_y)
    -- After watching some gameplay footage, it seems like Shuttah picks
    -- 1 point out of a total of 9 on the bullet board to set it as the origin
    -- with the points being evenly spaced on a 3x3 grid with the middle being
    -- in the center of the bullet board.
    if type(point_type) ~= 'string' then
        spacing_y = spacing_x
        spacing_x = point_type
    end
    spacing_y = spacing_y or spacing_x

    local points = {}
    for x = -1, 1 do
        for y = -1, 1 do
            if not (point_type == 'corners' and (x == 0 or y == 0)) then
                table.insert(points, {spacing_x * x + Game.battle.arena.x, spacing_y * y + Game.battle.arena.y})
            end
        end
    end
    return Utils.unpack(Utils.pick(points))
end

function CameraCapture:beforeEnd()
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        attacker:setAnimation("posereturn", function()
            if attacker:canSpare() then attacker:onSpareable()
            else attacker:setAnimation("idle") end
        end)
    end
end

return CameraCapture