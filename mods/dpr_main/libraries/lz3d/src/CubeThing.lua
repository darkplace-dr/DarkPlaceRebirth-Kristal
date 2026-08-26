local Matrix4x4 = modRequire('libraries.lz3d.src.Matrix4x4')
local OBJLoader = modRequire("libraries.lz3d.src.OBJLoader")
local Transform3D = modRequire("libraries.lz3d.src.Transform3D")
local Graphics = modRequire("libraries.lz3d.src.Graphics")

---@class CubeThing: Object
---@overload fun(x: number, y:number): CubeThing
local CubeThing, super = Class(Object)

CubeThing.VertexFormat = {
    {"VertexPosition", "float", 3},
    {"VertexTexCoord", "float", 2},
    {"VertexNormal", "float", 3},
    {"VertexColor", "byte", 4},
}

function CubeThing:init(x,y)
    super.init(self, x, y)
    -- self.mesh = love.graphics.newMesh(CubeThing.VertexFormat, objloader(Mod.info.path .. "/cube2.obj"), "triangles")
    -- self.mesh = love.graphics.newMesh(CubeThing.VertexFormat, objloader(Mod.info.path .. "/teapot.obj"), "triangles")
    self.mesh = OBJLoader.meshFromFilePath(Mod.info.libs.lz3d.path .. "/teapot.obj", false, false)
end

local function stupidwave(t, a, b)
    -- return Utils.wave(t*math.pi, a, b)
    local sine = math.asin(math.sin(t * math.pi)) / math.pi
    return MathUtils.rangeMap(MathUtils.clamp(sine, -0.5, 0.5), -0.5, 0.5, a, b)
end

function CubeThing:fullDraw()
    love.graphics.push("all")
    love.graphics.setMeshCullMode("back")
    love.graphics.setFrontFaceWinding("cw")

    local transform3d = Transform3D(0, 0, 0)
    local time = Kristal.getTime()
    --time = 2892.299999998
    -- time = 1.1
    transform3d:setRotationY(time * 90)
    transform3d:setRotationX(00)
    transform3d:setX(self.x)
    transform3d:setY(self.y)
    transform3d:setScaleX(40)
    transform3d:setScaleY(-40)
    transform3d:setScaleZ(40)

    local viewtransform = Transform3D(Game.world.camera.x,Game.world.camera.y,0)

    local projection_matrix = (Matrix4x4():buildOrthographicProjection(
        SCREEN_WIDTH, -SCREEN_HEIGHT,
        -- 0.005 * (Input.getMousePosition() / SCREEN_WIDTH),
        -00050,
        0000050,
        nil ---@diagnostic disable-line: redundant-parameter
    ))
    projection_matrix:set(3, 2, projection_matrix:get(3, 2) + 0.005)


    Graphics.setProjectionMatrix(projection_matrix)

    Graphics.setObjectMatrix(transform3d:getMatrix())
    Graphics.setViewMatrix(viewtransform:getMatrix():inverse())

    love.graphics.setDepthMode("less", true)

    Draw.pushShader("debug/normal_view")
    -- Draw.pushShader("debug/depth_view", {depthbuffer = Graphics.depth_buffer})
    Draw.draw(self.mesh)
    Draw.popShader()

    love.graphics.setDepthMode()

    love.graphics.setWireframe(false)
    love.graphics.setPointSize(8)
    love.graphics.points(0,0)
    love.graphics.pop()
    if love.getVersion() >= 12 then
        love.graphics.resetProjection()
    end
end

return CubeThing
