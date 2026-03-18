---@class FilePath : Class
---@overload fun(base_path: string, relative_path: string) : FilePath
local FilePath, super = Class(nil, "FilePath")

function FilePath.splitExtension(path)
    local path_split = StringUtils.split(path, ".")
    assert(#path_split > 1, "Attempt to split path with no extension")
    local extension = path_split[#path_split]
    return table.concat(path_split, ".", 1, #path_split - 1), extension
end

---@param base_path string
---@param relative_path string
function FilePath:init(base_path, relative_path)
    self.base_path = base_path
    self.relative_path = relative_path
    self.full_path = self.base_path .. "/" .. self.relative_path

    local identifier, extension = FilePath.splitExtension(self.relative_path)
    extension = extension or ""
    self.identifier, self.extension = identifier, extension
end

return FilePath
