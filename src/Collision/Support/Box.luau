local Physica = script.Parent.Parent.Parent

local Typings = Physica.Typings
local Collision = Physica.Collision

local Colliders = require(Collision.Colliders)

return function(Collider: Colliders.BoxCollider, Direction: vector): vector
	
	local MaxPoint = vector.zero
	local MaxDistance = -math.huge

	for Index, Vertex in Collider.Vertices do
		
		local Distance = vector.dot(Vertex, Direction)

		if Distance > MaxDistance then
			MaxPoint = Vertex
			MaxDistance = Distance
		end
	end

	return MaxPoint
	
end
