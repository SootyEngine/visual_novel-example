@tool
extends Control

func _process(delta: float) -> void:
	update()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, rect_size), Color.RED, false, 4.0)
