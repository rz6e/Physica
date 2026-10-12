export type Matrix3Vars = {
	read Rows: {vector},
}

export type Matrix3Methods = {
	read GetRows: (self: Matrix3) -> (vector, vector, vector),
	read GetCols: (self: Matrix3) -> (vector, vector, vector),

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
	& ((Matrix3, vector) -> vector),
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
	new: (Matrix: {vector}) -> Matrix3,
	OuterProduct: (A: vector, B: vector) -> Matrix3,
	Diagonal: (Diagonal: vector) -> Matrix3,
	Zero: () -> Matrix3,
	Identity: () -> Matrix3,
}


return {}