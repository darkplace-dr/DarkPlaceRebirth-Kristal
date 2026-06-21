local PurpleSoul, super = Class(LightSoul)

function PurpleSoul:init(x, y)
    super.init(self, x, y)

    -- set the soul's color to purple
    self.color = {213 / 255, 53 / 255, 217 / 255, 1}

    -- create CircleColliders at the left and right of the soul to check if its on a string
    self.left_string_collider = CircleCollider(self, -14, 0, 5)
    self.right_string_collider = CircleCollider(self, 14, 0, 5)

    -- create LineColliders going up and down from the soul to search for possible strings it can move to (used in PurpleSoul:handleStringMovement())
    self.up_collider = LineCollider(self, 0, -4, 0, -480)
    self.down_collider = LineCollider(self, 0, 4, 0, 480)

    -- set a vertical offset so the soul is always 1 pixel higher
    self.y_offset = -1

    -- the current string the soul is on
    self.current_string = nil
    -- the string it should move to when moving strings
    self.target_string = nil
    -- movement variable for moving left and right, -1 tells it it should move left if it can and 1 is right, left and right colliders do need to be on the current string for their respective directions to work
    self.movement = 0
    -- the progress of the soul on its current string, the progress is a range between the string's bounds going from 0 (left bound) to 1 (right bound)
    self.progress = 0.5
    -- the speed the soul moves at
    self.movement_speed = 4
    -- the soul's state, used for logic stuff
    self.state = "ON_STRING" -- used states: ON_STRING, OUTSIDE_STRING, MOVING
    -- whether the progress will be limited from 0.05 to 0.95
    self.limit_progress = false

    -- these variables are set when the soul moves to another string, they're used to lerp the soul from their last position on a string to their new position on a string
    self.old_y = 0
    self.old_x = 0
    -- the new progress the player should be at on the new string when they move a string, idk why I called it percentage
    self.new_string_percentage = 0.5
    -- variable used as the alpha for the lerp moving the soul from one string to the other
    self.string_lerp = 0
    -- the direction the soul moves when moving a string, decided by the input the player uses, -1 is up and 1 is down
    self.dir = -1
    -- this is used later when the soul tries to find a suitable string to move to, it will try 3 times (3 frames in a row) before giving up
    self.tries = 3

    -- functions used to interchange the directions the player needs to press to move, if correctControlsForRotation is on the controls will change depending on the string's rotation
    self.down_equivalent_input = function()
        return Input.keyPressed("down")
    end
    self.up_equivalent_input = function()
        return Input.keyPressed("up")
    end
    self.left_equivalent_input = function()
        return Input.keyDown("left")
    end
    self.right_equivalent_input = function()
        return Input.keyDown("right")
    end
end

-- function that manages controls
function PurpleSoul:getMovementKeys()
    if self.current_string == nil then
        return
    end
    
    if self.current_string.rot % (math.pi * 2) >= math.rad(-45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("left")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("right")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(45 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(45 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("left")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("right")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(90 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(90 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("left")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("right")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("up")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("down")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(135 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(135 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("right")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("left")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(180 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(180 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("right")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("left")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(225 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(225 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("right")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("left")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(270 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(270 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("right")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("left")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("down")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("up")
        end
    elseif self.current_string.rot % (math.pi * 2) >= math.rad(315 - 45 / 2) and self.current_string.rot % (math.pi * 2) <= math.rad(315 + 45 / 2) then
        self.down_equivalent_input = function()
            return Input.keyPressed("down")
        end
        self.up_equivalent_input = function()
            return Input.keyPressed("up")
        end
        self.left_equivalent_input = function()
            return Input.keyDown("left")
        end
        self.right_equivalent_input = function()
            return Input.keyDown("right")
        end
    end
end

-- movement logic
function PurpleSoul:doMovement()
    -- move normally if not on a string
    if self.state == "OUTSIDE_STRING" then
        super.doMovement(self)
        
        return
    end
    
    -- if the soul is on the string
    if self.state == "ON_STRING" then
        -- if the soul's collider detects it's on the current string
        if self.collider:collidesWith(self.current_string.collider) then
            -- movement stuff
            if (self.right_string_collider:collidesWith(self.current_string) or not self.limit_progress and self.progress < 1) and self.movement == 1 then
                self.progress = MathUtils.clamp(self.progress + self.movement_speed / self.current_string.len * DTMULT, 0, 1)
                self.movement = 0
            end
            if (self.left_string_collider:collidesWith(self.current_string) or not self.limit_progress and self.progress > 0) and self.movement == -1 then
                self.progress = MathUtils.clamp(self.progress - self.movement_speed / self.current_string.len * DTMULT, 0, 1)
                self.movement = 0
            end
        end
    end
    
    -- if the soul is moving to another string
    if self.state == "MOVING" and self.target_string then
        -- movement stuff
        if self.progress < 1 and self.progress > 0 then
            self.new_string_percentage = MathUtils.clamp(
                self.new_string_percentage + self.movement_speed / self.target_string.len * self.movement * DTMULT,
                self.limit_progress and 0.05 or 0,
                self.limit_progress and 0.95 or 1
            )
            self.movement = 0
        end
    end
end

-- input logic
function PurpleSoul:handleInputs()
    -- call the getMovementKeys function
    self:getMovementKeys()

    -- if the soul is on a string
    if self.state == "ON_STRING" then
        -- left and right equivalent inputs (moving in a string)
        if not (self.right_equivalent_input() and self.left_equivalent_input()) then
            if self.right_equivalent_input() then
                self.movement = 1
            elseif self.left_equivalent_input() then
                self.movement = -1
            end
        end

        -- up and down equivalent inputs (moving between strings)
        if not (self.up_equivalent_input() and self.down_equivalent_input()) then
            if self.up_equivalent_input() then
                self.state = "MOVING"
                self.dir = -1
                self.movement = 0
                self.rotation = self.current_string.rot
            elseif self.down_equivalent_input() then
                self.state = "MOVING"
                self.dir = 1
                self.movement = 0
                self.rotation = self.current_string.rot
            end
        end
    end
    
    -- if the soul is moving to another string (the MOVING state is also used for 1-3 frames while it's searching for a new string)
    if self.state == "MOVING" then
        -- being able to move a bit left and right while moving strings
        if not (self.right_equivalent_input() and self.left_equivalent_input()) then
            if self.right_equivalent_input() then
                self.movement = 1
            elseif self.left_equivalent_input() then
                self.movement = -1
            end
        end
    end
end

function PurpleSoul:update()
    if not self.current_string and not self.target_string then
        self.state = "OUTSIDE_STRING"
    end
    
    super.update(self)
    
    -- if the soul doesn't have a string or is not on a string while not moving strings set its state to OUTSIDE_STRING
    if not self.current_string or ((not self.collider:collidesWith(self.current_string.collider)) and not self.state == "MOVING") then
        self.state = "OUTSIDE_STRING"
    end
    
    if self.transitioning then
        self.current_string = nil
        self.state = "OUTSIDE_STRING"
        return
    end

    -- call the functions that should go every frame
    self:handleInputs()
    self:handleStringMovement()

    -- if the soul is on a string and it has a current string (somehow doesn't happen sometimes?)
    if self.current_string and self.state == "ON_STRING" then
        -- sets the soul's position and rotation/sprite rotation/no rotation (depending on the config) to match the current string's
        local x, y = self.current_string:getPositionBetweenBounds(self.progress)
        self:setPosition(self.current_string.x + x, self.current_string.y + y + self.y_offset)
        self.rotation = self.current_string.rot
    end

    -- change its sprite's rotation to match the soul's rotation to make it look like it's not rotating 
    for _, sprite in ipairs(self.children) do
        sprite.rotation = -self.rotation
    end
end

-- get the the X location of a point on the end of a line that's l away from x in the direction of r
function PurpleSoul:lengthDirX(x, l, r)
    return x + l * math.cos(r)
end

-- get the the Y location of a point on the end of a line that's l away from y in the direction of r
function PurpleSoul:lengthDirY(y, l, r)
    return y + l * math.sin(r)
end

-- oh boy this is a long one, this function handles the string movment, finding the closest string to the soul in the direction it's moving and then moving it to the correct spot on the string
function PurpleSoul:handleStringMovement()
    -- if the state is MOVING but it hasn't found a suitable string to move to yet
    if self.state == "MOVING" and not self.target_string then
        -- set the soul's position to the correct position just in case
        local x, y = self.current_string:getPositionBetweenBounds(self.progress)
        self:setPosition(self.current_string.x + x, self.current_string.y + y + self.y_offset)

        -- set the soul's rotation/whatever to the correct rotation just in case
        self.rotation = self.current_string.rot

        -- setting up some local variables/functions for the longest collision check I've ever seen and made
        local potential_targets = {}
        local intersection_points = {}
        local closest_target_index = 0
        local closest_target_distance = math.huge
        local simplify = function(num)
            return MathUtils.round(num * 1000) / 1000
        end

        -- this check looks at all the strings and if they collide with the correct direction's collider (and aren't the current string) it checks where they collide with 
        -- it(or more like a line equivalent to it) and stores them and their intersection points in two tables
        for _, obj in ipairs(Game.battle.children) do
            if obj:includes(PurpleString) then
                if ((self.up_collider:collidesWith(obj.collider) and self.dir == -1) or (self.down_collider:collidesWith(obj.collider) and self.dir == 1)) and obj ~= self.current_string then
                    local a = (math.rad(270) + self.rotation) + ((self.dir == 1 and math.pi) or 0)
                    local intersection_x, intersection_y = Utils.getLineIntersect(
                        simplify(self:lengthDirX(self.x, 4, a)),
                        simplify(self:lengthDirY(self.y, 4, a)),
                        simplify(self:lengthDirX(self.x, 480, a)),
                        simplify(self:lengthDirY(self.y, 480, a)),
                        simplify(obj.x + obj.left_bound.x),
                        simplify(obj.y + obj.left_bound.y),
                        simplify(obj.x + obj.right_bound.x),
                        simplify(obj.y + obj.right_bound.y),
                        false,
                        true
                    )
                    if type(intersection_x) ~= "boolean" then
                        table.insert(potential_targets, obj)
                        table.insert(intersection_points, {intersection_x, intersection_y})
                    end
                end
            end
        end

        -- if there were no potential target strings found then try again the next frame until tries run out
        local continue_search = true

        if #potential_targets <= 0 then
            if self.tries <= 0 then
                self.state = "ON_STRING"
                return true
            else
                self.tries = self.tries - DTMULT
                continue_search = false
            end
        end

        -- if it did find at least one potential target then check the closest intersection point and put the string that matches to it as the target string, 
        -- as well as calculating the soul's new location based on it
        if continue_search then
            for k, intersection in ipairs(intersection_points) do
                if MathUtils.dist(self.x, self.y, intersection[1], intersection[2]) < closest_target_distance then
                    closest_target_index = k
                    closest_target_distance = MathUtils.dist(self.x, self.y, intersection[1], intersection[2])
                end
            end

            self.target_string = potential_targets[closest_target_index]
            self.new_string_percentage = self.target_string:getProgressFromLocation(
                intersection_points[closest_target_index][1],
                intersection_points[closest_target_index][2]
            )
            self.old_x = self.x
            self.old_y = self.y 
        end
    end
    
    -- if the state is MOVING and it does have a target (if it found one earlier)
    if self.state == "MOVING" and self.target_string then
        -- execute a lerp moving the player from their old position to the new position calculated from the new position set from the intersection point
        if self.string_lerp < 1 then
            local x, y = self.target_string:getPositionBetweenBounds(self.new_string_percentage)
            self.x = MathUtils.lerp(self.old_x, self.target_string.x + x, self.string_lerp)
            self.y = MathUtils.lerp(self.old_y, self.target_string.y + y + self.y_offset, self.string_lerp)
            self.string_lerp = math.min(1, self.string_lerp + DTMULT / 4)
        else
            self.current_string = self.target_string
            self.target_string = nil
            self.string_lerp = 0
            self.progress = self.new_string_percentage
            self.state = "ON_STRING"
        end
    end
end

-- draw debug stuff
function PurpleSoul:draw()
    super.draw(self)
    
    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
        self.graze_collider:draw(1, 1, 1, 0.33)
        self.left_string_collider:draw(1, 0, 1)
        self.right_string_collider:draw(1, 0, 1)
    end
end

return PurpleSoul