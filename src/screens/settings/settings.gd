extends Control


var map_setting_to_volume_db := {
	0: -80.0,
	1: -16.0,
	2: -12.0,
	3: -8.0,
	4: -4.0,
	5: 0.0,
	6: 2.0,
	7: 4.0,
	8: 6.0,
	9: 8.0,
	10: 10.0,
}

var current_volume: int

@onready var master_bus_index := AudioServer.get_bus_index("Master")


func _ready():
	var master_bus_volume_db := AudioServer.get_bus_volume_db(master_bus_index)
	var vol_setting_from_current_vol_db: int = map_setting_to_volume_db.find_key(master_bus_volume_db)
	
	if vol_setting_from_current_vol_db != null:
		current_volume = vol_setting_from_current_vol_db
		update_ui()
	else:
		current_volume = 5
		set_volume_in_master_bus(current_volume)


func update_ui():
	$VBoxContainer/CenterContainer/HBoxContainer/HBoxContainer/VolumeValue.text = str(current_volume)


func set_volume_in_master_bus(volume: int):
	AudioServer.set_bus_volume_db(master_bus_index, map_setting_to_volume_db[volume])


func _on_volume_lower_pressed():
	current_volume = clamp(current_volume - 1, 0, 10)
	set_volume_in_master_bus(current_volume)
	
	GInterfaceSounds.play_sound(GInterfaceSounds.Sounds.click)
	update_ui()


func _on_volume_higher_pressed():
	current_volume = clamp(current_volume + 1, 0, 10)
	set_volume_in_master_bus(current_volume)
	
	GInterfaceSounds.play_sound(GInterfaceSounds.Sounds.click)
	update_ui()
	
	
func _on_back_button_pressed():
	GInterfaceSounds.play_sound(GInterfaceSounds.Sounds.click)
	GScreensManager.go_to_screen(GScreensManager.Screens.MainMenu)
