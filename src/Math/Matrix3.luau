--!strict
const Matrix3Typing = require("../Typings/Matrix3Typing")
const MathUtils = require("../Utils/Math")

type Matrix3 = Matrix3Typing.Matrix3
type Matrix3Methods = Matrix3Typing.Matrix3Methods
type Matrix3Class = Matrix3Typing.Matrix3Class

const Matrix3Class: Matrix3Class = {} :: any

const ClassMethods: Matrix3Typing.Matrix3Methods = table.freeze({
	GetRows = function(self: Matrix3): (vector, vector, vector)
		return self.Rows[1], self.Rows[2], self.Rows[3]
	end,

	GetCols = function(self: Matrix3): (vector, vector, vector)
		local Row1, Row2, Row3 = self:GetRows()

		return vector.create(Row1.x, Row2.x, Row3.x), vector.create(Row1.y, Row2.y, Row3.y), vector.create(Row1.z, Row2.z, Row3.z)
	end,

	Determinant = function(self: Matrix3): number
		local R1, R2, R3 = self:GetRows()

		local C11 = (R2.y * R3.z - R2.z * R3.y)
		local C12 = -(R2.x * R3.z - R2.z * R3.x)
		local C13 = (R2.x * R3.y - R2.y * R3.x)

		return R1.x * C11 + R1.y * C12 + R1.z * C13
	end,

	Transpose = function(self: Matrix3): Matrix3
		local Row1, Row2, Row3 = self:GetRows()

		return Matrix3Class.new({
			vector.create(Row1.x, Row2.x, Row3.x),
			vector.create(Row1.y, Row2.y ,Row3.y),
			vector.create(Row1.z, Row2.z ,Row3.z),
		})
	end,

	Inverse = function(self: Matrix3): Matrix3
		local R1, R2, R3 = self:GetRows()

		-- Minor values of matrix

		local C11 = (R2.y * R3.z - R2.z * R3.y)
		local C12 = -(R2.x * R3.z - R2.z * R3.x)
		local C13 = (R2.x * R3.y - R2.y * R3.x)

		local C21 = -(R1.y * R3.z - R1.z * R3.y)
		local C22 = (R1.x * R3.z - R1.z * R3.x)
		local C23 = -(R1.x * R3.y - R1.y * R3.x)

		local C31 = (R1.y * R2.z - R1.z * R2.y)
		local C32 = -(R1.x * R2.z - R1.z * R2.x)
		local C33 = (R1.x * R2.y - R1.y * R2.x)

		-- Reciprical of determinant (The cofactor values of the first row contain the info needed for deter)

		local Det = (R1.x * C11 + R1.y * C12 + R1.z * C13)

		if math.abs(Det) < MathUtils.Epsilon then
			return Matrix3Class.Zero()
		end

		local RDet = 1/Det

		-- Manually transpose the matrix for max performance and multiply it by 1/det

		return Matrix3Class.new({
			vector.create(C11 * RDet, C21 * RDet, C31 * RDet),
			vector.create(C12 * RDet, C22 * RDet, C32 * RDet),
			vector.create(C13 * RDet, C23 * RDet, C33 * RDet),
		})
	end,
	
	Beautify = function(self: Matrix3): string 
		const Row1, Row2, Row3 = self:GetRows()
		return `\n     [{Row1.x}, {Row1.y}, {Row1.z}]\n M = [{Row2.x}, {Row2.y}, {Row2.z}]\n     [{Row3.x}, {Row3.y}, {Row3.z}]`
	end,
})

const function MultiplyMatrixVec(Matrix: Matrix3, Vector: vector)

	local R1, R2, R3 = Matrix:GetRows()

	local A11, A12, A13 = R1.x, R1.y, R1.z
	local A21, A22, A23 = R2.x, R2.y, R2.z
	local A31, A32, A33 = R3.x, R3.y, R3.z

	local B11, B21, B31 = Vector.x, Vector.y, Vector.z

	return vector.create(
		(A11 * B11) + (A12 * B21) + (A13 * B31), 
		(A21 * B11) + (A22 * B21) + (A23 * B31),
		(A31 * B11) + (A32 * B21) + (A33 * B31)
	)

end

const function MultiplyVecMatrix(Vector: vector, Matrix: Matrix3)

	local R1, R2, R3 = Matrix:GetRows()

	local A11, A12, A13 = R1.x, R1.y, R1.z
	local A21, A22, A23 = R2.x, R2.y, R2.z
	local A31, A32, A33 = R3.x, R3.y, R3.z

	local B11, B21, B31 = Vector.x, Vector.y, Vector.z

	return vector.create(
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
				vector.create(BRow1.x + A, BRow1.y + A, BRow1.z + A),
				vector.create(BRow2.x + A, BRow2.y + A, BRow2.z + A),
				vector.create(BRow3.x + A, BRow3.y + A, BRow3.z + A),
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			const ARow1, ARow2, ARow3 = A.Rows[1], A.Rows[2], A.Rows[3]

			return Matrix3Class.new({
				vector.create(ARow1.x + B, ARow1.y + B, ARow1.z + B),
				vector.create(ARow2.x + B, ARow2.y + B, ARow2.z + B),
				vector.create(ARow3.x + B, ARow3.y + B, ARow3.z + B),
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
				vector.create(BRow1.x - A, BRow1.y - A, BRow1.z - A),
				vector.create(BRow2.x - A, BRow2.y - A, BRow2.z - A),
				vector.create(BRow3.x - A, BRow3.y - A, BRow3.z - A),
			})
		elseif typeof(A) == "table" and typeof(B) == "number" then
			const ARow1, ARow2, ARow3 = A.Rows[1], A.Rows[2], A.Rows[3]

			return Matrix3Class.new({
				vector.create(ARow1.x - B, ARow1.y - B, ARow1.z - B),
				vector.create(ARow2.x - B, ARow2.y - B, ARow2.z - B),
				vector.create(ARow3.x - B, ARow3.y - B, ARow3.z - B),
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

	__mul = function(A: Matrix3 | number | vector, B: Matrix3 | number | vector): Matrix3 | vector

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

			const C11 = vector.dot(ARow1, BCol1)
			const C12 = vector.dot(ARow1, BCol2)
			const C13 = vector.dot(ARow1, BCol3)
			const C21 = vector.dot(ARow2, BCol1)
			const C22 = vector.dot(ARow2, BCol2)
			const C23 = vector.dot(ARow2, BCol3)
			const C31 = vector.dot(ARow3, BCol1)
			const C32 = vector.dot(ARow3, BCol2)
			const C33 = vector.dot(ARow3, BCol3)

			return Matrix3Class.new({
				vector.create(C11, C12, C13),
				vector.create(C21, C22, C23),
				vector.create(C31, C32, C33)
			})
		elseif typeof(A) == "table" and typeof(B) == "vector" then
			return MultiplyMatrixVec(A, B)
		elseif typeof(A) == "vector" and typeof(B) == "table" then
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
			vector.create(ARow1.x ^ BRow1.x, ARow1.y ^ BRow1.y, ARow1.z ^ BRow1.z),
			vector.create(ARow2.x ^ BRow2.x, ARow2.y ^ BRow2.y, ARow2.z ^ BRow2.z),
			vector.create(ARow3.x ^ BRow3.x, ARow3.y ^ BRow3.y, ARow3.z ^ BRow3.z),
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
			vector.create(ARow1.x % BRow1.x, ARow1.y % BRow1.y, ARow1.z % BRow1.z),
			vector.create(ARow2.x % BRow2.x, ARow2.y % BRow2.y, ARow2.z % BRow2.z),
			vector.create(ARow3.x % BRow3.x, ARow3.y % BRow3.y, ARow3.z % BRow3.z),
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

function Matrix3Class.OuterProduct(A: vector, B: vector): Matrix3
	return Matrix3Class.new({
		vector.create(A.x * B.x, A.x * B.y, A.x * B.z),
		vector.create(A.y * B.x, A.y * B.y, A.y * B.z),
		vector.create(A.z * B.x, A.z * B.y, A.z * B.z),
	})
end

function Matrix3Class.Diagonal(Diagonal: vector) : Matrix3
	return Matrix3Class.new({
		vector.create(Diagonal.x, 0, 0),
		vector.create(0, Diagonal.y, 0),
		vector.create(0, 0, Diagonal.z)
	})
end

function Matrix3Class.Zero(): Matrix3
	return Matrix3Class.new({
		vector.zero,
		vector.zero,
		vector.zero
	})
end

function Matrix3Class.Identity(): Matrix3
	return Matrix3Class.new({
		vector.create(1, 0, 0),
		vector.create(0, 1, 0),
		vector.create(0, 0, 1),
	})
end

table.freeze(Matrix3Class)

return Matrix3Class

