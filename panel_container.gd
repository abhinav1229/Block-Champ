extends PanelContainer

var selected = false
var mouse_offset = Vector2(0, 0)
var old_position = Vector2(0, 0)
var controls = []  # List to store all relevant controls
var max_row = 10
var max_col = 10
var grid_2d = []

signal on_piece_place()

func _ready():
	set_process(true)
	# Initialize the list with your controls
	controls = get_tree().get_nodes_in_group("draggable_controls")
	var count := 0
	
	for i in max_row:
		var temp = []
		for j in max_col:
			temp.push_back(controls[count])
			count += 1
		grid_2d.push_back(temp)

func _process(delta):
	if selected:
		follow_mouse()
		check_for_object_below()

func follow_mouse():
	position = get_global_mouse_position() + mouse_offset

var is_possible = false 

var mid_row = 0 
var mid_col = 0

var at_row = 0
var at_col = 0

var req_row = 0
var req_col = 0

func check_for_object_below():
	var mouse_pos = get_global_mouse_position()
	is_possible = false
	
	for i in max_row:
		for j in max_col:
			grid_2d[i][j].modulate = Color.GRAY
	
	for control in controls:
		if control is Control:
			var control_global_rect = control.get_global_rect()
			if control_global_rect.has_point(mouse_pos):
				
#				print("Mouse is over: ", control.name)
				at_row =  int(control.name.split("-")[0])
				at_col = int(control.name.split("-")[1])
				
#				print("==> ", at_row, " | ", at_col)
				
				req_row = self.get_child(0).get_child_count()
				req_col = 0
				
				
				for i in req_row:
					for j in self.get_child(0).get_child(i).get_child_count():
						req_col = max(req_col, j+1)
				
#				print("req_row: ", req_row, " | req_col: ", req_col)
		
				
				mid_row = (req_row / 2) 
				mid_col = (req_col / 2) 
				
#				print("RC: ", mid_row, " ", mid_col)
				
				is_possible = false
				
				# to check the possibility
				var direction_count = 0
				
				#up 
				if at_row - mid_row >= 0:
#					print("up")
					direction_count += 1
				
				#down 
				if at_row + (req_row - mid_row - 1) < max_row:
#					print("down")
					direction_count += 1
					
				#left 
				if at_col - mid_col >= 0:
#					print("left")
					direction_count += 1
					
				#right
				if at_col + (req_col - mid_col - 1) < max_col:
#					print("right")
					direction_count += 1
				
#				print("Direction Count: ", direction_count)
				if direction_count == 4:
					is_possible = true
					
					
				var start_row = at_row - mid_row
				var start_col = at_col - mid_col
				
#				print("start: r: ", start_row, " | c: ",start_col)
				
#				print("Is_Possible1: ", is_possible)
				
				if is_possible:
					for i in req_row:
						for j in req_col:
							if grid_2d[start_row + i][start_col + j].get_child_count() == 0:
								continue
							else:
								if !self.get_child(0).get_child(i).get_child(j).is_in_group("empty"):
									is_possible = false

				if is_possible:
					for i in req_row:
						for j in req_col:
							if !self.get_child(0).get_child(i).get_child(j).is_in_group("empty"):
								grid_2d[start_row+i][start_col+j].modulate = Color.HOT_PINK
				
#				print("Is_Possible2: ", is_possible)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
			self.scale = Vector2(1, 1)
			old_position = position
		else:
			selected = false
			self.scale = Vector2(0.5, 0.5)
			self.position = old_position
			old_position = Vector2(0, 0)
			
			# fill the object in that space
			if is_possible:
				var start_row = at_row - mid_row
				var start_col = at_col - mid_col
				
#				print("final: ", start_row, " | ", start_col)
				
				for i in req_row:
					for j in req_col:
						if !self.get_child(0).get_child(i).get_child(j).is_in_group("empty"):
							var default_grid = preload("res://Scenes/default_grid.tscn").instantiate()
							grid_2d[start_row+i][start_col+j].modulate = Color.GRAY
							grid_2d[start_row+i][start_col+j].add_child(default_grid)
						
				self.queue_free()
				
				for i in req_row:
					for j in req_col:
						if !self.get_child(0).get_child(i).get_child(j).is_in_group("empty"):
							
							var is_all_row_filled = true 
							var is_all_col_filled = true  
							
							for k in max_row:
								if grid_2d[start_row+i][k].get_child_count() == 0:
									is_all_row_filled = false 
									
							for k in max_col:
								if grid_2d[k][start_col+j].get_child_count() == 0:
									is_all_col_filled = false 
								
								
							print("=> ", is_all_row_filled, " | ", is_all_col_filled)
							if is_all_row_filled:
								print("all row filled")
								for k in max_row:
									grid_2d[start_row+i][k].get_child(0).queue_free()
									
							if is_all_col_filled:
								print("all col filled")
								for k in max_col:
									grid_2d[k][start_col+j].get_child(0).queue_free()
							
				emit_signal("on_piece_place")
				
#func clear_row_col():
#	for i in max_row:
#		for j in max_col:
#			grid_2d[i][j]
