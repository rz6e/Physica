--!strict
const Shape = require "../Shape"

return function(Collider: Shape.Sphere, Direction: Vector3): Vector3
	
	return Direction.Unit * Collider.Radius
	
end
