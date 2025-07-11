local Polygon = require(script.Polygon)
local Line = require(script.Line)

export type PolygonQueryResult = Polygon.OverlapQueryResult
export type LineQueryResult = Line.OverlapQueryResult

return {
    Polygon = Polygon,
    Line = Line,
}