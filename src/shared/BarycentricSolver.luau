local ReplicatedStorage = game.ReplicatedStorage
local Formuli = require(ReplicatedStorage.Formuli)

local BarycentricSolver = {}

function BarycentricSolver.Compute(a: vector, b: vector, c: vector, q: vector)
	
	local v0 = b - a
	local v1 = c - a

	local d00 = vector.dot(v0, v0)
	local d01 = vector.dot(v0, v1)
	local d11 = vector.dot(v1, v1)
	local denom = d00 * d11 - d01 * d01
	
	if math.abs(denom) < Formuli.Epsilon then
		print("floating point error")
		return 1, 0, 0
	end
	
	local v2 = q - a
	local d20 = vector.dot(v2, v0)
	local d21 = vector.dot(v2, v1)
	local beta = (d11 * d20 - d01 * d21) / denom
	local gamma = (d00 * d21 - d01 * d20) / denom
	local alpha = 1.0 - beta - gamma

	return alpha, beta, gamma
	
end

function BarycentricSolver.GetContactPoints(Face: {}, q: vector)
	
	local A = Face[1]
	local B = Face[2]
	local C = Face[3]

	local a = A.Point
	local b = B.Point
	local c = C.Point

	local alpha, beta, gamma = BarycentricSolver.Compute(a, b, c, q)
	
	local ContactA = A.PointA*alpha + B.PointA*beta + C.PointA*gamma
	local ContactB = A.PointB*alpha + B.PointB*beta + C.PointB*gamma
	
	return ContactA, ContactB

end

return BarycentricSolver
