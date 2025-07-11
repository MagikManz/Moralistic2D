export type OverlapQueryResult = {
    collided: boolean,
    overlap: number,
    normal: Vector2
}

local function getPolygonAxes(vertices: { Vector2 }): { Vector2 }
    local axes = {}

    for i = 1, #vertices do
        local currentVertex = vertices[i]
        local nextVertex = vertices[(i % #vertices) + 1]

        local edge = nextVertex - currentVertex
        local axis = Vector2.new(-edge.Y, edge.X).Unit

        table.insert(axes, axis)
    end

    return axes
end

local function projectPolygon(vertices: { Vector2 }, axis: Vector2): (number, number)
    local min = math.huge
    local max = -math.huge

    for _, vertex in ipairs(vertices) do
        local projection = vertex:Dot(axis)
        min = math.min(min, projection)
        max = math.max(max, projection)
    end

    return min, max
end

local function getPolygonOverlap(axes, verticesA: { Vector2 }, verticesB: { Vector2 }): OverlapQueryResult
    local smallestOverlap = math.huge
    local normal = nil

    for _, axis in ipairs(axes) do
        local minA, maxA = projectPolygon(verticesA, axis)
        local minB, maxB = projectPolygon(verticesB, axis)

        if maxA < minB or maxB < minA then
            return {
                collided = false,
                overlap = 0,
                normal = nil
            }
        end

        local overlap = math.min(maxA, maxB) - math.max(minA, minB)
        if overlap < smallestOverlap then
            smallestOverlap = overlap
            normal = axis
        end
    end

    return {
        collided = true,
        overlap = smallestOverlap,
        normal = normal
    }
end


local function checkCollision(verticesA: { Vector2 }, verticesB: { Vector2 }): OverlapQueryResult
    local axesA = getPolygonAxes(verticesA)
    local axesB = getPolygonAxes(verticesB)

    local aOverlap = getPolygonOverlap(axesA, verticesA, verticesB)
    local bOverlap = getPolygonOverlap(axesB, verticesA, verticesB)

    if aOverlap.collided == false or bOverlap.collided == false then
        return {
            collided = false,
            overlap = 0,
            normal = nil
        }
    end

    local normal = if aOverlap.overlap < bOverlap.overlap then
        aOverlap.normal
    else
        bOverlap.normal
    
    local overlap = math.min(aOverlap.overlap, bOverlap.overlap)
    --print(overlap, ":", normal)
    return {
        collided = true,
        overlap = overlap,
        normal = normal
    }
end

return checkCollision
