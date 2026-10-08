--!strict
const Shape = require "./Shape"
const SimplexTyping = require "../Typings/SimplexTyping"

const Support = {}
const Map = {
	Sphere = require(script.Sphere),
	Box = require(script.Box)
}

function Support.Support(ShapeA: Shape.Types, CFrameA: CFrame, ShapeB: Shape.Types, CFrameB: CFrame, Direction: Vector3): SimplexTyping.MPoint
	const AType = ShapeA.Type
	const BType = ShapeB.Type
	
	const BInA = CFrameA:ToObjectSpace(CFrameB)
	
	const PointA = Map[AType](ShapeA, Direction)
	
	const DirectionInB = BInA:VectorToObjectSpace(-Direction)
	
	const PointB = Map[BType](ShapeB, DirectionInB)
	
	const PointBInA = BInA:PointToWorldSpace(PointB)
	
	return {
		Point = PointA - PointBInA,
		PointA = PointA,
		PointB = PointBInA
	}
end

table.freeze(Support)

return Support


