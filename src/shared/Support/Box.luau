local ReplicatedStorage = game.ReplicatedStorage
local Colliders = require(ReplicatedStorage.Colliders)

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
