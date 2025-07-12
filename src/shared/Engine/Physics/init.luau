local Physics2D: Physics2D = { } :: Physics2D
Physics2D.__index = Physics2D

local Simulation = require(script.Simulation)

local Types = require(script.Types)

Physics2D.Simulation = Simulation

local camera = workspace.CurrentCamera

export type Physics2D = Types.Physics2D
export type BaseClass = Types.BaseClass

local function getObjectRotatedVertices(size: Vector2, position: Vector2, rot: number): { Vector2 }
    local screenCenter = camera.ViewportSize / 2
    local objectCenter = screenCenter + position

    local rotation = math.rad(-rot)

    local halfWidth = size.X / 2
    local halfHeight = size.Y / 2

    local cosTheta = math.cos(rotation)
    local sinTheta = math.sin(rotation)

    local corners = {
        Vector2.new(-halfWidth, -halfHeight),
        Vector2.new(halfWidth, -halfHeight),
        Vector2.new(halfWidth, halfHeight),
        Vector2.new(-halfWidth, halfHeight),
    }

    local rotatedVertices = {}
    for _, corner in ipairs(corners) do
        local rotatedX = corner.X * cosTheta - corner.Y * sinTheta
        local rotatedY = corner.X * sinTheta + corner.Y * cosTheta
        local rotatedPos = Vector2.new(rotatedX, rotatedY) + objectCenter
        table.insert(rotatedVertices, rotatedPos)
    end

    return rotatedVertices
end

function Physics2D.getVertices(position: Vector2, size: Vector2, rotation: number): { Vector2 }
    return getObjectRotatedVertices(size, position, rotation)
end

function Physics2D:UpdateVertices(preRenderPosition: Vector2?, preRenderSize: Vector2?, preRenderRotation: number?)
    local objectInstance = self._ref.Instance

    self._size = preRenderSize or objectInstance.AbsoluteSize
    self._position = preRenderPosition or objectInstance.AbsolutePosition
    self._rotation = preRenderRotation or objectInstance.AbsoluteRotation

    self._vertices = getObjectRotatedVertices(self._position, self._size, self._rotation)
end

function Physics2D.new(gameObject: BaseClass, debugObject: boolean?): Physics2D
    local objectId = gameObject._id
    local objectInstance = gameObject.Instance

    print(gameObject)

    assert(type(objectId) == "string", "Object ID must be a string")
    assert(typeof(objectInstance) == "Instance" and objectInstance:IsA("GuiObject"), "Object instance must be a GuiObject")

    local physicsObject = setmetatable({
        _ref = gameObject,
        _id = objectId,
        _debugObject = debugObject or false,

        _verticesFrames = { }
    }, Physics2D)

    Simulation:AddObject(physicsObject)

    warn("Physics2D object created with ID:", physicsObject)

    return physicsObject
end

return table.freeze(Physics2D) :: Physics2D
