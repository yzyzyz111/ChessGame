extends Node2D

@onready var chess_pad: HBoxContainer = $PanelContainer/ChessPad
@onready var panel: Panel = $PanelContainer/Panel

var current_player :String = "black"

func _ready() -> void:
	
	chess_pad.drop_chess_index.connect(drop_chess)
	chess_pad.player_drop_ok.connect(change_player)
	chess_pad.has_winner.connect(game_over)
	

func drop_chess(index: int) -> void:
	
	print(index , "'s neighbors : " , calculate_grid_neighbors(index))
	
	chess_pad.set_grid(index, current_player)
	check_blast(index, get_chess_grid_player(index))
	
	
func change_player(player: String) -> void:
	if player == "black":
		current_player = "white"
	else :
		current_player = "black"
	
func calculate_grid_neighbors(index: int) -> Array:
	var neighbor = []
	
	var up = index - 8
	if up >= 0:
		neighbor.append(up)
		
	var down = index + 8
	if down <= 63:
		neighbor.append(down)
		
	var left = index - 1
	@warning_ignore("integer_division")
	if (index / 8 == left / 8) and (left >= 0):
		neighbor.append(left)
		
	var right = index + 1
	@warning_ignore("integer_division")
	if (index / 8 == right / 8) and (right <= 63):
		neighbor.append(right)
	
	return neighbor

func get_chess_grid_player(index: int) -> String:
	return chess_pad.get_chess_grid(index)

func check_blast(index: int, player: String) -> void:
	var already_checked_index = []
	var to_be_check_index = [index]
	var same_player_chess_index = [index]
	var enemy_player_chess_index = []
		
	for ind in calculate_grid_neighbors(index):
		to_be_check_index.append(ind)

	var i =0
	while i < to_be_check_index.size():
		
		var _index = to_be_check_index[i]
		var _player = get_chess_grid_player(_index)

		if _player == "":
			if _index not in already_checked_index:
				already_checked_index.append(_index)
			i += 1
			continue
		elif _player == player:
			if _index not in already_checked_index:
				already_checked_index.append(_index)
			if _index not in same_player_chess_index:
				same_player_chess_index.append(_index)
			
			var temp_index = calculate_grid_neighbors(_index)
			for j in temp_index:
				if j not in already_checked_index and j not in to_be_check_index:
				#if j not in to_be_check_index:
					to_be_check_index.append(j)
		elif _player != player :
			if _index not in already_checked_index:
				already_checked_index.append(_index)
			if _index not in enemy_player_chess_index:
				enemy_player_chess_index.append(_index)
		
		i += 1
		
	
	if same_player_chess_index.size() > 2:
		# test code
		print("self grid list to be killed : " , same_player_chess_index)
		print("enemy grid list to be killed : ", enemy_player_chess_index)
		print("already checked list : ", already_checked_index)
		print("to be check list : ", to_be_check_index)
		
		# wait 0.1s then kill cells
		chess_pad.reset_grid(same_player_chess_index)
		chess_pad.reset_grid(enemy_player_chess_index)
		
func game_over() -> void:
	panel.visible = true
