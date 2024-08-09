extends Control

var shapes_list:Array = [
	[[1]], 
	[[1, 1]],
	[[1],[1]],
	[[1,1,1]],
	[[1],[1],[1]],
	[[1,1,1,1]],
	[[1],[1],[1],[1]],
	[[1,1,1,1,1]],
	[[1],[1],[1],[1],[1]],
	[[1,0],[1, 1]],
	[[1,1],[1,0]],
	[[1,1],[0,1]],
	[[0,1],[1,1]],
	[[1,0,0],[1,0,0],[1,1,1]],
	[[1,0,0],[1,1,1],[1,0,0]],
	[[1,1,1],[1,0,0],[1,0,0]],
	[[1,1,1],[0,1,0],[0,1,0]],
	[[1,1,1],[0,0,1],[0,0,1]],
	[[0,0,1],[1,1,1],[0,0,1]],
	[[0,0,1],[0,0,1],[1,1,1]],
	[[0,1,0],[0,1,0],[1,1,1]],
	[[1,0],[1,0],[1,1]],
	[[1,0],[1,1],[1,0]],
	[[1,1],[1,0],[1,0]],
	[[0,1],[0,1],[1,1]],
	[[1,0,0],[1,1,1]],
	[[0,1,0],[1,1,1]],
	[[0,0,1],[1,1,1]],
	[[0,1],[1,1],[1,0]],
	[[1,0],[1,1],[0,1]],
	[[0,1,1],[1,1,0]],
	[[1,1,0],[0,1,1]],
	[[1,1,1],[1,1,1],[1,1,1]]
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 10:
		for j in 10:
			var default_grid = preload("res://Scenes/game_grid.tscn").instantiate()
			default_grid.name = str(i) + "-" + str(j)
			default_grid.add_to_group("draggable_controls")
			$AnswerPanelContainer/GridContainer2.add_child(default_grid)
			
	set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer1)
	set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer2)
	set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer3)
	
	

var puzzle_piece_drop_available = 3

func set_answer_with_parent():
	puzzle_piece_drop_available -= 1
	
	if puzzle_piece_drop_available == 0:
		puzzle_piece_drop_available = 3
		set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer1)
		set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer2)
		set_answer($QuestionGridContainer/VBoxContainer/ShapeContainer3)
	
	
#func fofo():
#	print("fofo")
	
var panel_cnt_count = 0
func set_answer(parent):
	var panel_container = preload("res://panel_container.tscn").instantiate()
	panel_cnt_count += 1
	panel_container.name = "shape" + str(panel_cnt_count)
	panel_container.connect("on_piece_place", Callable(self, "set_answer_with_parent"))
	var shape:Array = shapes_list.pick_random()

	var shape_grid := VBoxContainer.new()
	shape_grid.add_theme_constant_override("separation", 2)
	for i in shape.size():
		var item_row = HBoxContainer.new()
		item_row.add_theme_constant_override("separation", 2)
		for j in shape[i].size():
			if shape[i][j] == 1:
				var default_grid = preload("res://Scenes/default_grid.tscn").instantiate()
				default_grid.name = str(i) + str(j)
				item_row.add_child(default_grid)
			else:
				var default_grid = preload("res://Scenes/empty_default_grid.tscn").instantiate()
				default_grid.name = "empty"
				item_row.add_child(default_grid)
		shape_grid.add_child(item_row)
		
	panel_container.add_child(shape_grid)
	parent.add_child(panel_container)
	panel_container.scale = Vector2(0.5, 0.5)
	panel_container.pivot_offset = Vector2(panel_container.size.x/2.0, panel_container.size.y/2.0)
