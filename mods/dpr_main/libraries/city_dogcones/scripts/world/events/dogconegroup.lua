local DogConeGroup, super = Class(Event)

function DogConeGroup:init(data)
    super.init(self, data)

    self:setOrigin(0, 0)
    self:setHitbox(0, 20, self.width, self.height - 20)
    self.interact_count = 0

    self.solid = false

    self.scissor_fx = ScissorFX(-40, -40, self.width+80, self.height+80)
    self:addFX(self.scissor_fx)

    self.cones = { }

    local pr = data["properties"]

    -- The number of frames spent transitioning between states (At 30 FPS)
    self.transition_frames      = pr["transition_speed"]        or 20
    -- The side from which the dogcones originate (i.e. where they will transition in from/out to), must be `"left"` or `"right"`
    self.cone_origin            = pr["cone_origin"]             or "left"
    -- The name of a flag checked on room load that determines the state of the cones. Takes priority over the internal `mystate` flag.
    self.flag                   = pr["flag"]                    or nil
    -- The state that the dogcones will start in.
    self.default_state          = pr["default_state"]           or false

    self:assertOrigin(self.cone_origin)

    self:createCones()
end

function DogConeGroup:onLoad()
    local options = {
        instant = true
    }

    local flag
    if self.flag then
        flag = Game:getFlag(self.flag, false)

    else
        flag = self:getFlag("mystate", nil)
        -- Use the default state if the object has never been loaded before
        if flag == nil then
            flag = self.default_state
            self:setFlag("mystate", flag)

        end

    end

    self:setConesState(flag, options)
end

function DogConeGroup:createCones()
    local width = math.floor(self.width / 40)
    local height = math.floor(self.height / 40)

    for _=1,width do
        for _=1,height do
            local cone = Sprite("world/events/dogcone")
            cone.x, cone.y = self:getInactiveConePosition(self.cone_origin)
            cone.debug_select = false
            self:addChild(cone)
            cone:setScale(2)
            table.insert(self.cones, cone)
        end
    end
end

function DogConeGroup:getActiveConePosition(index)
    return ((((index - 1) % math.floor(self.width / 40))) * 40) + 6,
    math.floor((index-1) / (self.width/40)) * 40
end

function DogConeGroup:getInactiveConePosition(origin)
    if origin == "left" then
        return -34, 0
    elseif origin == "right" then
        return self.width + 6, 0
    elseif origin == "top" then
        return 6, -20
    else
        return 6, self.height + 0
    end
end

---Changes the state that the dogcones are in, or does nothing if they are already in that state.
---@param state boolean|string  The state to change the dogcones to. Certain string values i.e. `active/inactive` and `on/off` are accepted as well as booleans.
---@param options table         A table of values that affect the state change. Valid options are: `instant`, `frames`, and `origin`.   
function DogConeGroup:setConesState(state, options)
    local old = self.solid
    local new

    local statedict = {
        open        = false ,
        closed      = true  ,
        inactive    = false ,
        active      = true  ,
        on          = true  ,
        off         = false ,
    }

    if type(state) == "string" then
        new = statedict[state]
    elseif type(state) == "boolean" then
        new = state
    end

    assert(type(new) == "boolean", "Attempt to set state to unexpected value '" .. tostring(new) .. "'")

    if old == new then return end

    options = options or {}

    local frames = options["frames"] or self.transition_frames

    local origin = options["origin"] or self.cone_origin
    self:assertOrigin(origin)

    local instant = options["instant"] or false


    for i, cone in ipairs(self.cones) do
        --- @diagnostic disable-next-line: unbalanced-assignments # it's fine dw
        local target_x, target_y = self:getInactiveConePosition(origin)
        if new then target_x, target_y = self:getActiveConePosition(i) end
        if instant then
            cone.x = target_x
            cone.y = target_y

        else
            cone:slideTo(target_x, target_y, frames/30)

        end
    end

    self.solid = new
    self:setFlag("mystate", new)
end

function DogConeGroup:onInteract(player, dir)
    if not self.solid then
        return false
    end

    self.interact_count = self.interact_count + 1

    if self.interact_count > 3 and math.random() < 1/8 then
        Assets.playSound("snd_pombark", 1, Utils.random(0.6, 1.6))
    else
        Assets.playSound("snd_pombark")
    end

    return true
end

---It's technically not necessary to check the origin format,
---and anything that isn't `"left"` would be treated as right,
---but this thought just horrifies me so I had to make sure
---that the code WILL get angry if you don't specify `"right"`.
---@param origin any
function DogConeGroup:assertOrigin(origin)
    assert(type(origin) == "string" and (origin == "left" or origin == "right" or origin == "top" or origin == "bottom"), "Cone group origin must be 'left' or 'right', but was '" .. origin .. "' instead.")
end

return DogConeGroup