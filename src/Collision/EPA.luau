--!strict
const Shape = require "./Shape"
const SupportModule = require "./Support"
const SimplexModule = require "./Simplex"
const MathUtils = require "../Utils/Math"
const BarycentricSolver = require "./BarycentricSolver"
const SimplexTyping = require "../Typings/SimplexTyping"

type SimplexVars = SimplexTyping.SimplexVars
type SimplexMethods = SimplexTyping.SimplexMethods
type MPoint = SimplexTyping.MPoint
type MPoints = SimplexTyping.MPoints
type Simplex = SimplexTyping.Simplex

type PolygonData = {{
	Face: {MPoint},
	Normal: Vector3,
	Distance: number,
}}

export type ResolutionData = {
	PenetrationDepth: number,
	Normal: Vector3,
	
	ContactA: Vector3,
	ContactB: Vector3,
	WorldContactA: Vector3,
	WorldContactB: Vector3,
	ContactPoint: Vector3,
}

const EPA = {}

function EPA.FaceCanBeSeenByPoint(SupportPoint: Vector3, Vertex: Vector3, Normal: Vector3): boolean
	const VectorPoint = SupportPoint - Vertex
	return Normal:Dot(VectorPoint) > 0
end

function EPA.GetFaceNormals(PolygonData: PolygonData)

	local MinDistance = math.huge
	local MinDistanceIndex = 1

	for Index, Data in PolygonData do
		const A = Data.Face[1]
		const B = Data.Face[2]
		const C = Data.Face[3]

		const a = A.Point
		const b = B.Point
		const c = C.Point

		-- Two vectors used to get the normal
		const AB = b - a
		const AC = c - a
		-- Can pick any point from the triangle to calculate the distance (picking a)
		const OA = a

		-- Normalize so the vector has a length of 1
		local Normal = (AB:Cross(AC)).Unit
		local Distance = Normal:Dot(OA)

		-- Check if our normal is pointing towards the origin and if it is, invert it to point outwards
		if Distance < 0 then
			Data.Face[2], Data.Face[3] = Data.Face[3], Data.Face[2]
			Normal = -Normal
			Distance = -Distance
		end

		if Distance <= MathUtils.Epsilon then
			print("add later")
		end

		if Distance < MinDistance then

			MinDistance = Distance
			MinDistanceIndex = Index
		end

		Data["Normal"] = Normal
		Data["Distance"] = Distance
	end

	return MinDistance, MinDistanceIndex, PolygonData

end

function EPA.AddEdge(A: MPoint, B: MPoint)
	
	for Index, Edge in EPA.Edges do
		if Edge.A.Point == B.Point and Edge.B.Point == A.Point then
			table.remove(EPA.Edges, Index)
			return
		end
	end
	
	EPA.Edges[#EPA.Edges + 1] = {
		A = A,
		B = B,
	}
	
end

function EPA.EPA(Simplex: Simplex, ShapeA: Shape.Types, CFrameA: CFrame, ShapeB: Shape.Types, CFrameB: CFrame)
	
	const A: MPoint, B: MPoint, C: MPoint, D: MPoint = Simplex:GetTetraPoints()
	local InitialPolygon: PolygonData = {
		{Face = {A, B, C}, Normal = Vector3.zero, Distance = 0},
		{Face = {A, C, D}, Normal = Vector3.zero, Distance = 0},
		{Face = {A, D, B}, Normal = Vector3.zero, Distance = 0},
		{Face = {B, C, D}, Normal = Vector3.zero, Distance = 0},
	}
	EPA.Edges = {}
	
	-- local PrevMinDistance = math.huge
	local MinDistance, MinDistanceIndex, PolygonData: PolygonData = EPA.GetFaceNormals(InitialPolygon)
	
	while true do
		local MinNormal = PolygonData[MinDistanceIndex].Normal
		local Support = SupportModule.Support(ShapeA, CFrameA, ShapeB, CFrameB, MinNormal)
		local SupportPoint = Support.Point
		
		local SupportDistance = SupportPoint:Dot(MinNormal)
		
		if SupportDistance - MinDistance <= MathUtils.Epsilon then
			
			const PenetrationDepth = MinDistance
			const CollisionNormal = CFrameA:VectorToWorldSpace(MinNormal)
			const q = CollisionNormal * PenetrationDepth
			const ContactA, ContactB = BarycentricSolver.GetContactPoints(PolygonData[MinDistanceIndex].Face, q)
			
			const WorldContactA = CFrameA:PointToWorldSpace(ContactA)
			const WorldContactB = CFrameA:PointToWorldSpace(ContactB)
			const ContactPoint = (WorldContactA + WorldContactB)/2
			
			return {
				PenetrationDepth = PenetrationDepth,
				Normal = CollisionNormal,
				
				ContactA = ContactA,
				ContactB = ContactB,
				WorldContactA = WorldContactA,
				WorldContactB = WorldContactB,
				ContactPoint = ContactPoint,
			}
		end
		
		for Index = #PolygonData, 1, -1 do
			local PFaces = PolygonData[Index]
			const A = PFaces.Face[1]
			const B = PFaces.Face[2]
			const C = PFaces.Face[3]
			
			const a = A.Point
			
			if EPA.FaceCanBeSeenByPoint(SupportPoint, a, PFaces.Normal) then
				table.remove(PolygonData, Index)
				
				EPA.AddEdge(A, B)
				EPA.AddEdge(B, C)
				EPA.AddEdge(C, A)
			end
		end
		
		for _, Edge in EPA.Edges do
			PolygonData[#PolygonData + 1] = {
				Face = {Edge.A, Edge.B, Support},
				Normal = Vector3.zero,
				Distance = 0,
			}
		end
		
		-- PrevMinDistance = MinDistance
		MinDistance, MinDistanceIndex, PolygonData = EPA.GetFaceNormals(PolygonData)
		
		table.clear(EPA.Edges)
		
	end
	
end

table.freeze(EPA)

return EPA
