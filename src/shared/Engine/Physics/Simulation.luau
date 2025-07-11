local RunService = game:GetService("RunService")
local Simulation = { 
    Objects = { },
}

local Collision = require(script.Parent.Collisions)

local Types = require(script.Parent.Types)

type Physics2D = Types.Physics2D

local function createIntersectionPoint(physicsObject, intersectionPosition: Vector2, normal: Vector2)
    if physicsObject._intersectionPoint ~= nil then
        physicsObject._intersectionPoint:Destroy()
        physicsObject._intersectionPoint = nil
    end

    if not physicsObject.Instance or not physicsObject.Instance.Parent then
        return
    end

    local absolutePosition = physicsObject.Instance.AbsolutePosition
    local absoluteSize = physicsObject.Instance.AbsoluteSize

    local middlePoint = absolutePosition + absoluteSize / 2

    print(normal)

    local offset = intersectionPosition - middlePoint
    local intersectionPositionWorld = middlePoint + offset
    intersectionPositionWorld = Vector2.new(
        intersectionPositionWorld.X + normal.X * 5, 
        intersectionPositionWorld.Y + normal.Y * 5
    )

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(10, 10)
    frame.Position = UDim2.fromOffset(intersectionPositionWorld.X, intersectionPositionWorld.Y)
    frame.BackgroundColor3 = Color3.new(0, 1, 0.784314) -- Red color for intersection point
    frame.Parent = physicsObject.Instance.Parent

    physicsObject._intersectionPoint = frame
end

local function determineCollisionMethodBySize(physicsObject: Physics2D): string
    if #physicsObject._vertices == 2 then
        return "Line"
    elseif #physicsObject._vertices > 2 then
        return "Polygon"
    else
        error("Invalid number of vertices for collision detection")
    end
end

function Simulation:AddObject(physicsObject: Physics2D)
    self.Objects[physicsObject._id] = physicsObject
end

function Simulation:RemoveObject(objectId: string)
    self.Objects[objectId] = nil
end

function Simulation.Stepped(_deltaTime: number)
    task.wait(0.1)
    for _, physicsObject in pairs(Simulation.Objects) do
        if not physicsObject.Instance then
            continue
        end

        for _, otherObject in pairs(Simulation.Objects) do
            if otherObject._id ~= physicsObject._id and otherObject.Instance then
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
                            warn("collided!")
                            lineQueryResult.normal = Vector2
                            createIntersectionPoint(physicsObject, lineQueryResult.intersectionPosition, overlapQueryResult.normal)
                            return
                        end
                    end
                end
            end
        end
    end
end

RunService.PreRender:Connect(function(deltaTime)
    Simulation.Stepped(deltaTime)
end)

return Simulation