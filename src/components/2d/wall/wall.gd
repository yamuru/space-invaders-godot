extends StaticBody2D


const node_name := "Wall"

var hit_sound := preload("res://audio/game/wall_hit.ogg")

var hp := 5
var wall_sprites_on_hp := {
	5: preload("res://art/wall1.png"),
	4: preload("res://art/wall2.png"),
	3: preload("res://art/wall3.png"),
	2: preload("res://art/wall4.png"),
	1: preload("res://art/wall5.png"),
}


func _on_body_detector_body_entered(body):
	if body.get("node_name") == "Bullet":
		body.queue_free()
	
	if body.get("node_name") == "Enemy":
		hp = 0
	
	hp -= 1
	play_sound(hit_sound)
	
	if hp <= 0:
		queue_free()
		return
	
	update_ui()


func update_ui():
	$Sprite2D.texture = wall_sprites_on_hp[hp]


func play_sound(sound: Resource):
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()
