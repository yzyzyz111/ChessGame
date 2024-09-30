extends HBoxContainer

signal drop_chess_index(index: int)
signal player_drop_ok(player: String)
signal has_winner

@onready var grid_container: GridContainer = $MarginContainer2/GridContainer
@onready var turn: Label = $MarginContainer/Panel/Turn

const GRID = preload("res://UI/grid.tscn")
const COLUMN = 8
const ROW = 8
const player_signs : Dictionary = {
	"black" : "X" ,
	"white" : "O" ,
}

func _ready() -> void:
	grid_container.columns = COLUMN
	creat_chess_board(COLUMN, ROW)
	
func creat_chess_board(x: int, y: int) -> void:
	for i in range(x * y):
		var grid = GRID.instantiate()
		grid_container.add_child(grid)
		grid.chess_droped.connect(drop_chess)
		grid.drop_ok.connect(drop_ok)
		
	
	# help to test if func "man.calculate_grid_neighbors()" creat right neibor index.
	# show every cell`s index.
	#for g in grid_container.get_children():
		#g.button.text = str(g.get_index())


func drop_chess(index: int) -> void:
	drop_chess_index.emit(index)
	
func set_grid(index: int, current_player: String) -> void:
	turn.text = player_signs[current_player] + " \nok "
	var child = grid_container.get_child(index)
	child.set_chess(current_player)
	
func drop_ok(player: String) -> void:
	player_drop_ok.emit(player)
	
func get_chess_grid(index: int) -> String:
	return grid_container.get_child(index).player
	
func reset_grid(indexs: Array) -> void:
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(reset_grid_wait.bind(indexs))
	
func reset_grid_wait(indexs: Array) -> void:
	for index in indexs:
		var chess_node = grid_container.get_child(index)
		chess_node.player = ""
		chess_node.button.text = ""
		chess_node.button.disabled = false
	
	var winner = check_winner()
	if winner != "":
		turn.text = "Winner\n is : \n%s" % winner
		has_winner.emit()
	print("winner is : ",winner)
func check_winner() -> String:
	pass
	var black_chess_num : int = 0
	var white_chess_num : int = 0
	var winner : String = ""
	var childrens = grid_container.get_children()
	for child in childrens:
		var grid_player = get_chess_grid(child.get_index())
		if grid_player  == "black":
			black_chess_num += 1
		elif grid_player == "white":
			white_chess_num += 1
	if 0 in [black_chess_num, white_chess_num]:
		if black_chess_num == 0:
			winner = "white"
		else:
			winner = "black"
	print("white left : %s\nblack left : %s " % [white_chess_num, black_chess_num])
	return winner
