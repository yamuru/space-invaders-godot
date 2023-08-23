extends Node


@onready var interface_stream_player: AudioStreamPlayer = get_node("/root/Main/InterfaceStreamPlayer")

var Sounds := {
	click = preload("res://audio/interface/click.ogg"),
	start = preload("res://audio/interface/start.ogg"),
}


func play_sound(sound: Resource):
	interface_stream_player.stream = sound
	interface_stream_player.play()
