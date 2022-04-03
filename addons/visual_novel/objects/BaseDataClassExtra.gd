extends BaseDataClass
class_name BaseDataClassExtra

const DEFAULT_FORMAT := "[b]{name}[]"
var data := {}

func _init(d := {}):
	UObject.patch(self, d, true)
	for k in d:
		data[k] = d[k]
	_post_init.call_deferred()

func _get(property: StringName):
	if str(property) in data:
		return data[str(property)]

func _set(property: StringName, value) -> bool:
	if str(property) in data:
		data[str(property)] = value
		return true
	return false

func as_string() -> String:
	if "format" in self:
		if self.format == "":
			if Global.config.has_section_key("default_formats", get_class()):
				var fmt = Global.config.get_value("default_formats", get_class(), DEFAULT_FORMAT)
				return fmt.format(UObject.get_state(self))
		else:
			return self.format.format(UObject.get_state(self))
	
	return DEFAULT_FORMAT.format(UObject.get_state(self))
