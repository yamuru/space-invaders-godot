extends Control


func _on_play_button_pressed():
	GInterfaceSounds.play_sound(GInterfaceSounds.Sounds.start)
	GScreensManager.go_to_screen(GScreensManager.Screens.Game)


func _on_settings_button_pressed():
	GInterfaceSounds.play_sound(GInterfaceSounds.Sounds.click)
	GScreensManager.go_to_screen(GScreensManager.Screens.Settings)

