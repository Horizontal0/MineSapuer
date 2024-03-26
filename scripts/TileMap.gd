extends TileMap


var column = 16
var row = 16
var max_bomb = 50
var is_clicked = false

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

func _ready():
	generate_background()
	generate_bomb()
	generate_number()
	generate_front()
	
func _process(delta):
	var mouse_pos = local_to_map(get_local_mouse_position())
	if Input.is_action_just_pressed("click"):
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
		else:
			set_cell(flag_layer,mouse_pos,tileset_id,cell_list["flag"])
	
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
			if x == 0 and y == 0 or bomb_pos.has(current_tile):
				continue
			set_cell(number_layer,current_tile,numberset_id,cell_list[tile_number+1])

func game_over():
	for x in bomb_pos:
		erase_cell(blue_layer,x)
	print("game over")

func clear_tiles(mouse_pos):
	var pending_clear = []
	var cleared = []
	pending_clear.append(mouse_pos)
	for tile in pending_clear:
		pending_clear.remove_at(0)
		for x in [-1, 0, 1]:
			for y in [-1, 0, 1]:
				var current_tile = Vector2i(tile.x+x,tile.y+y)
				erase_cell(blue_layer,current_tile)
				if current_tile in cleared:
					continue
				elif current_tile.x>=0 and current_tile.y>=0:
					if is_number(current_tile) or (x ==0 and y ==0):
						cleared.append(current_tile)
					else:	
						pending_clear.append(current_tile)
		print("pending_clear =", pending_clear, "and cleared=", cleared)
		pass
	
			







