extends Node2D

var flag_amount = 10
@onready var flag_text = $Control/flag
@onready var time_text = $time


#func _ready():
	#timer_change(711)
#func _process(delta):
	#flag_amount = 

func flag_change(flag_amount):
	flag_text.text = str(flag_amount)

func timer_change(time):
	var minute = int(time/60)
	var second = time%60
	time_text.text = str(minute).lpad(2,"0") + ":" + str(second).lpad(2,"0")

