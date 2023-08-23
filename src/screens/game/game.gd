extends Node2D


var enemy := preload("res://src/components/2d/enemy/enemy.tscn")

const ENEMY_ROWS := 4
const ENEMY_COLUMNS := 6
const ENEMIES_SEPARATION = 65
const TOP_LEFT_ENEMY_POS := Vector2(60, 200)
const SCORE_ON_ENEMY := 50

var enemy_count := ENEMY_COLUMNS * ENEMY_ROWS
var hp := 3
var score := 0
var toggling_direction_already := false

# Only frontline enemies can shoot, we store them here
var shooting_enemies := []

# Saving enemies in Dictionary where keys are rows and columns
# so accessing enemies would be O(1) if we know row and column
# this is better than array bc we don't need to iterate through every time
var enemies := {}


func _ready():
	$Player.player_hit.connect(_player_hit)
	spawn_enemies()
	
	GEventBus.subscribe(GEventBus.Events.EnemyDied, self, "enemy_died", true) # true means "yes, we expect an arg"
	
	
func _exit_tree():
	GEventBus.remove_sub(GEventBus.Events.EnemyDied, self, "enemy_died")


func spawn_enemies():
	for row in range(0, ENEMY_ROWS):
		var enemies_in_a_row := {}
		
		for column in range(0, ENEMY_COLUMNS):
			var enemy_instance := enemy.instantiate()
			enemy_instance.row = row
			enemy_instance.column = column
			enemy_instance.position.x = TOP_LEFT_ENEMY_POS.x + column * ENEMIES_SEPARATION
			enemy_instance.position.y = TOP_LEFT_ENEMY_POS.y + row * ENEMIES_SEPARATION
			
			enemies_in_a_row[column] = enemy_instance
			if row == ENEMY_ROWS - 1:
				shooting_enemies.append(enemy_instance)
			
			add_child(enemy_instance)
		
		enemies[row] = enemies_in_a_row


func enemy_died(died_enemy):
	var shooting_enemy_deleted := false
	
	# Removing enemy from shooting_enemies if enemy is there
	for i in range(shooting_enemies.size() - 1, 0, -1):
		if is_instance_valid(shooting_enemies[i]): # bullets are tricky and this might not exist here
			var row_condition: bool = shooting_enemies[i].row == died_enemy.row
			var column_condition: bool = shooting_enemies[i].column == died_enemy.column
			
			if row_condition and column_condition:
				shooting_enemies.remove_at(i)
				shooting_enemy_deleted = true
	
	enemies[died_enemy.row][died_enemy.column] = null
	
	# If shooting enemy died, find a new frontliner and add to shooting enemies array
	if shooting_enemy_deleted:
		for j in range(died_enemy.row - 1, -1, -1):
			if enemies[j][died_enemy.column] != null:
				shooting_enemies.append(enemies[j][died_enemy.column])
				break
	
	update_score(score + SCORE_ON_ENEMY)
	
	enemy_count -= 1
	if enemy_count <= 0:
		game_over()


func update_score(new_score: int):
	score = new_score
	$CanvasLayer/UI/Score.text = "Score: " + str(score)


func game_over():
	GScreensManager.go_to_screen(GScreensManager.Screens.MainMenu)
	
	
func _player_hit():
	hp -= 1
	$CanvasLayer/UI/HBoxContainer.get_child(-1).queue_free()
	if hp <= 0:
		game_over()


func _on_instructions_timer_timeout():
	$CanvasLayer/UI/Instructions.visible = false


func _on_game_lose_area_body_entered(_body):
	game_over()


func _on_direction_toggle_area_body_entered(_body):
	# avoiding a bug where even-numbered amount of enemies
	# entering toggling area together didn't toggle direction
	if !toggling_direction_already:
		GEventBus.notify(GEventBus.Events.DirectionToggleAreaEntered)
		toggling_direction_already = true


func _on_direction_toggle_area_body_exited(_body):
	toggling_direction_already = false


func _on_shooting_timer_timeout():
	var random_shooting_enemy = shooting_enemies.pick_random()
	if is_instance_valid(random_shooting_enemy):
		random_shooting_enemy.shoot()
