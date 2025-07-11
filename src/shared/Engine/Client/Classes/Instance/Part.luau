local HttpService = game:GetService("HttpService")

local Part: Part = { } :: Part

export type Part = { 
    new: (properties: BasePart) -> ClassPart,

    __index: Part,
}

export type PartData = {
    Instance: Frame,
    _id: string,
    Name: string,
    Size: Vector2,
    Position: Vector2,
    _position: Vector2,
    _size: Vector2,
    Color: Color3,
    Transparency: number,
    Rotation: number,
    Anchored: boolean,
    CanCollide: boolean,
    CanTouch: boolean,
    CanQuery: boolean,
}

type PartMetatable = {
    __tostring: (self: ClassPart) -> string,
    __eq: (self: ClassPart, other: ClassPart?) -> boolean,
    __index: (self: ClassPart, idx: string) -> any,
    __newindex: (self: ClassPart, idx: string, newValue: any) -> nil,
}

export type ClassPart = typeof(setmetatable({ } :: PartData,  { } :: PartMetatable))

local Engine = script.Parent.Parent
local Types = require(Engine.Types)

type BasePart = Types.BasePart 

local DEFAULT_PROPERTIES = {
    Name = "Part",

    Size = Vector2.new(100, 100),
    Position = Vector2.new(0, 0),

    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0,

    Rotation = 0,

    Anchored = false,
    CanCollide = true,

    CanTouch = true,
    CanQuery = true,

    Parent = game,

    _id = nil
}

local TRANSLATE_PROPERTY = {
    Color = "BackgroundColor3",
}

local QUERY_PROPERTIES = {
    "CanQuery",
    "CanTouch",
    "CanCollide",
    "Anchored"
}

local function setProperty(frame: Frame, object: PartData, key: string, value: any)
    if key == "Size" then
        object._size = value
        value = UDim2.fromOffset(value.X, value.Y)
    elseif key == "Position" then
        object._position = value
        value = UDim2.fromOffset(value.X, value.Y)
    elseif TRANSLATE_PROPERTY[key] then
        key = TRANSLATE_PROPERTY[key]
        frame[key] = value
    elseif table.find(QUERY_PROPERTIES, key) then
        if type(value) ~= "boolean" then
            error(`Property '{key}' must be a boolean`, 2)
        end

        frame:SetAttribute(key, value)
    elseif DEFAULT_PROPERTIES[key] ~= nil then
        local success, error = pcall(function()
            frame[key] = value
        end)

        if success == false then
            error(`Failed to set property '{key}' on Part: {frame}"`, 2)
        end
    end

    rawset(object, key, value)
end

function Part.new(properties: BasePart): ClassPart
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)

    properties = properties or DEFAULT_PROPERTIES

    local objectId = HttpService:GenerateGUID(false)

    local object: PartData = {
        Instance = frame,
        _id = objectId
    } :: PartData

    local proxy = newproxy(true)
    local proxyMetatable = getmetatable(proxy)
    
    frame:SetAttribute("Engine_Id", objectId)
    
    for key, defaultValue in pairs(DEFAULT_PROPERTIES) do
        if key == "_id" then
            continue
        end

        local value = properties[key]
        if value == nil then
            value = defaultValue
        end

        setProperty(frame, object, key, value)
    end

    local metatable: PartMetatable = {
        __tostring = function()
            return object.Name
        end,

        __eq = function(self, other)
            if other == nil then
                return false
            end

            if getmetatable(self) ~= getmetatable(other) then
                return false
            end

            return object.Instance == other.Instance
        end,

        __index = function(_self, key)
            if key == nil then
                error("Attempt to index a nil value", 2)
            end

            return rawget(object, key) or object.Instance[key]
        end,

        __newindex = function(_self, key, value)
            if key == nil then
                error("Attempt to index a nil value", 2)
            end

            if table.find(QUERY_PROPERTIES, key) then
                object.Instance:SetAttribute(key, value)
            end

            setProperty(object.Instance, object, key, value)

            rawset(object, key, value)
        end,

        __metatable = "Part"
    }

    for key, value in pairs(metatable) do
        proxyMetatable[key] = value
    end

    return proxy :: ClassPart
end

return table.freeze(Part) :: Part