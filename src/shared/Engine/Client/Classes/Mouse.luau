local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera

local DEFAULT_SCREEN_SIZE = Vector2.new(1920, 1080)

local Mouse = { }

local function getScreenScale(): number
    local viewportSize = camera.ViewportSize
    return math.min(viewportSize.X, viewportSize.Y) / DEFAULT_SCREEN_SIZE.Y
end

function Mouse:GetMouseLocation()
    local viewportSize = camera.ViewportSize
    local mousePosition = UserInputService:GetMouseLocation()

    return (mousePosition - viewportSize / 2) / getScreenScale()
end

return Mouse