return function(topLeft0: Vector2, size0: Vector2, topLeft1: Vector2, size1: Vector2): boolean
    print(typeof(topLeft0), typeof(size0), typeof(topLeft1), typeof(size1))
    return 
        topLeft0.X < topLeft1.X + size1.X and
        topLeft1.X < topLeft0.X + size0.X and

        topLeft1.Y < topLeft0.Y + size0.Y and
        topLeft0.Y < topLeft1.Y + size1.Y
end