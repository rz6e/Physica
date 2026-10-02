local ReplicatedStorage = game.ReplicatedStorage
local Colliders = require(ReplicatedStorage.Colliders)

return function(Collider: Colliders.SphereCollider, Direction: vector): vector
	
	return vector.normalize(Direction) * Collider.Radius
	
end
