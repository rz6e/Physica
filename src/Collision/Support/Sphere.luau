local Physica = script.Parent.Parent.Parent

local Typings = Physica.Typings
local Collision = Physica.Collision

local Colliders = require(Collision.Colliders)

return function(Collider: Colliders.SphereCollider, Direction: vector): vector
	
	return vector.normalize(Direction) * Collider.Radius
	
end
