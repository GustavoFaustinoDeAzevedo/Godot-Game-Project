extends RefCounted
class_name GridTrace

#===============================================================================
# PUBLIC
#===============================================================================

static func trace(
	from: Vector3i,
	to: Vector3i
) -> Array[Vector3i]:

	if from == to:
		return [from]

	return _bresenham_3d(from, to)

#===============================================================================
# INTERNAL
#===============================================================================

static func _bresenham_3d(
	from: Vector3i,
	to: Vector3i
) -> Array[Vector3i]:

	var result: Array[Vector3i] = []

	var x1 := from.x
	var y1 := from.y
	var z1 := from.z

	var x2 := to.x
	var y2 := to.y
	var z2 := to.z

	var dx = abs(x2 - x1)
	var dy = abs(y2 - y1)
	var dz = abs(z2 - z1)

	var xs := 1 if x2 > x1 else -1
	var ys := 1 if y2 > y1 else -1
	var zs := 1 if z2 > z1 else -1

	var x := x1
	var y := y1
	var z := z1

	result.append(Vector3i(x, y, z))

	if dx >= dy and dx >= dz:

		var p1 = 2 * dy - dx
		var p2 = 2 * dz - dx

		while x != x2:

			x += xs

			if p1 >= 0:
				y += ys
				p1 -= 2 * dx

			if p2 >= 0:
				z += zs
				p2 -= 2 * dx

			p1 += 2 * dy
			p2 += 2 * dz

			result.append(Vector3i(x, y, z))

	elif dy >= dx and dy >= dz:

		var p1 = 2 * dx - dy
		var p2 = 2 * dz - dy

		while y != y2:

			y += ys

			if p1 >= 0:
				x += xs
				p1 -= 2 * dy

			if p2 >= 0:
				z += zs
				p2 -= 2 * dy

			p1 += 2 * dx
			p2 += 2 * dz

			result.append(Vector3i(x, y, z))

	else:

		var p1 = 2 * dy - dz
		var p2 = 2 * dx - dz

		while z != z2:

			z += zs

			if p1 >= 0:
				y += ys
				p1 -= 2 * dz

			if p2 >= 0:
				x += xs
				p2 -= 2 * dz

			p1 += 2 * dy
			p2 += 2 * dx

			result.append(Vector3i(x, y, z))

	return result
