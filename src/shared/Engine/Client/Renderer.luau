local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera

local DEFAULT_SCREEN_SIZE = Vector2.new(1920, 1080)

local function getScreenScale(): number
    local viewportSize = camera.ViewportSize
    return math.min(viewportSize.X, viewportSize.Y) / DEFAULT_SCREEN_SIZE.Y
end

return function(Game: { Objects: { any } })
    local function scaleToScreenSize()
        local objects = Game.Objects
        local scale = getScreenScale()
        for _objectId: string, object: any in pairs(objects) do
            object.Instance.Size = UDim2.fromOffset(object._size.X * scale, object._size.Y * scale)
            object.Instance.Position = UDim2.new(0.5, object._position.X * scale, 0.5, -object._position.Y * scale)
        end
    end

    RunService.PreRender:Connect(scaleToScreenSize)
end
