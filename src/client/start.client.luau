local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Shared.Engine)

local part = Engine.Instance.new("Part")
part.Name = "DINOOO"
part.Size = Vector2.new(100, 200)
part.Position = Vector2.new(100, 100)
part.Parent = Engine.Game.Workspace

local part2 = Engine.Instance.new("Part")
part2.Name = "DINOOO2"
part2.Size = Vector2.new(1, 200)
part2.Position = Vector2.new(100, 300)
part2.Parent = Engine.Game.Workspace

Engine.Physics2D.new(part._id, part.Instance, true)
Engine.Physics2D.new(part2._id, part2.Instance, true)

while true do
    local mouseLocation = Engine.Mouse:GetMouseLocation()
    part.Position = Vector2.new(mouseLocation.X, -mouseLocation.Y)
    task.wait()
end