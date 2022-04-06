extends BaseDataClass
class_name Inventory

func get_class() -> String:
	return "Inventory"

signal gained(item_info: ItemInfo, quantity: int)
signal lost(item_info: ItemInfo, quantity: int)

var _character: Character
var slots := []

# called by UObject
func _added(parent: BaseDataClass):
	_character = parent

func _patch(key: String, type: String, patch: Variant, sources: Array):
#	match key:
#		"items":
		patch = UObject.patch_to_var(patch, sources, TYPE_INT)
		gain.call_deferred(key, patch)
#		match typeof(patch):
#			TYPE_ARRAY:
#				for item in patch:
#					gain(item)
#			TYPE_DICTIONARY:
#				for k in patch:
#					gain(k, patch[k])
#			_:
#				push_error("Not implemented %s %s." % [key, patch])

func _get(property: StringName):
	if has(str(property)):
		return count(str(property))

func has(type: String, quantity := 1) -> bool:
	var q := 0
	for i in len(slots):
		if slots[i].id == type:
			q += slots[i].sum
		if q >= quantity:
			return true
	return false

func count(type: String) -> int:
	var out := 0
	for i in len(slots):
		if slots[i].id == type:
			out += slots[i].sum
	return out

func gain(type: String, quantity := 1, _meta := {}):
	var all_items: ItemInfos = State.item_info
	var info: ItemInfo = all_items.find(type, "gain")
	if not info:
		return
	
	# try to append to previous slots
	var q := quantity
	for slot in slots:
		if slot.id == type and slot.sum < info.slot_max:
			var amount := mini(info.slot_max, q)
			slot.sum += amount
			q -= amount
			if q <= 0:
				break
	
	# create new slots for leftovers
	for i in ceil(q / float(info.slot_max)):
		var amount := mini(info.slot_max, q)
		q -= amount
		_add_slot(type, amount)
	
	var dif := quantity - q
	gained.emit(info, dif)

func lose(type: String, quantity := 1, _meta := {}):
	var all_items: ItemInfos = State.item_info
	var info: ItemInfo = all_items.find(type, "gain")
	if not info:
		return
	
	var q := quantity
	for i in range(len(slots)-1, -1, -1):
		var slot: InventoryItem = slots[i]
		if slot.id == type:
			var amount := mini(slot.sum, q)
			slot.sum -= amount
			q -= amount
			if q <= 0:
				slots.remove_at(i)
				break
	
	var dif := quantity - q
	lost.emit(info, dif)

func _add_slot(type: String, total: int):
	slots.append(InventoryItem.new(type, total))
