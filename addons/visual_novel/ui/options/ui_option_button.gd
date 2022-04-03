extends Button

@export var _label: NodePath
@export var _backing: NodePath
@onready var label: RichTextLabel2 = get_node(_label)
@onready var backing: ColorRect = get_node(_backing)

var option: DialogueLine:
	set = set_option

var hovered := false:
	set(h):
		if h != hovered:
			hovered = h
			backing.modulate.a = 1.0 if hovered else 0.0
			_update_text()

func _ready() -> void:
	backing.modulate.a = 0.0

func set_option(o: DialogueLine):
	option = o
	disabled = not option.passed
	_update_text()
	
func _update_text():
	var text = option.text
	
	if not option.passed:
		text = "[dim][lb]DBG[rb]%s[]" % text
	
	if hovered:
		label.set_bbcode("[dim]「[] [sin;%s]%s[] [dim]」[]" % [Color.BURLYWOOD, text])
	else:
		label.set_bbcode("[dim]%s[]" % [text])

func is_mouse_over():
	return backing.get_rect().has_point(backing.get_local_mouse_position())
