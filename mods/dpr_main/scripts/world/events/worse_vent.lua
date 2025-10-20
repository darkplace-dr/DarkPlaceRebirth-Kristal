---@class Event.worse_vent : Event
local WorseVent, super = Class( Event)

function WorseVent:init(...)
    super.init(self,...)
    -- self.solid = true
    self.collider = CircleCollider(self, self.width/2, self.height/2, self.width/2)
    
    self.walktime = 0.2
    self.waittime = .2
    self.arc_speed = 20
    self:setSprite("world/events/worse_vent")

    -- TODO: find a better way to do an ellipse collider
    self.sprite:setScale(2,3)
    self.sprite:setScaleOrigin(0,0.25)
    self:setScale(1,2/3)
end

function WorseVent:getCenter()
    return self.x + (self.width/2), self.y + (self.height/2)
end

function WorseVent:update()
    super.update(self)
    self.target_x, self.target_y = Game.world.map:getMarker(self.data.properties.target.id)
end

local function makeAdvancedWait(origWait)
    return function (seconds, ...)
        if type(seconds) == "function" then
            repeat origWait() until seconds(...)
        else
            origWait(seconds)
        end
    end
end

function WorseVent:onEnter(player)
    if not player:includes(Player) then return end
    if player.jumping or Game.world.player.state == "SLIDE" then return end
    if Game.world:hasCutscene() then return end
    -- Game.world:startCutscene("cliffside", "worse_vents", self)
    Game.world.timer:script(function (origWait)
        self:doFullJump(makeAdvancedWait(origWait))
    end)
end

---@param wait fun(in:function|number,...)
function WorseVent:doFullJump(wait)
    Game.world:detachFollowers()
    self.party = Utils.merge({Game.world.player}, Game.world.followers)
    for index, chara in ipairs(self.party) do
        Game.world.timer:script(function (nwait)
            self:doJump(makeAdvancedWait(nwait), chara, self.party[index+1])
        end)
        wait(self.waittime)
    end
    Game.world:attachFollowers()
end

function WorseVent:doJump(wait, chara, next_chara)
    local index = Utils.getIndex(self.party, chara)
    wait(function () return not chara.jumping end)
    for j in ipairs(self.party) do
        if j < index then goto continue end
        if j >= #self.party then goto continue end
        self.party[j+1]:walkTo(self.party[j].x, self.party[j].y, self.walktime)
        ::continue::
    end 
    local cx,cy = self:getCenter()
    wait(WorldCutscene.slideTo({moving_objects={}}, chara,cx,cy, 0.1))
    Assets.stopAndPlaySound("jump")
    -- chara:walkTo(self:getCenter())
    local distance = Utils.dist(chara.x,chara.y,self.target_x, self.target_y)
    wait(WorldCutscene:jumpTo(chara, self.target_x, self.target_y, 20, distance * 0.003, "jump_ball", "landed"))
    if chara:includes(Follower) then
        chara:interpolateHistory()
        chara:updateIndex()
        chara:returnToFollowing()
    end
    Assets.stopAndPlaySound("impact", 0.7)
    wait(self.walktime)
end

return WorseVent