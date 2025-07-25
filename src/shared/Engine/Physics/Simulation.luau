local Simulation: Simulation = { 
    Objects = { },
} :: Simulation

local Collision = require(script.Parent.Collisions)
local Gravity = require(script.Parent.Gravity)

local Types = require(script.Parent.Types)

Simulation.Collision = Collision

type Physics2D = Types.Physics2D
type BaseClass = Types.BaseClass
type Simulation = Types.Simulation


function Simulation:AddObject(physicsObject: Physics2D)
    self.Objects[physicsObject._id] = physicsObject
end

function Simulation:RemoveObject(objectId: string)
    self.Objects[objectId] = nil
end


local function getCollisionPoint(objectAVertices: { Vector2 }, objectBVertices: { Vector2 }): (boolean, Vector2)
    for i = 1, #objectAVertices do
        local vertexA1 = objectAVertices[i]
        local vertexA2 = objectAVertices[(i % #objectAVertices) + 1]
        for j = 1, #objectBVertices do
            local vertexB1 = objectBVertices[j]
            local vertexB2 = objectBVertices[(j % #objectBVertices) + 1]

            local result = Collision.Line(
                vertexA1, 
                vertexA2, 
                vertexB2, 
                vertexB1
            )

            if result.collided then
                return true, result.intersectionPosition
            end
        end
    end

    return false, Vector2.zero
end

local function getPolygonNormal(objectAVertices: { Vector2 }, objectBVertices: { Vector2 }): (boolean, Vector2)
    local overlapResult = Collision.Polygon(objectAVertices, objectBVertices)
    return overlapResult.collided, overlapResult.normal
end

function Simulation.Stepped(_deltaTime: number)
    for _id, physicsObject in pairs(Simulation.Objects) do
        local gameObjectA = physicsObject._ref
        local objectInstance = gameObjectA.Instance
        if objectInstance == nil then
            continue
        end

        local gravityForce = Vector2.zero
        local newPosition = gameObjectA.Position
        if gameObjectA.Anchored == false then
            gravityForce = Gravity(
                10, 
                workspace.Gravity, 
                Vector2.zero
            )

            newPosition += gravityForce * _deltaTime        
        end

        local objectAVertices = physicsObject.getVertices(newPosition, gameObjectA.Size, gameObjectA.Rotation)

        local objectCollided, collisionPosition, collisionNormal = false, Vector2.zero, Vector2.zero
        for _, otherObject in pairs(Simulation.Objects) do
            if otherObject._id == physicsObject._id or otherObject._ref.Instance == nil then
                continue
            end

            local gameObjectB = otherObject._ref
            local objectBVertices = physicsObject.getVertices(gameObjectB.Position, gameObjectB.Size, gameObjectB.Rotation)

            objectCollided, collisionNormal = getPolygonNormal(
                objectAVertices,
                objectBVertices
            )

            if objectCollided == false then
                continue
            end

            objectCollided, collisionPosition = getCollisionPoint(
                objectAVertices,
                objectBVertices
            )
        end

        if objectCollided then
            -- NEED TO APPLY THINGS!
            break
        else
           gameObjectA.Position = newPosition
        end
    end
end


task.spawn(function()
    task.wait(1)
    while true do
        Simulation.Stepped(task.wait())
    end
end)

return table.freeze(Simulation) :: Simulation
