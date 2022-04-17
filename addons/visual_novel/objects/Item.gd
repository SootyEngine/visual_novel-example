extends PatchableData
class_name Item, "res://addons/visual_novel/icons/item.png"

var name := ""
var desc := ""
var worn_to := []
var slot_max := 1:
	get: return 1 if is_wearable() else slot_max

func is_wearable() -> bool:
	return len(worn_to) > 0
