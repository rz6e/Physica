--!strict
--!native

-- Quaternions allow 3D orientations to be represented as 4 floating point numbers as oppose to 3x3 matrices with 9.
-- Known as (q = w + xi + yj + zk)
-- Fundamental Formula (i^2 = j^2 = k^2 = ijk = -1)

const QuaternionTyping = require "../Typings/QuaternionTyping"

type Quaternion = QuaternionTyping.Quaternion
type QuaternionVars = QuaternionTyping.QuaternionVars
type QuaternionMethods = QuaternionTyping.QuaternionMethods

const QuaternionClass = {}

const ClassMethods: Quaternion = table.freeze({})

const MethodsMetatable: QuaternionTyping.QuaternionMetatable = table.freeze({
    __index = ClassMethods
})

function QuaternionClass.new()

    const QuaternionVars: QuaternionVars = {

    }

    const Quaterinion: Quaternion = setmetatable(QuaternionVars, MethodsMetatable)

    return Quaterinion

end

table.freeze(QuaternionClass)

return QuaternionClass