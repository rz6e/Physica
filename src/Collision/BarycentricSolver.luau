--!strict
const MathUtils = require "../Utils/Math"
const SimplexTyping = require "../Typings/SimplexTyping"

const BarycentricSolver = {}

function BarycentricSolver.Compute(a: vector, b: vector, c: vector, q: vector)
	
	const v0 = b - a
	const v1 = c - a

	const d00 = vector.dot(v0, v0)
	const d01 = vector.dot(v0, v1)
	const d11 = vector.dot(v1, v1)
	const denom = d00 * d11 - d01 * d01
	
	if math.abs(denom) < MathUtils.Epsilon then
		print("floating point error")
		return 1, 0, 0
	end
	
	const v2 = q - a
	const d20 = vector.dot(v2, v0)
	const d21 = vector.dot(v2, v1)
	const beta = (d11 * d20 - d01 * d21) / denom
	const gamma = (d00 * d21 - d01 * d20) / denom
	const alpha = 1.0 - beta - gamma

	return alpha, beta, gamma
	
end

function BarycentricSolver.GetContactPoints(Face: SimplexTyping.MPoints, q: vector)
	const A = Face[1]
	const B = Face[2]
	const C = Face[3]

	const a = A.Point
	const b = B.Point
	const c = C.Point

	const alpha, beta, gamma = BarycentricSolver.Compute(a, b, c, q)
	
	const ContactA = A.PointA*alpha + B.PointA*beta + C.PointA*gamma
	const ContactB = A.PointB*alpha + B.PointB*beta + C.PointB*gamma
	
	return ContactA, ContactB

end

table.freeze(BarycentricSolver)

return BarycentricSolver
