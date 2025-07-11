local Physics2D: Physics2D = { } :: Physics2D
Physics2D.__index = Physics2D

local Simulation = require(script.Simulation)

local Types = require(script.Types)
export type Physics2D = Types.Physics2D

local function getObjectRotatedVertices(objectInstance: GuiObject): { Vector2 }
    local size = objectInstance.AbsoluteSize
    local position = objectInstance.AbsolutePosition
    local rotation = math.rad(objectInstance.AbsoluteRotation)

    local halfWidth = size.X / 2
    local halfHeight = size.Y / 2

    local cosTheta = math.cos(rotation)
    local sinTheta = math.sin(rotation)

    local vertices = {
        Vector2.new(-halfWidth, -halfHeight),
        Vector2.new(halfWidth, -halfHeight),
        Vector2.new(halfWidth, halfHeight),
        Vector2.new(-halfWidth, halfHeight),
    }

    for i = #vertices, 2, -1 do
        if (vertices[i] - vertices[i - 1]).Magnitude < 0.01 then
            table.remove(vertices, i)
        end
    end

    local rotatedVertices = { }
    for _, vertex in ipairs(vertices) do
        local rotatedX = vertex.X * cosTheta - vertex.Y * sinTheta
        local rotatedY = vertex.X * sinTheta + vertex.Y * cosTheta
        table.insert(rotatedVertices, Vector2.new(rotatedX + position.X + halfWidth, rotatedY + position.Y + halfHeight))
    end

    return rotatedVertices
end

local function createFramesForVerticies(verticies, parent): { Frame }
    local frames = { }
    for _, vertex in ipairs(verticies) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 5, 0, 5)
        frame.Position = UDim2.new(0, vertex.X, 0, vertex.Y)
        frame.BackgroundColor3 = Color3.new(1, 0, 0) -- Red color for visibility
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Parent = parent -- Assuming you want to parent it to the workspace
        table.insert(frames, frame)
    end

    return frames
end

function Physics2D:UpdateVertices()
    local objectInstance = self.Instance
    self._size = objectInstance.AbsoluteSize
    self._position = objectInstance.AbsolutePosition
    self._rotation = objectInstance.AbsoluteRotation
    self._vertices = getObjectRotatedVertices(objectInstance)

    if self._debugObject then
        for _, frame in ipairs(self._verticesFrames) do
            frame:Destroy() -- Clean up old frames
        end

        table.clear(self._verticesFrames)
        self._verticesFrames = createFramesForVerticies(self._vertices, objectInstance.Parent)
    end
end

function Physics2D.new(objectId: string, objectInstance: GuiObject, debugObject: boolean?): Physics2D
    assert(type(objectId) == "string", "Object ID must be a string")
    assert(typeof(objectInstance) == "Instance" and objectInstance:IsA("GuiObject"), "Object instance must be a GuiObject")

    local physicsObject = setmetatable({
        Instance = objectInstance,
        _id = objectId,
        _debugObject = debugObject or false,

        _verticesFrames = { }
    }, Physics2D)

    objectInstance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        physicsObject:UpdateVertices()
    end)

    objectInstance:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        physicsObject:UpdateVertices()
    end)

    objectInstance:GetPropertyChangedSignal("AbsoluteRotation"):Connect(function()
        physicsObject:UpdateVertices()
    end)

    physicsObject:UpdateVertices()

    Simulation:AddObject(physicsObject)

    warn("Physics2D object created with ID:", physicsObject)

    return physicsObject
end

return Physics2D