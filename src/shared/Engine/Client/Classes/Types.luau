export type BaseClass = {
    Name: string,
    
    Size: Vector2,
    Position: Vector2,

    Anchored: boolean,
    Rotation: number,

    CanCollide: boolean,
    CanTouch: boolean,
    CanQuery: boolean,

    _id: string
}

export type BasePart = BaseClass & {
    Color: Color3,
    Transparency: number,
}

return true
