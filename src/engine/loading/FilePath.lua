---@class FilePath : Class
---@overload fun(base_path: string, full_path:string) : FilePath
local FilePath, super = Class(nil, "FilePath")

---@param base_path string
---@param full_path string
function FilePath:init(base_path, full_path)
    self.base_path = base_path
    self.full_path = full_path
    self.relative_path = full_path:sub(#(self.base_path)+2, -1)
    
    local identifier, extension = unpack(StringUtils.splitFast(self.relative_path, "."))
    assert(identifier)
    extension = extension or ""
    self.identifier, self.extension = identifier, extension
end

return FilePath
