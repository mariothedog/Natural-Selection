class_name Util

static func sum(arr: Array) -> float:
	var total := 0.0
	for num in arr:
		total += num
	return total

static func average(arr: Array) -> float:
	return sum(arr) / len(arr)
