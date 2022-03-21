extends Node2D

@onready var sprite: Sprite2DAnimations = $sprite

func _init() -> void:
	add_to_group("sa:anim")
	
func _ready() -> void:
	$sprite.fade_in()

func anim(action: String, args := []):
	if sprite.has_method(action):
		sprite.callv(action, args)
	else:
		push_error("%s has no '%s'." % [self, action])
