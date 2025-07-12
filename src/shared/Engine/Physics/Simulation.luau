local Simulation: Simulation = { 
    Objects = { },
} :: Simulation

local Collision = require(script.Parent.Collisions)
local Gravity = require(script.Parent.Gravity)

local Types = require(script.Parent.Types)

local camera = workspace.CurrentCamera

Simulation.Collision = Collision

type Physics2D = Types.Physics2D
type BaseClass = Types.BaseClass
type Simulation = Types.Simulation

local function getScreenScale(): number
    local DEFAULT_SCREEN_SIZE = Vector2.new(1920, 1080)
    local viewportSize = camera.ViewportSize
    return math.min(viewportSize.X, viewportSize.Y) / DEFAULT_SCREEN_SIZE.Y
end

local function createIntersectionPoint(physicsObject: Physics2D, intersectionPosition: Vector2, normal: Vector2)
    if physicsObject._intersectionPoint ~= nil then
        physicsObject._intersectionPoint:Destroy()
        physicsObject._intersectionPoint = nil
    end

    local instance = physicsObject._ref.Instance
    if instance == nil or instance.Parent == nil then
        return
    end

    local frame = Instance.new("Frame")
    frame.Name = "IntersectionPoint"
    frame.Size = UDim2.fromOffset(10, 10)
    frame.Position = UDim2.new(0.5, intersectionPosition.X / 2 * getScreenScale() + normal.X, 0.5, intersectionPosition.Y / 2 * getScreenScale() - normal.Y) 
    frame.BackgroundColor3 = Color3.new(0, 1, 0.784314) -- Red color for intersection point
    frame.Parent = instance.Parent

    print(frame.Position)

    physicsObject._intersectionPoint = frame
end

local function getIntersectionFacePosition(physicsObject: Physics2D, intersectionPosition: Vector2, normal: Vector2): Vector2
    if physicsObject._intersectionPoint == nil then
        return Vector2.zero
    end
    
    local gameObject = physicsObject._ref
    local objectInstance = gameObject.Instance
    if objectInstance == nil then
        return Vector2.zero
    end

    local absoluteSize = objectInstance.AbsoluteSize :: Vector2
    local offset = (intersectionPosition - absoluteSize):Ceil()
  
    print("offset", offset)
    print("normal", normal)

    return Vector2.new(
        offset.X + normal.X, 
        -(offset.Y + normal.Y)
    )
end

function Simulation:AddObject(physicsObject: Physics2D)
    self.Objects[physicsObject._id] = physicsObject
end

function Simulation:RemoveObject(objectId: string)
    self.Objects[objectId] = nil
end

function Simulation.Stepped(_deltaTime: number)
    for _id, physicsObject in pairs(Simulation.Objects) do
        local gameObject = physicsObject._ref
        local objectInstance = gameObject.Instance
        if objectInstance == nil then
            continue
        end

        local gravityForce = Vector2.zero
        local newPosition = gameObject.Position
        if gameObject.Anchored == false then
            gravityForce = Gravity(
                10, 
                workspace.Gravity, 
                Vector2.zero
            )

            newPosition += gravityForce * _deltaTime
        else
           -- continue
        end

        physicsObject:UpdateVertices(newPosition, gameObject.Size, gameObject.Rotation)

        local didCollide = false
        for _, otherObject in pairs(Simulation.Objects) do
            if otherObject._id ~= physicsObject._id and otherObject._ref.Instance then
                local overlapQueryResult = Collision.Polygon(
                    physicsObject._vertices, 
                    otherObject._vertices
                )

                if physicsObject._intersectionPoint ~= nil then
                    physicsObject._intersectionPoint:Destroy()
                    physicsObject._intersectionPoint = nil
                end
      
                if overlapQueryResult.collided == false then
                    continue
                end

                for idxA, vertexA in ipairs(physicsObject._vertices) do
                    for idxB, vertexB in ipairs(otherObject._vertices) do
                        local nextVertexA = physicsObject._vertices[(idxA % #physicsObject._vertices) + 1]
                        local nextVertexB = otherObject._vertices[(idxB % #otherObject._vertices) + 1]

                        local lineQueryResult = Collision.Line(
                            vertexA, 
                            nextVertexA, 
                            vertexB, 
                            nextVertexB
                        )

                        if lineQueryResult.collided then
                            createIntersectionPoint(physicsObject, lineQueryResult.intersectionPosition, overlapQueryResult.normal)
                            newPosition = getIntersectionFacePosition(physicsObject, lineQueryResult.intersectionPosition, overlapQueryResult.normal)
                            didCollide = true
                        end
                    end
                end
            end
        end

        physicsObject:UpdateVertices()

        if didCollide then
            warn("collided so we return")
          --  gameObject.Position = newPosition
            break
        else
           -- gameObject.Position = newPosition
        end
    end
end


task.spawn(function()
    while true do
        Simulation.Stepped(task.wait())
    end
end)

return table.freeze(Simulation) :: Simulation
