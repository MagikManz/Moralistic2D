local Instance = { }

local Part = require(script.Part)
local Game = require(script.Parent.Parent.Game)

export type Classes = "Part"
local Classes = {
    Part = Part,
}

function Instance.new(class: Classes, properties: { [string]: any }?)
    assert(type(class) == "string", "Class name must be a string")
    assert(type(properties) == "table" or properties == nil, "Properties must be a table or nil")

    local classDefinition = Classes[class]
    local object = nil
    if classDefinition then
        object = classDefinition.new(properties)
    else
        error("Unknown class: " .. tostring(class), 2)
    end

    Game.Objects[object._id] = object
    
    return object
end

return Instance