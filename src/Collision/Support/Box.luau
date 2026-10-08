local Shape = require "../Shape"

return function(Collider: Shape.Box, Direction: Vector3): Vector3
	
	local MaxPoint = vector.zero
	local MaxDistance = -math.huge

	for _, Vertex in Collider.Vertices do
		
		local Distance = Vertex:Dot(Direction)

		if Distance > MaxDistance then
			MaxPoint = Vertex
			MaxDistance = Distance
		end
	end

	return MaxPoint
	
end
