return function(mass: number, gravity: number, currentAcceleration: Vector2): Vector2
    local force = mass * gravity
    local acceleration = force / mass

    return currentAcceleration + Vector2.new(0, -acceleration)
end