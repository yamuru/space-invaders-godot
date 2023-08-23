extends Node


const Screens: Dictionary = {
	MainMenu = "res://src/screens/main_menu/main_menu.tscn",
	Settings = "res://src/screens/settings/settings.tscn",
	Game = "res://src/screens/game/game.tscn",
}

var starting_screen: String = Screens.MainMenu
var current_screen: String
var current_screen_node: Node

@onready var game_root_node: Node = get_node("/root/Main")


func go_to_screen(path: String):
	current_screen = path
	call_deferred("_deferred_go_to_screen", path)


func _deferred_go_to_screen(path: String):
	if current_screen_node:
		current_screen_node.free()
		
	var s: Resource = ResourceLoader.load(path)
	current_screen_node = s.instantiate()
	game_root_node.add_child(current_screen_node)
