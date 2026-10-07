local RunService = game:GetService("RunService")

local Physica = script.Parent.Parent

local Typings = Physica.Typings
local Collision = Physica.Collision
local Utils = Physica.Utils
local Math = Physica.Math

local Colliders = require(Collision.Colliders)
local SupportModule = require(Collision.Support)
local SimplexModule = require(Collision.Simplex)
local EPAModule = require(Collision.EPA)

local GJK = {}

function GJK.Collides(ColliderA: Colliders.Types, CFrameA: CFrame, ColliderB: Colliders.Types, CFrameB: CFrame): boolean
	-- Return true if colliders A and B intersect
	
	local Simplex = SimplexModule.new()
	local Support = SupportModule.Support(ColliderA, CFrameA, ColliderB, CFrameB, Simplex.Direction)
	local B = Support.Point
	Simplex:PushFront(Support)
	
	Simplex.Direction = -B
	
	while true do
		local Support = SupportModule.Support(ColliderA, CFrameA, ColliderB, CFrameB, Simplex.Direction)
		local A = Support.Point
		
		if vector.dot(A, Simplex.Direction) <= 0 then
			return false
		end
		
		Simplex:PushFront(Support)
		if Simplex:NextSimplex(Simplex.Direction) then
			-- Expand polytope to get resolution data
			local ResolutionData = EPAModule.EPA(Simplex, ColliderA, CFrameA, ColliderB, CFrameB)
			
			
			local Part = Instance.new("Part")
			Part.Size = vector.one
			Part.Transparency = 0.5
			Part.Material = Enum.Material.Neon
			Part.Shape = Enum.PartType.Ball
			Part.Size = vector.create(0.5, 0.5, 0.5)
			Part.Anchored = true
			Part.BrickColor = BrickColor.new("Royal blue")
			Part.Position = ResolutionData.ContactPoint
			Part.Parent = workspace

			
			return ResolutionData
		end
	end
	
end

return GJK
