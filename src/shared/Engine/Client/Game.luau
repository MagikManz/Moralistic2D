local Game = { }

local Players = game:GetService("Players")

local function __INIT()
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ScreenRender = require(script.Parent.Renderer)
    local Workspace = require(script.Parent.Workspace)

    local gameInstance = Instance.new("ScreenGui")
    gameInstance.Name = "Game"
    gameInstance.ResetOnSpawn = false
    gameInstance.DisplayOrder = 1

    gameInstance.Parent = PlayerGui

    Game.Workspace = Workspace.new(gameInstance)
    Game.Objects = { }

    ScreenRender(Game)

    export type Game = typeof(Game)
end

return Game, __INIT()
