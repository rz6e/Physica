--!strict
const Shape = {}

export type Sphere = {
	Type: "Sphere",
	Radius: number,
}

export type Box = {
	Type: "Box",
	Vertices: {Vector3},
}

export type Types = Sphere | Box

function Shape.Box(Vertices: {Vector3})
	return {
		Type = "Box",
		Vertices = Vertices,
	}
end

function Shape.Sphere(Radius: number)
	return {
		Type = "Sphere",
		Radius = Radius,
	}
end

table.freeze(Shape)

return Shape
