export type Matrix3Vars = {
	read Rows: {Vector3},
}

export type Matrix3Methods = {
	read GetRows: (self: Matrix3) -> (Vector3, Vector3, Vector3),
	read GetCols: (self: Matrix3) -> (Vector3, Vector3, Vector3),

	read Determinant: (self: Matrix3) -> number,
	read Transpose: (self: Matrix3) -> Matrix3,
	read Inverse: (self: Matrix3) -> Matrix3,
	read Beautify: (self: Matrix3) -> string
}

export type Matrix3Metatable = {
	read __index: Matrix3Methods,

	read __mul:
		((Matrix3, Matrix3) -> Matrix3)
	& ((Matrix3, number) -> Matrix3)
	& ((number, Matrix3) -> Matrix3)
	& ((Matrix3, Vector3) -> Vector3),
	read __sub:
		((Matrix3, Matrix3) -> Matrix3)
	& ((Matrix3, number) -> Matrix3)
	& ((number, Matrix3) -> Matrix3),
	read __add:
		((Matrix3, Matrix3) -> Matrix3)
	& ((Matrix3, number) -> Matrix3)
	& ((number, Matrix3) -> Matrix3),
	read __div:
		((Matrix3, Matrix3) -> Matrix3)
	& ((Matrix3, number) -> Matrix3)
	& ((number, Matrix3) -> Matrix3),
	read __mod: (Matrix3, Matrix3) -> Matrix3,
	read __pow: (Matrix3, Matrix3) -> Matrix3,
}

export type Matrix3 = setmetatable<Matrix3Vars, Matrix3Metatable>

export type Matrix3Class = {
	new: (Matrix: {Vector3}) -> Matrix3,
	OuterProduct: (A: Vector3, B: Vector3) -> Matrix3,
	Diagonal: (Diagonal: Vector3) -> Matrix3,
	Zero: () -> Matrix3,
	Identity: () -> Matrix3,
}


return {}