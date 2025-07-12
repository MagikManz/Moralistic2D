local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Shared.Engine)

local part = Engine.Instance.new("Part")
part.Name = "testPart"
part.Size = Vector2.new(100, 200)
part.Position = Vector2.new(100, 100)
part.Parent = Engine.Game.Workspace
part.Anchored = false
Engine.Physics2D.new(part, false)

local ground = Engine.Instance.new("Part")
ground.Name = "Ground"
ground.Anchored = true
ground.Parent = Engine.Game.Workspace
ground.Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X * 2, 50)
ground.Position = Vector2.new(0, -workspace.CurrentCamera.ViewportSize.Y / 2 - 300)
Engine.Physics2D.new(ground, false)

task.spawn(function()
    while true do
        ground.Size = Vector2.new(workspace.CurrentCamera.ViewportSize.X, 50)
        ground.Position = Vector2.new(0, -workspace.CurrentCamera.ViewportSize.Y / 2 + ground.Size.Y * 2)

        task.wait()
    end
end)