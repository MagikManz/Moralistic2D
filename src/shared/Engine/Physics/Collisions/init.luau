local Polygon = require(script.Polygon)
local Rectangle = require(script.Rectangle)
local Line = require(script.Line)

export type PolygonQueryResult = Polygon.OverlapQueryResult
export type LineQueryResult = Line.OverlapQueryResult


return {
    Polygon = Polygon,
    Rectangle = Rectangle,
    Line = Line
}