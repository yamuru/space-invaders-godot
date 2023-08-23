extends RigidBody2D


const node_name := "Bullet"

var shooting_direction: Vector2 = Vector2.DOWN
const BULLET_SPEED := 500

enum BulletTypes {
	Player,
	Enemy
}

var bullet_type: BulletTypes


func _ready():
	apply_impulse(shooting_direction * BULLET_SPEED, Vector2())


func set_bullet_type(type: BulletTypes):
	bullet_type = type
	match type:
		BulletTypes.Player:
			$PlayerBullet.visible = true
			shooting_direction = Vector2.UP
			set_collision_layer_value(5, true)
		BulletTypes.Enemy:
			$EnemyBullet.visible = true
			shooting_direction = Vector2.DOWN
			set_collision_layer_value(6, true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
