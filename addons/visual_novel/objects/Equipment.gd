extends BaseDataClass
class_name Equipment

func get_class() -> String:
	return "Equipment"

signal equipped(item_info: ItemInfo, slot: String)
signal unequipped(item_info: ItemInfo, slot: String)

var _character: Character
var _inventory: Inventory
var worn := {}

# called by UObject when added to an object
func _added(parent: BaseDataClassExtendable):
	_character = parent
	_inventory = UObject.get_first_property_of_object_type(parent, Inventory)

func _patch(key: String, type: String, patch: Variant, sources: Array):
	patch = UObject.patch_to_var(patch, sources, TYPE_STRING)
	wear.call_deferred(patch, key, true)

func get_slot_info():
	pass

func wear(item_id: String, slot: String = "", gain_if_has_not := false):
	var all_items: ItemInfos = State.item_info
	var item_info: ItemInfo = all_items.find(item_id, "wear")
	if not item_info:
		return
	
	# has item in inventory?
	if not _inventory.has(item_id) and not gain_if_has_not:
		push_error("Can't wear item you don't have. Call wear(id, slot, true).")
		return
	
	# item is wearable?
	if not item_info.is_wearable():
		push_error("Item '%s' isn't wearable." % item_id)
		return
	
	# does slot exist?
	var all_slots: EquipmentSlots = State.equipment_slots
	var slot_info: EquipmentSlot = all_slots.find(slot, "equip")
	if not slot_info:
		return
	
	# take off items in other slots
	if slot in worn:
		bare_at(slot)
	
	# bare any other slots
	for b in all_slots[slot].bare:
		bare_at(b)
	
	worn[slot] = InventoryItem.new(item_id)

func bare(item_id: String):
	for slot in worn:
		if worn[slot].type == item_id:
			worn.erase(slot)
			break

func bare_at(slot: String):
	if slot in worn:
		pass

