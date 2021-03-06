extends Node
class_name Fader

const DEFAULT_TIME := 0.25

static func create(callback: Variant, done_callback: Variant = null, kwargs := {}):
	var node = load("res://addons/visual_novel/fader/fader.tscn").instantiate()
	Global.add_child(node)
	node.setup(callback, done_callback, kwargs)

func setup(callback: Variant, done_callback: Variant = null, kwargs := {}):
	get_tree().paused = true
	
	var t := get_tree().create_tween()
	t.bind_node(self)
	
	if "wait" in kwargs:
		t.tween_interval(kwargs.wait)
	
	$backing.modulate = kwargs.get("color", Color.BLACK)
	match kwargs.get("anim", "in_out"):
		"in":
			$backing.modulate.a = 1.0
			t.tween_property($backing, "modulate:a", 0.0, kwargs.get("time", DEFAULT_TIME))
			if callback is Callable:
				t.tween_interval(.1) # wait a tick before calling, so fully faded out
				t.tween_callback(callback)
		"in_out":
			$backing.modulate.a = 0.0
			t.tween_property($backing, "modulate:a", 1.0, kwargs.get("time", DEFAULT_TIME))
			if callback is Callable:
				t.tween_interval(.1) # wait a tick before calling, so fully faded out
				t.tween_callback(callback)
			t.tween_property($backing, "modulate:a", 0.0, kwargs.get("time", DEFAULT_TIME))
	
	t.tween_callback(queue_free)
	t.tween_callback(get_tree().set_pause.bind(false))
	
	if done_callback != null and done_callback is Callable:
		t.tween_callback(done_callback as Callable)
	
