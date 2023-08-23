extends CharacterBody2D


signal player_hit;

const node_name := "Player"

var bullet := preload("res://src/components/2d/bullet/bullet.tscn")
var shooting_sound := preload("res://audio/game/player_shoot.ogg")
var hit_sound := preload("res://audio/game/player_hit.ogg")
var audio_stream_queue := []

const SPEED := 250.0
var can_shoot := true


func _physics_process(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed("ui_select") and can_shoot:
		shoot()
	
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		var collider := collision.get_collider()
		if collider.get("node_name") == "Bullet":
			collider.queue_free()
			$HitStreamPlayer.stream = hit_sound
			$HitStreamPlayer.play()
			emit_signal("player_hit")


func shoot():
	var bullet_instance: RigidBody2D = bullet.instantiate()
	bullet_instance.position = $BulletSpawnPosition.get_global_position()
	bullet_instance.set_bullet_type(bullet_instance.BulletTypes.Player)
	
	get_parent().add_child(bullet_instance)
	
	$ShootStreamPlayer.stream = shooting_sound
	$ShootStreamPlayer.play()
	
	can_shoot = false
	$ShootingTimer.start()


func _on_shooting_timer_timeout():
	can_shoot = true
