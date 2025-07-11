export type Physics2D = {
    Instance: GuiObject,
    _id: string,

    _vertices: { Vector2 },
    _size: Vector2,
    _position: Vector2,
    _rotation: number,
    _debugObject: boolean,

    _verticesFrames: { Frame },

    UpdateVertices: (self: Physics2D) -> (),

    new: (objectId: string, objectInstance: GuiObject, debugObject: boolean?) -> Physics2D,

    __index: Physics2D
}

return true