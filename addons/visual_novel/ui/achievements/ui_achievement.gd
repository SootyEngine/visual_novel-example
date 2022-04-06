extends Node

@export var _label: NodePath
@export var _icon: NodePath
@export var _progress: NodePath
@onready var label: RichTextLabel2 = get_node(_label)
@onready var icon: TextureRect = get_node(_icon)
@onready var progress: ProgressBar = get_node(_progress)

func _setup(a: Award):
	if a.toll > 1:
		progress.visible = true
		progress.value = a._progress * progress.max_value
	else:
		progress.visible = false
	
	if a._unlocked:
		icon.modulate.v = 1.0
		var when = DateTime.create_from_total_seconds(a.date).format("{year} {month_short_capitalized} {day_of_month_ordinal} ({since})")
		label.set_bbcode("[b;dodger_blue]%s[]\n%s\n[dim;dim;i]%s[]" % [a.name, a.desc, when])
	else:
		icon.modulate.v = 0.125
		label.set_bbcode("[b;deep_sky_blue;dim]%s[]\n[i;dim]%s[]" % [a.name, a.desc + "???"])
