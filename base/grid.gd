extends PanelContainer
class_name Gird

signal chess_droped
signal drop_ok(player:String)

@onready var button: Button = $MarginContainer/button

var player :String

func _ready() -> void:
	button.pressed.connect(drop_chess)

func drop_chess() -> void:
	chess_droped.emit(get_index())
	
func set_chess(color: String = "black") -> void:
	player = color
	if player == "black":
		button.text = "X"
	else :
		button.text = "O"
	button.disabled = true
	drop_ok.emit(color)
		
	
