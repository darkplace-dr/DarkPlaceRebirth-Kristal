---@class FilePath : Class
---@overload fun(base_path: string, relative_path: string) : FilePath
local FilePath, super = Class(nil, "FilePath")

---@param base_path string
---@param relative_path string
function FilePath:init(base_path, relative_path)
    self.base_path = base_path
    self.relative_path = relative_path
    self.full_path = self.base_path .. "/" .. self.relative_path
    
    local identifier, extension = unpack(StringUtils.splitFast(self.relative_path, "."))
    assert(identifier)
    extension = extension or ""
    self.identifier, self.extension = identifier, extension
end

return FilePath
