extends RefCounted
class_name InventoryItem

var id := "" # item type
var sum := 0 # total
var data := {}

func _init(type: String, total := 1, other := {}) -> void:
	id = type
	sum = total
	data = other

func get_item_info() -> ItemInfo:
	return State.item_info[id]

func _to_string() -> String:
	if data:
		var out := []
		for k in data:
			out.append("%s: %s" % [k, data[k]])
		return "InventoryItem(%s x%s {%s})" % [id, sum, ", ".join(out)]
	else:
		return "InventoryItem(%s x%s)" % [id, sum]
