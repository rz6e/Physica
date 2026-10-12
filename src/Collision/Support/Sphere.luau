--!strict
const Shape = require "../Shape"

return function(Collider: Shape.Sphere, Direction: vector): vector
	
	return vector.normalize(Direction) * Collider.Radius
	
end
