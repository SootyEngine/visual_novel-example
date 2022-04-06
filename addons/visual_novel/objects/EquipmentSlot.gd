extends BaseDataClass
class_name EquipmentSlot

var name := ""
var desc := ""
var bare := [] # slots to bear when equipped
var block := [] # items that can't be worn even if wearable to this slot
var allow := [] # items that can be worn even if not wearable to this slot
