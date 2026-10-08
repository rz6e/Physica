export type MPoint = {Point: Vector3, PointA: Vector3, PointB: Vector3}
export type MPoints = {MPoint}

export type SimplexVars = {
	MPoints: MPoints,
	MSize: number,
	Direction: Vector3,
}

export type SimplexMethods = {
	read PushFront: (self: Simplex, Point: MPoint) -> (),

    read Line: (self: Simplex) -> boolean,
    read Triangle: (self: Simplex) -> boolean,
    read Tetrahedron: (self: Simplex) -> boolean,
    read NextSimplex: (self: Simplex) -> boolean,

    read Size: (self: Simplex) -> number,
    read GetTetraPoints: (self: Simplex) -> (MPoint, MPoint, MPoint, MPoint)
    
}

export type SimplexMetatable = {
    read __index: SimplexMethods
}

export type Simplex = SimplexVars & SimplexMethods

return {}