local GreenSoul, super = Class(LightSoul)

function GreenSoul:init(x, y, undertale)
    super.init(self, x, y)

    self.undertale = undertale ~= false
    self.default_up_dir = self.undertale and math.rad(-90) or math.rad(270)
    
    if self.undertale then
        self.color = {0, 192 / 255, 0, 1}
        self.soul_origin_adjust_x = 0
        self.soul_origin_adjust_y = 0
    else
        self:setColor(0, 162 / 255, 0, 1)
        self.soul_origin_adjust_x = 1
        self.soul_origin_adjust_y = 1
    end
    
    self.facing = self.default_up_dir
    self.graze_collider.collidable = false

    self.diagonal = false
    self.wide_blocker = self.undertale

    -- turning
    self.turning_from = 0
    self.turning_left = 0
    self.turning_len = 3 / 30

    -- parrying
    self.enable_parry = not self.undertale
    self.parry_left = 0
    self.parry_len = 3 / 30
    self.parry_cooldown_left = 0
    self.parry_cooldown_len = nil
    if self.parry_cooldown_len then
        self.parry_cooldown_len = self.parry_cooldown_len / 30
    end

    self.blocker_offset_x = 0
    self.blocker_offset_y = 0
    self.parry_offset_from_x = 0
    self.parry_offset_from_y = 0

    -- crit window
    self.crit_window_left = 0
    self.crit_window_len_normal = 4 / 30
    self.crit_window_len_diagonal = 6 / 30
    self.enable_crit = not self.undertale

    -- transition to/from diagonal
    self.diagonal_transition_from_box_radius = self:calculateBoxRadius()
    self.diagonal_transition_from_side_len = self:calculateCardinalSideLength()
    self.diagonal_transition_from_blocker_po = nil
    self.diagonal_transition_from_blocker_scale = self:calculateBlockerScale()
    self.diagonal_transition_left = 0
    self.diagonal_transition_len = 10 / 30

    -- highlight red on a hit
    self.hit_flash_left = 0
    self.hit_flash_len = 3 / 30

    -- highlight white on a crit
    self.crit_flash_left = 0
    self.crit_flash_len = 3 / 30

    self.blocker = nil
    self.blocker_crit_overlay = nil
    if self.undertale then
        self:setBlockerSprite("effects/greensoul/spear_blocker")
    else
        self:setBlockerSprite("effects/greensoul/axe_blocker")
    end

    self.tp_gain_mult_regular = 0.3125
    self.tp_gain_mult_crit = 0.625
    self.block_wt_reduction = false
    self.blocker_collider_depth = 0.25
    self.clear_parry_cooldown_on_success = true

    self:updateMiscColliders()
end

function GreenSoul:setBlockerSprite(sprite_name)
    self.blocker_sprite = sprite_name

    if self.blocker then
        self.blocker:remove()
        self.blocker = self:createBlocker()
        self.blocker_crit_overlay = nil

        self.diagonal_transition_from_blocker_po = nil

        self.blocker_offset_x = 0
        self.blocker_offset_y = 0
        self.parry_left = 0
    end
end

function GreenSoul:setDiagonal(diagonal)
    if diagonal == self.diagonal then
        return
    end

    self.diagonal_transition_from_box_radius = self:calculateBoxRadius()
    self.diagonal_transition_from_side_len = self:calculateCardinalSideLength()

    if self.blocker then
        self.diagonal_transition_from_blocker_po = {
            x = self.blocker.x,
            y = self.blocker.y,
            bsox = self.blocker.scale_origin_x,
            bsoy = self.blocker.scale_origin_y,
            brox = self.blocker.rotation_origin_x,
            broy = self.blocker.rotation_origin_y
        }
        self.diagonal_transition_from_blocker_scale = {
            self.blocker.scale_x,
            self.blocker.scale_y
        }

        self:playModeChangeSound()
    end

    self.diagonal = diagonal
    self.diagonal_transition_left = self.diagonal_transition_len
end

function GreenSoul:setWideBlockerHitbox(wide)
    if wide == self.wide_blocker then
        return
    end

    self.wide_blocker = wide

    if self.blocker then
        self.blocker:remove()
        self.blocker = self:createBlocker()
        self.blocker_crit_overlay = nil

        self.diagonal_transition_from_blocker_po = nil

        self.blocker_offset_x = 0
        self.blocker_offset_y = 0
        self.parry_left = 0
    end
end

function GreenSoul:calculateBoxRadius()
    if self.diagonal and not self.undertale then
        return 33
    else
        return 28
    end
end

function GreenSoul:calculateCardinalSideLength()
    if self.diagonal then
        return 32
    else
        return self:calculateBoxRadius()
    end
end

function GreenSoul:calculateDiagonalSideLength()
    local box_radius = self:calculateBoxRadius()
    local side_len_ch = self:calculateCardinalSideLength() / 2

    local p1 = {side_len_ch, -box_radius}
    local p2 = {box_radius, -side_len_ch}
    local dx = p2[1] - p1[1]
    local dy = p2[2] - p1[2]
    return math.sqrt((dx * dx) + (dy * dy))
end

function GreenSoul:calculateBlockerPosInfo()
    local box_radius = self:calculateBoxRadius()
    local blocker_sprite = Assets.getTexture(self.blocker_sprite)

    local soul_origin_x = self.soul_origin_adjust_x
    local soul_origin_y = self.soul_origin_adjust_y
    local right_edge = soul_origin_x + box_radius + 4
    local left_edge = right_edge - blocker_sprite:getWidth()
    local top_edge = soul_origin_y - (blocker_sprite:getHeight() / 2)

    if not self.diagonal then
        top_edge = top_edge - 1
    else
        top_edge = top_edge + 1
    end

    local blocker_origin_x = soul_origin_x - left_edge
    local blocker_origin_y = soul_origin_y - top_edge

    return {
        x = left_edge,
        y = top_edge,
        ox = blocker_origin_x,
        oy = blocker_origin_y,
        right_edge = right_edge,
        sox = soul_origin_x,
        soy = soul_origin_y
    }
end

function GreenSoul:calculateBlockerScale()
    if self.diagonal then
        if self.wide_blocker then
            return {1, 1}
        else
            return {1, 36 / 55}
        end
    else
        return {1, 1}
    end
end

function GreenSoul:createBlocker()
    local blocker_sprite = Assets.getTexture(self.blocker_sprite)

    local posInfo = self:calculateBlockerPosInfo()
    local blocker = Sprite(blocker_sprite)
    Game.battle:addChild(blocker)

    blocker:setLayer(LIGHT_BATTLE_LAYERS["above_arena_border"])
    blocker.draw_children_above = 1

    blocker:setRotationOriginExact(posInfo.ox, posInfo.oy)
    blocker:setScaleOriginExact(posInfo.ox, posInfo.oy)

    blocker.physics.match_rotation = true

    local blockerScale = self:calculateBlockerScale()
    blocker:setScale(blockerScale[1], blockerScale[2])

    blocker.collider = self:createBlockerCollider(blocker, posInfo)
    self:updateLaneColliders(blocker, posInfo)

    self.circle = Sprite("effects/greensoul/circle")
    self.circle:setLayer(blocker:getLayer() + 0.5)
    self.circle:setOrigin(0.5)
    if self.undertale then
        Game.battle:addChild(self.circle)
    end

    return blocker
end

function GreenSoul:createBlockerCollider(parent, posInfo, depth, breadth)
    depth = depth or self.blocker_collider_depth
    breadth = breadth or 1

    local box_radius = self:calculateBoxRadius() + 7
    local blocker_origin_x = posInfo.ox
    local blocker_origin_y = posInfo.oy

    local front_points = nil
    local side_len_ch = self:calculateCardinalSideLength() / 2

    if self.diagonal then
        local side_len_half = math.min(side_len_ch, self:calculateDiagonalSideLength())
        front_points = {
            {blocker_origin_x + box_radius, blocker_origin_y - side_len_half * breadth},
            {blocker_origin_x + box_radius, blocker_origin_y + side_len_half * breadth}
        }

        if self.wide_blocker then
            if breadth ~= 1 then
                front_points[1][2] = front_points[1][2] + side_len_half * breadth - side_len_half
                front_points[2][2] = front_points[2][2] - side_len_half * breadth + side_len_half
            end

            local breadth_offset = side_len_half * (1 - breadth) * 0.5
            table.insert(front_points, 1, {
                blocker_origin_x + side_len_ch + breadth_offset,
                blocker_origin_y - box_radius + breadth_offset
            })
            table.insert(front_points, 4, {
                blocker_origin_x + side_len_ch + breadth_offset,
                blocker_origin_y + box_radius - breadth_offset
            })
        end
    else
        front_points = {
            {blocker_origin_x + box_radius, blocker_origin_y - box_radius * breadth},
            {blocker_origin_x + box_radius, blocker_origin_y + box_radius * breadth}
        }
    end

    local points = {}
    for _, pt in ipairs(front_points) do
        table.insert(points, pt)
    end
    for _, pt in ipairs(front_points) do
        table.insert(points, #front_points + 1, {
            Utils.lerp(blocker_origin_x, pt[1], 1 - depth),
            Utils.lerp(blocker_origin_y, pt[2], 1 - depth)
        })
    end

    return PolygonCollider(parent, points)
end

function GreenSoul:updateLaneColliders(blocker, posInfo)
    blocker.ffr_lane_colliders = self:createBlockerCollider(blocker, posInfo, 1, 0.25)
end

function GreenSoul:updateMiscColliders()
    local box_verts = self:calculateBoxVertices()
    local box_verts_packed = {}

    for i = 1, #box_verts, 2 do
        table.insert(box_verts_packed, {box_verts[i], box_verts[i + 1]})
    end
end

function GreenSoul:onRemove(parent)
    if self.blocker then
        self.blocker:remove()
    end
    if self.circle then
        self.circle:remove()
    end
    
    super.onRemove(self, parent)
end

function GreenSoul:update()
    if self.transitioning then
        if self.blocker then
            self.blocker:remove()
            self.blocker = nil
            self.blocker_crit_overlay = nil
            for _, particle in ipairs(Game.stage:getObjects(GreenSoulCritParticle)) do
                particle:remove()
            end
        end
        if self.circle then
            self.circle:remove()
            self.circle = nil
        end

        self.crit_flash_left = 0
        self.hit_flash_left = 0
        self.parry_cooldown_left = 0

        self.blocker_offset_x = 0
        self.blocker_offset_y = 0
        self.parry_left = 0

        self.facing = self.default_up_dir

        super.update(self)
        return
    end

    if self.blocker == nil then
        self.blocker = self:createBlocker()
        self:playTurnSound()
    end

    if self.hit_flash_left > 0 then
        self.hit_flash_left = self.hit_flash_left - (1 * DT)
        self.blocker:setSprite(self.blocker_sprite .. "_hit")
    else
        self.blocker:setSprite(self.blocker_sprite)
    end

    if self.crit_flash_left > 0 then
        self.crit_flash_left = self.crit_flash_left - (1 * DT)

        if self.blocker_crit_overlay == nil then
            self.blocker_crit_overlay = Sprite(self.blocker_sprite .. "_crit", 0, 0)
            self.blocker:addChild(self.blocker_crit_overlay)
            self.blocker_crit_overlay:setLayer(1)
        end

        self.blocker_crit_overlay.alpha = Utils.ease(
            1, 0,
            1 - (self.crit_flash_left / self.crit_flash_len),
            "inQuad"
        )
    else
        if self.blocker_crit_overlay then
            self.blocker_crit_overlay.alpha = 0
        end
    end

    local is_critical = false

    if self.turning_left > 0 then
        self.turning_left = self.turning_left - (1 * DT)

        local ease_from = self.turning_from
        local alt_ease_from_lo = self.turning_from - math.rad(360)
        local alt_ease_from_hi = self.turning_from + math.rad(360)

        if math.abs(self.facing - alt_ease_from_lo) < math.abs(self.facing - ease_from) then
            ease_from = alt_ease_from_lo
        end
        if math.abs(self.facing - alt_ease_from_hi) < math.abs(self.facing - ease_from) then
            ease_from = alt_ease_from_hi
        end

        self.blocker.rotation = Utils.ease(
            ease_from,
            self.facing,
            1 - (self.turning_left / self.turning_len),
            "outQuad"
        )
    else
        self.blocker.rotation = self.facing
    end

    if self.parry_left > 0 then
        self.parry_left = self.parry_left - DT
        local ease_t = 1 - (self.parry_left / self.parry_len)

        self.blocker_offset_x = Utils.ease(self.parry_offset_from_x, 0, ease_t, "linear")
        self.blocker_offset_y = Utils.ease(self.parry_offset_from_y, 0, ease_t, "linear")

        if self.parry_left <= 0 then
            self.blocker_offset_x = 0
            self.blocker_offset_y = 0
        end
    end

    if self.parry_cooldown_left > 0 then
        self.parry_cooldown_left = self.parry_cooldown_left - DT
    end

    if self.crit_window_left > 0 and self.enable_crit then
        self.crit_window_left = self.crit_window_left - DT
        is_critical = true
    end

    if self.diagonal_transition_left > 0 then
        self.diagonal_transition_left = self.diagonal_transition_left - (1 * DT)
        local ease_t = 1 - (self.diagonal_transition_left / self.diagonal_transition_len)

        if self.blocker then
            local ease_scale_from = self.diagonal_transition_from_blocker_scale
            local ease_scale_to = self:calculateBlockerScale()
            local scale_x = Utils.ease(ease_scale_from[1], ease_scale_to[1], ease_t, "inQuad")
            local scale_y = Utils.ease(ease_scale_from[2], ease_scale_to[2], ease_t, "inQuad")
            self.blocker:setScale(scale_x, scale_y)

            local posInfo_to = self:calculateBlockerPosInfo()
            local x, y = self:getRelativePos()
            posInfo_to.x, posInfo_to.y = posInfo_to.x + x, posInfo_to.y + y

            if self.diagonal_transition_from_blocker_po then
                local posInfo_from = self.diagonal_transition_from_blocker_po

                local x = Utils.ease(posInfo_from.x, posInfo_to.x, ease_t, "inQuad")
                local y = Utils.ease(posInfo_from.y, posInfo_to.y, ease_t, "inQuad")
                self.blocker.x = x
                self.blocker.y = y

                local brox = Utils.ease(posInfo_from.brox, posInfo_to.ox, ease_t, "inQuad")
                local broy = Utils.ease(posInfo_from.broy, posInfo_to.oy, ease_t, "inQuad")
                self.blocker:setRotationOriginExact(brox, broy)

                local bsox = Utils.ease(posInfo_from.bsox, posInfo_to.ox, ease_t, "inQuad")
                local bsoy = Utils.ease(posInfo_from.bsoy, posInfo_to.oy, ease_t, "inQuad")
                self.blocker:setScaleOriginExact(bsox, bsoy)
            end

            if not (self.diagonal_transition_left > 0) then
                self.blocker.collider = self:createBlockerCollider(self.blocker, posInfo_to)
                self:updateLaneColliders(self.blocker, posInfo_to)
                self:updateMiscColliders()

                if self.diagonal_transition_from_blocker_po then
                    self.blocker.x = posInfo_to.x
                    self.blocker.y = posInfo_to.y
                    self.diagonal_transition_from_blocker_po = nil
                end
            end
        end
    end

    local blocked_bullets = {}
    Object.startCache()
    for _, bullet in ipairs(Game.stage:getObjects(Bullet)) do
        if bullet:collidesWith(self.blocker.collider) then
            table.insert(blocked_bullets, bullet)
        end
    end
    Object.endCache()

    for _, bullet in ipairs(blocked_bullets) do
        local preventDefault = bullet:onGreenDeflect(is_critical)
        if not preventDefault then
            self.hit_flash_left = self.hit_flash_len
            if is_critical then
                self.crit_flash_left = self.crit_flash_len
                for i = 1, 3 do
                    local pxr = self.blocker.rotation + math.rad(MathUtils.round(MathUtils.random(-30, 30)))
                    local px = 36 * math.cos(pxr)
                    local pyr = self.blocker.rotation + math.rad(MathUtils.round(MathUtils.random(-30, 30)))
                    local py = 36 * math.sin(pyr)
                    local p = GreenSoulCritParticle(px, py)
                    p.physics.direction = self.blocker.rotation
                    self:addChild(p)
                end

                if self.parry_cooldown_len
                    and self.parry_cooldown_left > 0
                    and self.clear_parry_cooldown_on_success
                then
                    self.parry_cooldown_left = 0
                end
            end

            if bullet:canGraze() then
                local tp_mult = self.tp_gain_mult_regular
                if is_critical then
                    tp_mult = self.tp_gain_mult_crit
                end
                Game:giveTension(bullet:getGrazeTension() * self.graze_tp_factor * tp_mult)
                if self.block_wt_reduction and Game.battle.wave_timer < Game.battle.wave_length - (1 / 3) then
                    Game.battle.wave_timer = Game.battle.wave_timer + ((bullet.time_bonus / 30) * self.graze_time_factor * tp_mult)
                end
            end
        end
    end
    
    local posInfo = self:calculateBlockerPosInfo()

    if self.blocker then
        local bx, by = self:getRelativePos(posInfo.x, posInfo.y)
        self.blocker:setPosition(bx + self.blocker_offset_x, by + self.blocker_offset_y)
    end

    if self.circle then
        self.circle:setPosition(self:getRelativePos())
    end

    super.update(self)
end

function GreenSoul:doMovement()
    self.moving_x = 0
    self.moving_y = 0

    if self.transitioning then
        return
    end
    
    local target_dir = self.facing

    if Input.pressed("right") or (self.diagonal and Input.down("right") and (Input.released("up") or Input.released("down"))) then
        target_dir = self.undertale and math.rad(0) or math.rad(360)
        if self.diagonal then
            if Input.down("up") then
                target_dir = target_dir - math.rad(45)
            elseif Input.down("down") then
                target_dir = target_dir + math.rad(45)
            end
        end
    elseif Input.pressed("down") or (self.diagonal and Input.down("down") and (Input.released("left") or Input.released("right"))) then
        target_dir = math.rad(90)
        if self.diagonal then
            if Input.down("left") then
                target_dir = target_dir + math.rad(45)
            elseif Input.down("right") then
                target_dir = target_dir - math.rad(45)
            end
        end
    elseif Input.pressed("left") or (self.diagonal and Input.down("left") and (Input.released("up") or Input.released("down"))) then
        target_dir = math.rad(180)
        if self.diagonal then
            if Input.down("up") then
                target_dir = target_dir + math.rad(45)
            elseif Input.down("down") then
                target_dir = target_dir - math.rad(45)
            end
        end
    elseif Input.pressed("up") or (self.diagonal and Input.down("up") and (Input.released("left") or Input.released("right"))) then
        target_dir = self.default_up_dir -- math.rad(270) | math.rad(-90)
        if self.diagonal then
            if Input.down("left") then
                target_dir = target_dir - math.rad(45)
            elseif Input.down("right") then
                target_dir = target_dir + math.rad(45)
            end
        end
    end

    local refill_crit_window = false

    if target_dir ~= self.facing then
        if self.blocker then
            self.turning_from = self.blocker.rotation
        end
        self.facing = target_dir
        self.turning_left = self.turning_len

        self:playTurnSound()
        refill_crit_window = true

    elseif self.enable_parry
        and (Input.pressed("up") or Input.pressed("down") or Input.pressed("left") or Input.pressed("right"))
        and not (self.parry_cooldown_left > 0)
    then
        self.parry_left = self.parry_len

        local parry_dist_px = 2
        local ox = parry_dist_px * math.cos(-self.facing)
        local oy = -parry_dist_px * math.sin(-self.facing)

        self.parry_offset_from_x = ox
        self.parry_offset_from_y = oy

        self.blocker_offset_x = ox
        self.blocker_offset_y = oy

        if self.parry_cooldown_len then
            self.parry_cooldown_left = self.parry_cooldown_len + self.parry_len
        end

        self:playTurnSound()
        refill_crit_window = true
    end

    if refill_crit_window then
        if target_dir % math.rad(45) ~= 0 then
            self.crit_window_left = self.crit_window_len_diagonal
        else
            self.crit_window_left = self.crit_window_len_normal
        end
    end
end

function GreenSoul:playModeChangeSound()
    if not self.undertale then
        Assets.playSound("jump")
    end
end

function GreenSoul:playTurnSound()
    if not self.undertale then
        Assets.playSound("wing")
    end
end

function GreenSoul:calculateBoxVertices()
    local vertices = nil
    local box_radius = self:calculateBoxRadius()

    if self.diagonal or self.diagonal_transition_left > 0 then
        local side_len_ch = self:calculateCardinalSideLength() / 2

        if not self.diagonal then
            box_radius = self.diagonal_transition_from_box_radius
            side_len_ch = self.diagonal_transition_from_side_len / 2
        end

        vertices = {
            -side_len_ch + self.soul_origin_adjust_x, -box_radius + self.soul_origin_adjust_y,
             side_len_ch + self.soul_origin_adjust_x, -box_radius + self.soul_origin_adjust_y,

             box_radius + self.soul_origin_adjust_x, -side_len_ch + self.soul_origin_adjust_y,
             box_radius + self.soul_origin_adjust_x,  side_len_ch + self.soul_origin_adjust_y,

             side_len_ch + self.soul_origin_adjust_x,  box_radius + self.soul_origin_adjust_y,
            -side_len_ch + self.soul_origin_adjust_x,  box_radius + self.soul_origin_adjust_y,

            -box_radius + self.soul_origin_adjust_x,  side_len_ch + self.soul_origin_adjust_y,
            -box_radius + self.soul_origin_adjust_x, -side_len_ch + self.soul_origin_adjust_y
        }

        if self.diagonal_transition_left > 0 then
            local ease_t = 1 - (self.diagonal_transition_left / self.diagonal_transition_len)
            local mode = "inQuad"
            local from_box_radius = self.diagonal_transition_from_box_radius

            if not self.diagonal then
                ease_t = 1 - ease_t
                mode = "outQuad"
                from_box_radius = self:calculateBoxRadius()
            end

            local ease_from = {
                -from_box_radius + self.soul_origin_adjust_x, -from_box_radius + self.soul_origin_adjust_y,
                 from_box_radius + self.soul_origin_adjust_x, -from_box_radius + self.soul_origin_adjust_y,
                 from_box_radius + self.soul_origin_adjust_x, -from_box_radius + self.soul_origin_adjust_y,
                 from_box_radius + self.soul_origin_adjust_x,  from_box_radius + self.soul_origin_adjust_y,
                 from_box_radius + self.soul_origin_adjust_x,  from_box_radius + self.soul_origin_adjust_y,
                -from_box_radius + self.soul_origin_adjust_x,  from_box_radius + self.soul_origin_adjust_y,
                -from_box_radius + self.soul_origin_adjust_x,  from_box_radius + self.soul_origin_adjust_y,
                -from_box_radius + self.soul_origin_adjust_x, -from_box_radius + self.soul_origin_adjust_y
            }

            for i = 1, #vertices do
                vertices[i] = Utils.ease(ease_from[i], vertices[i], ease_t, mode)
            end
        end
    else
        vertices = {
            -box_radius + self.soul_origin_adjust_x, -box_radius + self.soul_origin_adjust_y,
            -box_radius + self.soul_origin_adjust_x,  box_radius + self.soul_origin_adjust_y,
             box_radius + self.soul_origin_adjust_x,  box_radius + self.soul_origin_adjust_y,
             box_radius + self.soul_origin_adjust_x, -box_radius + self.soul_origin_adjust_y
        }
    end

    return vertices
end

function GreenSoul:draw()
    Object.draw(self)

    if not self.transitioning then
        local vertices = self:calculateBoxVertices()
        if not self.undertale then
            love.graphics.setLineWidth(1)
            Draw.setColor(0, 128 / 255, 0, 1)
            love.graphics.polygon("line", vertices)
        end
    end

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)

        if self.blocker then
            if self.blocker.collidable then
                self.blocker.ffr_lane_colliders:drawFor(self, 0.6, 0.3, 0.6)
                self.blocker.collider:drawFor(self, 1, 0.5, 1)
            end
        end
    end
end

return GreenSoul