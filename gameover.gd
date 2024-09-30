extends Panel

const MAIN = preload("res://main.tscn")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		restart()

func restart() -> void:
	var root = get_tree().root
	for child in root.get_children():
		child.queue_free()
	var new_game = MAIN.instantiate()
	root.add_child(new_game)
