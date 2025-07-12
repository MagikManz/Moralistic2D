export type OverlapQueryResult = {
    collided: boolean,
    overlap: number,
    intersectionPosition: Vector2
}

local camera = workspace.CurrentCamera

local DEFAULT_SCREEN_SIZE = Vector2.new(1920, 1080)

local function getScreenScale(): number
    local viewportSize = camera.ViewportSize
    return math.min(viewportSize.X, viewportSize.Y) / DEFAULT_SCREEN_SIZE.Y
end

local FALSE_VALUE = {
    collided = false,
    overlap = 0,
    intersectionPosition = Vector2.new(0, 0)
}

local function scaleVectorToWorld(worldVector: Vector2): Vector2
    local worldSize = camera.ViewportSize / 2
    return (worldSize - Vector2.new(worldVector.X, worldVector.Y)) * getScreenScale()
end

local function getIntersection(vertexA1: Vector2, vertexA2: Vector2, vertexB1: Vector2, vertexB2: Vector2): OverlapQueryResult
    local x1, y1 = vertexA1.X, vertexA1.Y
    local x2, y2 = vertexA2.X, vertexA2.Y

    local x3, y3 = vertexB1.X, vertexB1.Y
    local x4, y4 = vertexB2.X, vertexB2.Y

    if (x1 == x2 and y1 == y2) or (x3 == x4 and y3 == y4) then
        return FALSE_VALUE
    end

    local denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

    if denominator == 0 then
        return FALSE_VALUE
    end

    local ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator
    local ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denominator

    if ua < 0 or ua > 1 or ub < 0 or ub > 1 then
        return FALSE_VALUE
    end

    local intersectionX = x1 + ua * (x2 - x1)
    local intersectionY = y1 + ua * (y2 - y1)

    local scaledToWorld = scaleVectorToWorld(Vector2.new(intersectionX, intersectionY))

    return {
        collided = true,
        overlap = 0,
        intersectionPosition = Vector2.new(
            -scaledToWorld.X,
            scaledToWorld.Y
        )
    }
end

return getIntersection