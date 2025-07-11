local Engine = { }

local Classes = script.Classes

Engine.Game = require(script.Game)
Engine.Types = require(script.Workspace)
Engine.Physics2D = require(script.Parent.Physics)

Engine.Instance = require(Classes.Instance)
Engine.Mouse = require(Classes.Mouse)

return Engine