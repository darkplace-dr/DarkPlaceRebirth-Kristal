local test_map, super = Class(Map)

function test_map:onEnter()
    super.onEnter(self)

end

function test_map:update()
    super.update(self)
end
return test_map
