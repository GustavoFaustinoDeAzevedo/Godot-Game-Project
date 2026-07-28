extends RefCounted
class_name EventComparison

const Comparison = EventEnums.Comparison

#===============================================================================

static func compare(
	left,
	right,
	comparison: Comparison
) -> bool:

	match comparison:

		Comparison.EQUAL:
			return left == right

		Comparison.NOT_EQUAL:
			return left != right

		Comparison.GREATER:
			return left > right

		Comparison.GREATER_EQUAL:
			return left >= right

		Comparison.LESS:
			return left < right

		Comparison.LESS_EQUAL:
			return left <= right

	return false
