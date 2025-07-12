local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Shared.Engine)
local Collisions = require(ReplicatedStorage.Shared.Engine.Physics.Collisions)

local Collision = Engine.Physics2D.Simulation.Collision

local part = Engine.Instance.new("Part")
part.Name = "testPart"
part.Size = Vector2.new(100, 200)
part.Position = Vector2.new(100, 100)
part.Parent = Engine.Game.Workspace
part.Anchored = true
--Engine.Physics2D.new(part, true)

local ground = Engine.Instance.new("Part")
ground.Name = "Ground"
ground.Anchored = true
ground.Parent = Engine.Game.Workspace
ground.Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X * 2, 50)
ground.Position = Vector2.new(0, -workspace.CurrentCamera.ViewportSize.Y / 2 - 300)
--Engine.Physics2D.new(ground, true)

local frame = Engine.Instance.new("Part")
frame.Parent = Engine.Game.Workspace

local frames = { }

local function checkIntersection()

    local partVertices = Engine.Physics2D.getVertices(part.Position, part.Size, part.Rotation)
    local groundVertices = Engine.Physics2D.getVertices(ground.Position, ground.Size, ground.Rotation)

    local collision = Collisions.Polygon(partVertices, groundVertices)

    if collision.collided then
        local normal = collision.normal
        print(normal)
        frame.Size = Vector2.one * 10
        frame.Position = ground.Position + normal * ground.Size / 2
        frame.Color = Color3.fromRGB(0, 255, 0) -- Green color for collision
    end
  
end

task.spawn(function()
    print(typeof(part.Size), typeof(part.Position))
    while true do
        local mouseLocation = Engine.Mouse:GetMouseLocation()
        part.Position = Vector2.new(mouseLocation.X, -mouseLocation.Y)

        ground.Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X, 50)
        ground.Position = Vector2.new(0, -workspace.CurrentCamera.ViewportSize.Y / 2 + ground.Size.Y * 2)

        checkIntersection()
        task.wait()
    end
end)