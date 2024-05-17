extends Node2D

var level_panel_instance
var daobaf = 40  #difficulty_amount_of_bomb_and_flag
var flag_amount = 40
var time = 0
@onready var timer = $Timer
@onready var header = $header #same as UI
@onready var tilemap = $tilemap #same as grid
@onready var level_panel_scene = preload("res://scenes/level_panel.tscn")

func _ready():
	level_panel_instance = level_panel_scene.instantiate()
	add_child(level_panel_instance)
	level_panel_instance.playing.connect(play)
	flag_amount = daobaf
	update_flag()

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func play(tile_size,level):
	level_panel_instance.queue_free()
	tilemap.playing = true
	print(level + tile_size)

func timer_stop():
	timer.stop()

func _on_timer_timeout():
	time += 1
	header.timer_change(time)

func _on_tilemap_first_click():
	timer.start()

func _on_tilemap_add_flag(): #these are ingame flags not flag amounts
	flag_amount -= 1
	update_flag()

func _on_tilemap_remove_flag():
	flag_amount += 1
	update_flag()

func update_flag():
	header.flag_change(flag_amount)
	if flag_amount > 0:
		tilemap.flag_got = true
	else:
		tilemap.flag_got = false
