local Physica = script.Parent.Parent

local Colliders = require(Physica.Collision.Colliders)

local Support = {}
local Map = {
	Sphere = require(script.Sphere),
	Box = require(script.Box)
}

function Support.Support(ColliderA: Colliders.Types, CFrameA: CFrame, ColliderB: Colliders.Types, CFrameB: CFrame, Direction: vector)
	local AType = ColliderA.Type
	local BType = ColliderB.Type
	
	local BInA = CFrameA:ToObjectSpace(CFrameB)
	
	local PointA = Map[AType](ColliderA, Direction)
	
	local DirectionInB = BInA:VectorToObjectSpace(-Direction)
	
	local PointB = Map[BType](ColliderB, DirectionInB)
	
	local PointBInA = BInA:PointToWorldSpace(PointB)
	
	return {
		Point = PointA - PointBInA,
		PointA = PointA,
		PointB = PointBInA
	}
end

return Support


