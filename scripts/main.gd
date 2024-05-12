extends Node2D

var daobaf = 40  #difficulty_amount_of_bomb_and_flag
var flag_amount = 40
var time = 0
@onready var timer = $Timer
@onready var header = $header #same as UI
@onready var tilemap = $tilemap #same as grid

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func timer_stop():
	timer.stop()

func _on_timer_timeout():
	time += 1
	header.timer_change(time)

func _on_tilemap_first_click():
	timer.start()

func _ready():
	flag_amount = daobaf
	update_flag()

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
