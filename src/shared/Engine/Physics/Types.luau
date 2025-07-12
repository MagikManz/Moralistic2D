local GenericTypes = require(script.Parent.Parent.Types)
export type Physics2D = {
    _ref: BaseClass,
    _id: string,

    _vertices: { Vector2 },
    _size: Vector2,
    _position: Vector2,
    _rotation: number,
    _debugObject: boolean,
    _intersectionPoint: Frame?,

    _verticesFrames: { Frame },

    Simulation: Simulation,

    getVertices: (position: Vector2, size: Vector2, rotation: number) -> { Vector2 },
    UpdateVertices: (self: Physics2D) -> (),

    new: (gameObject: BaseClass, debugObject: boolean?) -> Physics2D,

    __index: Physics2D
}

export type Simulation = {
    Objects: { [string]: Physics2D },
    AddObject: (self: Simulation, physicsObject: Physics2D) -> (),
    RemoveObject: (self: Simulation, objectId: string) -> (),
    Collision: typeof(require(script.Parent.Collisions)),
    Stepped: (deltaTime: number) -> ()
}

export type BaseClass = GenericTypes.BaseClass

return true