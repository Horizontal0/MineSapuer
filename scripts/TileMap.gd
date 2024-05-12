extends TileMap

signal add_flag
signal remove_flag
signal first_click
var started = false
var column = 16
var row = 16
var max_bomb = 40
var is_clicked = false
var flag_got = true

const red_layer = 0
const bomb_layer = 1
const number_layer = 2
const blue_layer = 3
const flag_layer = 4

const tileset_id = 1
const numberset_id = 0

const cell_list ={
	1:Vector2i(0,0),
	2:Vector2i(1,0),
	3:Vector2i(2,0),
	4:Vector2i(3,0),
	5:Vector2i(4,0),
	6:Vector2i(5,0),
	7:Vector2i(6,0),
	8:Vector2i(7,0),
	"red":Vector2i(0,0),
	"blue":Vector2i(1,0),
	"flag":Vector2i(2,0),
	"bomb":Vector2i(3,0),
	"bomb_exploded":Vector2i(4,0)
}

var bomb_pos =[]
var number_pos = []
var flag_pos = []

func _ready():
	generate_background()
	generate_bomb()
	generate_number()
	generate_front()
	
func _process(delta):
	var mouse_pos = local_to_map(get_local_mouse_position())
	if Input.is_action_just_pressed("click"):
		if started == false:
			started = true
			first_click.emit()
		if not is_flag(mouse_pos) and 0<mouse_pos.x and mouse_pos.x<(column-1) and mouse_pos.y >-1 and mouse_pos.y<(row-1):
			if is_bomb(mouse_pos):
				game_over()
			elif is_number(mouse_pos):
				erase_cell(blue_layer,mouse_pos)
			else:
				clear_tiles(mouse_pos)
				erase_cell(blue_layer,mouse_pos)
			
	if Input.is_action_just_pressed("flag") and is_blue(mouse_pos):
		if is_flag(mouse_pos):
			erase_cell(flag_layer,mouse_pos)
			flag_pos.erase(mouse_pos)
			remove_flag.emit()
		elif flag_got == true:
			set_cell(flag_layer,mouse_pos,tileset_id,cell_list["flag"])
			flag_pos.append(mouse_pos)
			add_flag.emit()

		print("flag")
	#if Input.is_action_pressed("reset"):
		#clear()
		#generate_background()
		#generate_bomb()
		#generate_number()
		#generate_front()

func is_blue(mouse_pos):
	return get_cell_source_id(blue_layer, mouse_pos) == 1
	
func is_bomb(mouse_pos):
	return get_cell_source_id(bomb_layer, mouse_pos) == 1
	
func is_number(mouse_pos):
	return get_cell_source_id(number_layer, mouse_pos) == 0

func is_flag(mouse_pos):
	return get_cell_source_id(flag_layer, mouse_pos) == 1

func generate_background():
	for x in range(row):
		for y in range(column):
			set_cell(red_layer,Vector2i(x,y),tileset_id,cell_list["red"])

func generate_front():
	for x in range(row):
		for y in range(column):
			set_cell(blue_layer,Vector2i(x,y),tileset_id,cell_list["blue"])

func generate_bomb():
	for x in range(max_bomb):
		var random_pos =Vector2i(randi_range(0,column-1),randi_range(0,row-1))
		while bomb_pos.has(random_pos):
			random_pos =Vector2i(randi_range(0,column-1),randi_range(0,row-1))
		bomb_pos.append(random_pos)
		set_cell(bomb_layer,random_pos,tileset_id,cell_list["bomb"])
		#print(bomb_pos)

func generate_number():
	for bomb in bomb_pos:
		get_numberlocation(bomb)

func get_numberlocation(pos):
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var current_tile = Vector2i(pos.x + x, pos.y + y)
			var tile_number = get_cell_atlas_coords(number_layer,current_tile).x + 1
			if x == 0 and y == 0 or bomb_pos.has(current_tile) or current_tile.x < 0 or current_tile.y < 0:
				continue
			set_cell(number_layer,current_tile,numberset_id,cell_list[tile_number+1])

func game_over():
	for x in bomb_pos:
		if not is_flag(x):
			erase_cell(blue_layer,x)
	for x in flag_pos:
		if not is_bomb(x):
			erase_cell(flag_layer,x)
			set_cell(flag_layer,x,numberset_id,cell_list[8])

	print("game over")

func clear_tiles(mouse_pos):
	var pending_clear = []
	var cleared = []
	pending_clear.append(mouse_pos)
	while not pending_clear.is_empty():
		var tile = pending_clear[0]
		#pending_clear.remove_at(0)
		cleared.append(tile)
		var surrounding_list = []
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				if not(x == 0 and y == 0):
					surrounding_list.append(Vector2i(tile.x+x,tile.y+y))
					
		for pos in surrounding_list:
			if not is_number(pos) and not cleared.has(pos) and not pending_clear.has(pos):
				if pos.x > -1 and pos.x < column:
					if pos.y > -1 and pos.y < row:
						pending_clear.append(pos)
						continue
			if is_flag(pos):
				erase_cell(flag_layer,pos)
				remove_flag.emit()
					
			if is_number(pos):
				cleared.append(pos)
		
		pending_clear.erase(tile)
		
	
	for pos in cleared:
		erase_cell(blue_layer,pos)
	pass








