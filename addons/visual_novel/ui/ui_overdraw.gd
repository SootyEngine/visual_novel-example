extends Node2D

const FONT := preload("res://addons/sooty_engine/fonts/font-r.tres")

func _process(delta: float) -> void:
	update()

func _draw() -> void:
	return
	
	var h := DialogueStack._halting_for
	if len(h):
		draw_string(FONT, Vector2(16, 24), "Waiting for:", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.SLATE_GRAY, 4, Color.SLATE_GRAY.darkened(.33))
		for i in len(h):
			var halter = h[i]
			draw_string(FONT, Vector2(16, 24 + (i+1) * 24), "\t"+str(halter), HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.SLATE_GRAY, 4, Color.SLATE_GRAY.darkened(.33))
