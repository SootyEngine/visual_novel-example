extends PatchableData
class_name Character

func get_class() -> String:
	return "Character"

var name := ""
var format := ""
var gender := ""
var at := ""
var color := Color.WHITE

func _get(property: StringName):
	var k := str(property)
	
	var lower = k.to_lower()
	var c: Characters = State.characters
	if lower in c.PRONOUNS:
		if gender in c.PRONOUNS[lower]:
			if UString.is_capitalized(k[0]):
				return c.PRONOUNS[lower][gender].capitalized()
			else:
				return c.PRONOUNS[lower][gender]
#	match k:
#		"they": return "he" if gender=="m" else "she" if gender=="f" else "they"
#		"They": return "He" if gender=="m" else "She" if gender=="f" else "They"
#		"theyll": return "he'll" if gender=="m" else "she'll" if gender=="f" else "they'll"
#		"Theyll": return "He'll" if gender=="m" else "She'll" if gender=="f" else "They'll"
#		"theyd": return "he'd" if gender=="m" else "she's" if gender=="f" else "they'd"
#		"Theyd": return "He'd" if gender=="m" else "She's" if gender=="f" else "They'd"
#		"their": return "his" if gender=="m" else "her" if gender=="f" else "their"
#		"Their": return "His" if gender=="m" else "Her" if gender=="f" else "Their"
#		"theyre": return "he's" if gender=="m" else "she's" if gender=="f" else "they're"
#		"Theyre": return "He's" if gender=="m" else "She's" if gender=="f" else "They're"
#
	return super._get(property)

#func as_string() -> String:
#	return "[{color}]{name}[]".format(UObject.get_state(self))
#	if format == "":
#		if Global.config.has_section_key("default_formats", "character_name"):
#			var fmt = Global.config.get_value("default_formats", "character_name", "{name}")
#		else:
#			return name
#	else:
#		return format.format(UObject.get_state(self))
