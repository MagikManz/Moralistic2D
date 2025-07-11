local Workspace = { }

local cachedWorkspace: Frame?

function Workspace.new(game: ScreenGui): Frame
    local workspaceInstance = Instance.new("Frame")
    workspaceInstance.Name = "Workspace"

    workspaceInstance.Size = UDim2.fromScale(1, 1)
    workspaceInstance.Transparency = 1

    workspaceInstance.Parent = game

    if cachedWorkspace then
        cachedWorkspace:Destroy()
    end

    cachedWorkspace = workspaceInstance

    return workspaceInstance
end

return setmetatable(Workspace, {
    __index = function(_, key)
        if cachedWorkspace then
            return cachedWorkspace[key]
        else
            error("Workspace not initialized. Call Workspace.new() first.", 2)
        end
    end,
})