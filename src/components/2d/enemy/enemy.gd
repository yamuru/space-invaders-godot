extends CharacterBody2D


const node_name := "Enemy"

var bullet := preload("res://src/components/2d/bullet/bullet.tscn")
var shooting_sound := preload("res://audio/game/enemy_shoot.ogg")
var hit_sound := preload("res://audio/game/enemy_hit.ogg")

const SPEED := 3000.0
const MOVE_TIME_DECREASE = 0.02
var direction := Vector2.RIGHT
var should_go_forward := false
var direction_changed_already := false
var can_move := false
var row: int
var column: int


func _ready():
	GEventBus.subscribe(GEventBus.Events.DirectionToggleAreaEntered, self, "toggle_direction_and_move_forward")
	GEventBus.subscribe(GEventBus.Events.EnemyDied, self, "on_enemy_died")


func _exit_tree():
	GEventBus.remove_sub(GEventBus.Events.DirectionToggleAreaEntered, self, "toggle_direction_and_move_forward")
	GEventBus.remove_sub(GEventBus.Events.EnemyDied, self, "on_enemy_died")


func _physics_process(delta):
	if should_go_forward:
		velocity = Vector2.DOWN * SPEED
	elif can_move:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		var collider := collision.get_collider()
		if collider.get("node_name") == "Bullet":
			collider.queue_free()
			die()
	
	should_go_forward = false
	can_move = false
	direction_changed_already = false


func shoot():
	var bullet_instance: RigidBody2D = bullet.instantiate()
	bullet_instance.position = $BulletSpawnPosition.get_global_position()
	bullet_instance.set_bullet_type(bullet_instance.BulletTypes.Enemy)
	
	get_parent().add_child(bullet_instance)
	
	$ShootStreamPlayer.stream = shooting_sound
	$ShootStreamPlayer.play()
	
	
func die():
	GEventBus.notify(GEventBus.Events.EnemyDied, self)
	$Sprite2D.visible = false
	$HitStreamPlayer.stream = hit_sound
	$HitStreamPlayer.play()


func toggle_direction_and_move_forward():
	direction = -direction
	should_go_forward = true


func on_enemy_died():
	$MovementTimer.wait_time -= MOVE_TIME_DECREASE


func _on_movement_timer_timeout():
	can_move = true


func _on_hit_stream_player_finished():
	queue_free()
