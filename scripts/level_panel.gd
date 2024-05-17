extends Control

@onready var option_button = $TextureRect/difficulty/OptionButton
@onready var button = $TextureRect/Button
@onready var line_edit = $TextureRect/size/LineEdit
var level = "easy"
var tile_size = 16

signal playing(tile_size,level)

func _on_button_pressed():
	playing.emit(tile_size,level)

func _on_line_edit_text_submitted(new_text):
	tile_size = new_text
	print(new_text)

func _on_option_button_item_selected(index):
	level = option_button.get_item_text(index)
	print(level)
