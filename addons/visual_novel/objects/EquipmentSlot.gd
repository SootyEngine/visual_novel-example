extends Data
class_name EquipmentSlot
func get_class() -> String:
	return "EquipmentSlot"

var name := ""
var desc := ""
var bare := [] # slots to bear when equipped

var block_items := [] # items that can't be worn even if wearable to this slot
var allow_items := [] # items that can be worn even if not wearable to this slot
var block_types := []
var allow_types := []

func can_equip(item: Item) -> bool:
	var items: ItemManager = State.get_first(ItemManager)
	var id = items.get_id(item)
	if id in block_items:
		return false
	
	if id in allow_items:
		return true
	
	return false
