--!strict
const EPAModule = require "./EPA" 
const Shape = require("./Shape")
const SupportModule = require "./Support"
const SimplexModule = require "./Simplex"

type ResolutionData = EPAModule.ResolutionData

const GJK = {}

function GJK.Collides(ShapeA: Shape.Types, CFrameA: CFrame, ShapeB: Shape.Types, CFrameB: CFrame): ResolutionData | boolean
	-- Return true if colliders A and B intersect
	
	local Simplex = SimplexModule.new()
	local Support = SupportModule.Support(ShapeA, CFrameA, ShapeB, CFrameB, Simplex.Direction)
	const B = Support.Point
	Simplex:PushFront(Support)
	
	Simplex.Direction = -B
	
	while true do
		local Support = SupportModule.Support(ShapeA, CFrameA, ShapeB, CFrameB, Simplex.Direction)
		const A = Support.Point
		
		if A:Dot(Simplex.Direction) <= 0 then
			return false
		end
		
		Simplex:PushFront(Support)
		if Simplex:NextSimplex() then
			-- Expand polytope to get resolution data
			const ResolutionData: ResolutionData = EPAModule.EPA(Simplex, ShapeA, CFrameA, ShapeB, CFrameB)

			return ResolutionData
		end
	end
	
end

table.freeze(GJK)

return GJK
