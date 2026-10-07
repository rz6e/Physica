local Physica = script.Parent.Parent

local Typings = Physica.Typings
local Collision = Physica.Collision
local Utils = Physica.Utils
local Math = Physica.Math

local Colliders = require(Collision.Colliders)
local SupportModule = require(Collision.Support)
local SimplexModule = require(Collision.Simplex)
local Formuli = require(Utils.Math)
local BarycentricSolver = require(Collision.BarycentricSolver)

local EPA = {}

type PolygonData = {
	{
		Face: {vector},
		Normal: vector,
		Distance: number,
	}
}

--for i, v in PolygonData do
--	local a = v.Face[1]
--	local b = v.Face[2]
--	local c = v.Face[3]

--	local AB = b - a
--	local BC = c - b
--	local CA = a - c 

--	local MidPoint = (AB)/ 2

--	VisualizeSimplex(CFrameA, {a, b, c}, BrickColor.new("Really red"))
--	VisualizeLines(CFrameA, b, a, BrickColor.new("Really red"))
--	VisualizeLines(CFrameA, c, b, BrickColor.new("Really red"))
--	VisualizeLines(CFrameA, a, c, BrickColor.new("Really red"))
--end

local function VisualizeSimplex(WorldCFrame: CFrame, Points: {vector}, Color)
	
	for _, Point in Points do
		local Part = Instance.new("Part")
		Part.Size = vector.one
		Part.Transparency = 0.5
		Part.Material = Enum.Material.Neon
		Part.Shape = Enum.PartType.Ball
		Part.Size = vector.create(0.5, 0.5, 0.5)
		Part.Anchored = true
		Part.BrickColor = Color
		Part.Position = WorldCFrame:PointToWorldSpace(Point)
		Part.Parent = workspace
	end

end

local function VisualizeOrigin(WorldCFrame: CFrame)
	
	local Part = Instance.new("Part")
	Part.Size = vector.create(0.5, 0.5, 0.5)
	Part.Transparency = 0.5
	Part.Material = Enum.Material.Neon
	Part.Shape = Enum.PartType.Ball
	Part.Anchored = true
	Part.BrickColor = BrickColor.new("Tr. Green")
	Part.Position = WorldCFrame.Position
	Part.Parent = workspace
	
end

local function VisualizeLines(WorldCFrame: CFrame, a: vector, b: vector, Color)
	
	local worldA = WorldCFrame:PointToWorldSpace(a)
	local worldB = WorldCFrame:PointToWorldSpace(b)

	local Distance = (worldA - worldB).Magnitude
	local MidPoint = (worldA + worldB) / 2

	local Part = Instance.new("Part")
	Part.Transparency = 0.9
	Part.Material = Enum.Material.Neon
	Part.Anchored = true
	Part.BrickColor = Color

	Part.Size = Vector3.new(0.1, 0.1, Distance) 

	Part.CFrame = CFrame.lookAt(MidPoint, worldB)

	Part.Parent = workspace

end

function EPA.FaceCanBeSeenByPoint(SupportPoint, Vertex, Normal)
	local VectorPoint = SupportPoint - Vertex
	return vector.dot(Normal, VectorPoint) > 0
end

function EPA.GetFaceNormals(PolygonData: PolygonData)

	local MinDistance = math.huge
	local MinDistanceIndex = 1

	for Index, Data in PolygonData do
		local A = Data.Face[1]
		local B = Data.Face[2]
		local C = Data.Face[3]

		local a = A.Point
		local b = B.Point
		local c = C.Point

		-- Two vectors used to get the normal
		local AB = b - a
		local AC = c - a
		-- Can pick any point from the triangle to calculate the distance (picking a)
		local OA = a

		-- Normalize so the vector has a length of 1
		local Normal = vector.normalize(vector.cross(AB, AC))
		local Distance = vector.dot(Normal, OA)

		-- Check if our normal is pointing towards the origin and if it is, invert it to point outwards
		if Distance < 0 then
			Data.Face[2], Data.Face[3] = Data.Face[3], Data.Face[2]
			Normal = -Normal
			Distance = -Distance
		end

		if Distance <= Formuli.Epsilon then
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

function EPA.AddEdge(A, B)
	
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


function EPA.EPA(Simplex: SimplexModule.Simplex, ColliderA: Colliders.Types, CFrameA: CFrame, ColliderB: Colliders.Types, CFrameB: CFrame)
	
	local A, B, C, D = Simplex:GetTetraPoints()
	local InitialPolygon = {
		{Face = {A, B, C}},
		{Face = {A, C, D}},
		{Face = {A, D, B}},
		{Face = {B, C, D}},
	}
	EPA.Edges = {}
	
	local PrevMinDistance = math.huge
	local MinDistance, MinDistanceIndex, PolygonData: PolygonData = EPA.GetFaceNormals(InitialPolygon)
	
	while true do
		
		local MinNormal = PolygonData[MinDistanceIndex].Normal
		local Support = SupportModule.Support(ColliderA, CFrameA, ColliderB, CFrameB, MinNormal)
		local SupportPoint = Support.Point
		
		local SupportDistance = vector.dot(SupportPoint, MinNormal)
		
		if (SupportDistance - MinDistance <= Formuli.Epsilon) then
			VisualizeLines(CFrameA, MinNormal * MinDistance, MinNormal * MinDistance + (MinNormal * 3), BrickColor.new("Bright red"))
			
			local PenetrationDepth = MinDistance
			local CollisionNormal: vector = CFrameA:VectorToWorldSpace(MinNormal)
			local q = CollisionNormal * PenetrationDepth
			local ContactA, ContactB = BarycentricSolver.GetContactPoints(PolygonData[MinDistanceIndex].Face, q)
			
			local WorldContactA = CFrameA:PointToWorldSpace(ContactA)
			local WorldContactB = CFrameA:PointToWorldSpace(ContactB)
			local ContactPoint = (WorldContactA + WorldContactB)/2
			
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
			local A = PFaces.Face[1]
			local B = PFaces.Face[2]
			local C = PFaces.Face[3]
			
			local a = A.Point
			local b = B.Point
			local c = C.Point
			
			if EPA.FaceCanBeSeenByPoint(SupportPoint, a, PFaces.Normal) then
				table.remove(PolygonData, Index)
				
				EPA.AddEdge(A, B)
				EPA.AddEdge(B, C)
				EPA.AddEdge(C, A)
				
			end
		end
		
		for _, Edge in EPA.Edges do
			PolygonData[#PolygonData + 1] = {
				Face = {Edge.A, Edge.B, Support}
			}
		end
		
		PrevMinDistance = MinDistance
		MinDistance, MinDistanceIndex, PolygonData = EPA.GetFaceNormals(PolygonData)
		
		table.clear(EPA.Edges)
		
	end
	
end

return EPA
