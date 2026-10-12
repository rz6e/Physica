--!strict
const Shape = require "../Shape"

return function(Collider: Shape.Box, Direction: vector): vector
	
	local MaxPoint = vector.zero
	local MaxDistance = -math.huge

	for _, Vertex in Collider.Vertices do
		
		local Distance = vector.dot(Vertex, Direction)

		if Distance > MaxDistance then
			MaxPoint = Vertex
			MaxDistance = Distance
		end
	end

	return MaxPoint
	
end
