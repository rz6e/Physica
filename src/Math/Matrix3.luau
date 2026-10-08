--!strict
local Matrix3Typing = require("../Typings/Matrix3Typing")
local MathUtils = require("../Utils/Math")

type Matrix3 = Matrix3Typing.Matrix3
type Matrix3Methods = Matrix3Typing.Matrix3Methods
type Matrix3Class = Matrix3Typing.Matrix3Class

const Matrix3Class: Matrix3Class = {} :: any

const ClassMethods: Matrix3Typing.Matrix3Methods = table.freeze({
	GetRows = function(self: Matrix3): (Vector3, Vector3, Vector3)
		return self.Rows[1], self.Rows[2], self.Rows[3]
	end,

	GetCols = function(self: Matrix3): (Vector3, Vector3, Vector3)
		local Row1, Row2, Row3 = self:GetRows()

		return Vector3.new(Row1.X, Row2.X, Row3.X), Vector3.new(Row1.Y, Row2.Y, Row3.Y), Vector3.new(Row1.Z, Row2.Z, Row3.Z)
	end,

	Determinant = function(self: Matrix3): number
		local R1, R2, R3 = self:GetRows()

		local C11 = (R2.Y * R3.Z - R2.Z * R3.Y)
		local C12 = -(R2.X * R3.Z - R2.Z * R3.X)
		local C13 = (R2.X * R3.Y - R2.Y * R3.X)

		return R1.X * C11 + R1.Y * C12 + R1.Z * C13
	end,

	Transpose = function(self: Matrix3): Matrix3
		local Row1, Row2, Row3 = self:GetRows()

		return Matrix3Class.new({
			Vector3.new(Row1.X, Row2.X, Row3.X),
			Vector3.new(Row1.Y, Row2.Y ,Row3.Y),
			Vector3.new(Row1.Z, Row2.Z ,Row3.Z),
		})
	end,

	Inverse = function(self: Matrix3): Matrix3
		local R1, R2, R3 = self:GetRows()

		-- Minor values of matrix

		local C11 = (R2.Y * R3.Z - R2.Z * R3.Y)
		local C12 = -(R2.X * R3.Z - R2.Z * R3.X)
		local C13 = (R2.X * R3.Y - R2.Y * R3.X)

		local C21 = -(R1.Y * R3.Z - R1.Z * R3.Y)
		local C22 = (R1.X * R3.Z - R1.Z * R3.X)
		local C23 = -(R1.X * R3.Y - R1.Y * R3.X)

		local C31 = (R1.Y * R2.Z - R1.Z * R2.Y)
		local C32 = -(R1.X * R2.Z - R1.Z * R2.X)
		local C33 = (R1.X * R2.Y - R1.Y * R2.X)

		-- Reciprical of determinant (The cofactor values of the first row contain the info needed for deter)

		local Det = (R1.X * C11 + R1.Y * C12 + R1.Z * C13)

		if math.abs(Det) < MathUtils.Epsilon then
			return Matrix3Class.Zero()
		end

		local RDet = 1/Det

		-- Manually transpose the matrix for max performance and multiply it by 1/det

		return Matrix3Class.new({
			Vector3.new(C11 * RDet, C21 * RDet, C31 * RDet),
			Vector3.new(C12 * RDet, C22 * RDet, C32 * RDet),
			Vector3.new(C13 * RDet, C23 * RDet, C33 * RDet),
		})
	end,
	
	Beautify = function(self: Matrix3): string 
		const Row1, Row2, Row3 = self:GetRows()
		return `\n     [{Row1.X}, {Row1.Y}, {Row1.Z}]\n M = [{Row2.X}, {Row2.Y}, {Row2.Z}]\n     [{Row3.X}, {Row3.Y}, {Row3.Z}]`
	end,
})

const function MultiplyMatrixVec(Matrix: Matrix3, Vector: Vector3)

	local R1, R2, R3 = Matrix:GetRows()

	local A11, A12, A13 = R1.X, R1.Y, R1.Z
	local A21, A22, A23 = R2.X, R2.Y, R2.Z
	local A31, A32, A33 = R3.X, R3.Y, R3.Z

	local B11, B21, B31 = Vector.X, Vector.Y, Vector.Z

	return Vector3.new(
		(A11 * B11) + (A12 * B21) + (A13 * B31), 
		(A21 * B11) + (A22 * B21) + (A23 * B31),
		(A31 * B11) + (A32 * B21) + (A33 * B31)
	)

end

const function MultiplyVecMatrix(Vector: Vector3, Matrix: Matrix3)

	local R1, R2, R3 = Matrix:GetRows()

	local A11, A12, A13 = R1.X, R1.Y, R1.Z
	local A21, A22, A23 = R2.X, R2.Y, R2.Z
	local A31, A32, A33 = R3.X, R3.Y, R3.Z

	local B11, B21, B31 = Vector.X, Vector.Y, Vector.Z

	return Vector3.new(
		(B11 * A11) + (B21 * A21) + (B31 * A31), 
		(B11 * A12) + (B21 * A22) + (B31 * A32),
		(B11 * A13) + (B21 * A23) + (B31 * A33)
	)

end


const MethodsMetatable: Matrix3Typing.Matrix3Metatable = table.freeze({ 
	__index = ClassMethods ,

	__add = function(A: Matrix3 | number, B: Matrix3 | number): Matrix3

		if typeof(A) == "table" and typeof(B) == "table" then
			return Matrix3Class.new({
				A.Rows[1] + B.Rows[1],
				A.Rows[2] + B.Rows[2],
				A.Rows[3] + B.Rows[3],
			})
		elseif typeof(A) == "number" and typeof(B) == "table" then
			const BRow1, BRow2, BRow3 = B.Rows[1], B.Rows[2], B.Rows[3]

			return Matrix3Class.new({
				Vector3.new(BRow1.X + A, BRow1.Y + A, BRow1.Z + A),
				Vector3.new(BRow2.X + A, BRow2.Y + A, BRow2.Z + A),
				Vector3.new(BRow3.X + A, BRow3.Y + A, BRow3.Z + A),
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			const ARow1, ARow2, ARow3 = A.Rows[1], A.Rows[2], A.Rows[3]

			return Matrix3Class.new({
				Vector3.new(ARow1.X + B, ARow1.Y + B, ARow1.Z + B),
				Vector3.new(ARow2.X + B, ARow2.Y + B, ARow2.Z + B),
				Vector3.new(ARow3.X + B, ARow3.Y + B, ARow3.Z + B),
			})
		end

		return error(`attempt to perform arithmetic (mul) on {typeof(A)} and {typeof(B)}`)

	end,

	__sub = function(A: Matrix3 | number, B: Matrix3 | number): Matrix3

		if typeof(A) == "table" and typeof(B) == "table" then
			return Matrix3Class.new({
				A.Rows[1] - B.Rows[1],
				A.Rows[2] - B.Rows[2],
				A.Rows[3] - B.Rows[3],
			})
		elseif typeof(A) == "number" and typeof(B) == "table" then
			const BRow1, BRow2, BRow3 = B.Rows[1], B.Rows[2], B.Rows[3]

			return Matrix3Class.new({
				Vector3.new(BRow1.X - A, BRow1.Y - A, BRow1.Z - A),
				Vector3.new(BRow2.X - A, BRow2.Y - A, BRow2.Z - A),
				Vector3.new(BRow3.X - A, BRow3.Y - A, BRow3.Z - A),
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			const ARow1, ARow2, ARow3 = A.Rows[1], A.Rows[2], A.Rows[3]

			return Matrix3Class.new({
				Vector3.new(ARow1.X - B, ARow1.Y - B, ARow1.Z - B),
				Vector3.new(ARow2.X - B, ARow2.Y - B, ARow2.Z - B),
				Vector3.new(ARow3.X - B, ARow3.Y - B, ARow3.Z - B),
			})
		end

		return error(`attempt to perform arithmetic (sub) on {typeof(A)} and {typeof(B)}`)

	end,

	__div = function(A: Matrix3 | number, B: Matrix3 | number): Matrix3

		if typeof(A) == "table" and typeof(B) == "table" then
			return Matrix3Class.new({
				A.Rows[1] / B.Rows[1],
				A.Rows[2] / B.Rows[2],
				A.Rows[3] / B.Rows[3],
			})
		elseif typeof(A) == "number" and typeof(B) == "table" then
			return Matrix3Class.new({
				A / B.Rows[1],
				A / B.Rows[2],
				A / B.Rows[3],
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			return Matrix3Class.new({
				A.Rows[1] / B,
				A.Rows[2] / B,
				A.Rows[3] / B,
			})
		end

		return error(`attempt to perform arithmetic (div) on {typeof(A)} and {typeof(B)}`)

	end,


	__mul = function(A: Matrix3 | number | Vector3, B: Matrix3 | number | Vector3): Matrix3 | Vector3

		if typeof(A) == "table" and typeof(B) == "table" then
			const ARow1, ARow2, ARow3 = A:GetRows()
			-- local ACol1, ACol2, ACol3 = A:GetCols()
			-- local BRow1, BRow2, BRow3 = B:GetRows()
			const BCol1, BCol2, BCol3 = B:GetCols()

			--local a, b, c = ARow1
			--local d, e, f = ARow2
			--local g, h, i = ARow3

			--local j, k, l = BRow1
			--local m, n, o = BRow2
			--local p, q, r = BRow3

			const C11 = ARow1:Dot(BCol1)
			const C12 = ARow1:Dot(BCol2)
			const C13 = ARow1:Dot(BCol3)
			const C21 = ARow2:Dot(BCol1)
			const C22 = ARow2:Dot(BCol2)
			const C23 = ARow2:Dot(BCol3)
			const C31 = ARow3:Dot(BCol1)
			const C32 = ARow3:Dot(BCol2)
			const C33 = ARow3:Dot(BCol3)

			return Matrix3Class.new({
				Vector3.new(C11, C12, C13),
				Vector3.new(C21, C22, C23),
				Vector3.new(C31, C32, C33)
			})
		elseif typeof(A) == "table" and typeof(B) == "Vector3" then
			return MultiplyMatrixVec(A, B)
		elseif typeof(A) == "Vector3" and typeof(B) == "table" then
			return MultiplyVecMatrix(A, B)
		elseif typeof(A) == "number" and typeof(B) == "table" then
			return Matrix3Class.new({
				A * B.Rows[1],
				A * B.Rows[2],
				A * B.Rows[3],
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			return Matrix3Class.new({
				A.Rows[1] * B,
				A.Rows[2] * B,
				A.Rows[3] * B,
			})
		end

		return error(`attempt to perform arithmetic (mul) on {typeof(A)} and {typeof(B)}`)

	end :: any,

	__pow = function(A: Matrix3, B: Matrix3): Matrix3
		const ARow1 = A.Rows[1]
		const ARow2 = A.Rows[2]
		const ARow3 = A.Rows[3]

		const BRow1 = B.Rows[1]
		const BRow2 = B.Rows[2]
		const BRow3 = B.Rows[3]

		return Matrix3Class.new({
			Vector3.new(ARow1.X ^ BRow1.X, ARow1.Y ^ BRow1.Y, ARow1.Z ^ BRow1.Z),
			Vector3.new(ARow2.X ^ BRow2.X, ARow2.Y ^ BRow2.Y, ARow2.Z ^ BRow2.Z),
			Vector3.new(ARow3.X ^ BRow3.X, ARow3.Y ^ BRow3.Y, ARow3.Z ^ BRow3.Z),
		})
	end,

	__mod = function(A: Matrix3, B: Matrix3): Matrix3
		const ARow1 = A.Rows[1]
		const ARow2 = A.Rows[2]
		const ARow3 = A.Rows[3]

		const BRow1 = B.Rows[1]
		const BRow2 = B.Rows[2]
		const BRow3 = B.Rows[3]

		return Matrix3Class.new({
			Vector3.new(ARow1.X % BRow1.X, ARow1.Y % BRow1.Y, ARow1.Z % BRow1.Z),
			Vector3.new(ARow2.X % BRow2.X, ARow2.Y % BRow2.Y, ARow2.Z % BRow2.Z),
			Vector3.new(ARow3.X % BRow3.X, ARow3.Y % BRow3.Y, ARow3.Z % BRow3.Z),
		})
	end 
})
	
function Matrix3Class.new(Matrix)
	
	const Matrix3Vars: Matrix3Typing.Matrix3Vars = {
		Rows = Matrix
	}
	
	const Matrix3: Matrix3Typing.Matrix3 = setmetatable(Matrix3Vars, MethodsMetatable)
	
	return Matrix3
	
end

function Matrix3Class.OuterProduct(A: Vector3, B: Vector3): Matrix3
	return Matrix3Class.new({
		Vector3.new(A.X * B.X, A.X * B.Y, A.X * B.Z),
		Vector3.new(A.Y * B.X, A.Y * B.Y, A.Y * B.Z),
		Vector3.new(A.Z * B.X, A.Z * B.Y, A.Z * B.Z),
	})
end

function Matrix3Class.Diagonal(Diagonal: Vector3) : Matrix3
	return Matrix3Class.new({
		Vector3.new(Diagonal.X, 0, 0),
		Vector3.new(0, Diagonal.Y, 0),
		Vector3.new(0, 0, Diagonal.Z)
	})
end

function Matrix3Class.Zero(): Matrix3
	return Matrix3Class.new({
		Vector3.zero,
		Vector3.zero,
		Vector3.zero
	})
end

function Matrix3Class.Identity(): Matrix3
	return Matrix3Class.new({
		Vector3.new(1, 0, 0),
		Vector3.new(0, 1, 0),
		Vector3.new(0, 0, 1),
	})
end

table.freeze(Matrix3Class)

return Matrix3Class

