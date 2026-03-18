local ProjectLoading = {}

function ProjectLoading:init()
end

function ProjectLoading:enter(from, after)
    self.stage = Stage()
    self.dog = LoadingDog()
    self.stage:addChild(self.dog)
    self.after = after
    self.finished_loading = false
end

function ProjectLoading:draw()
    self.stage:draw()
end

function ProjectLoading:update()
    if self.finished_loading then
        return
    end
    local bucket = Assets.getBucket("project")
    local loaded, total = bucket.assets_loaded, bucket.assets_total
    self.dog:setProgress(loaded / total)
    self.stage:update()
    if loaded >= total then
        self.after()
        self.finished_loading = true
    end
end

return ProjectLoading
