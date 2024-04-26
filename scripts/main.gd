extends Node2D

var time = 0
@onready var timer = $Timer
@onready var header = $header

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
