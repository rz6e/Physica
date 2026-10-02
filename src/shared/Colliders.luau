local Colliders = {}

export type SphereCollider = {
	Type: "Sphere",
	Radius: number,
}

export type BoxCollider = {
	Type: "Box",
	Vertices: {vector},
}

export type Types = SphereCollider | BoxCollider

function Colliders.Box(Vertices: {vector})
	return {
		Type = "Box",
		Vertices = Vertices,
	}
end

function Colliders.Sphere(Radius: number)
	return {
		Type = "Sphere",
		Radius = Radius,
	}
end

return Colliders
