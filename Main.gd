extends Node

onready var metaboy_character = $MetaBoyTopDown
export (PackedScene) var mob_scene
var score = 0


func _ready():
	randomize()
	metaboy_character.set_attributes(MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary())

func new_game():
	score = 0
	$HUD.update_score(score)

	get_tree().call_group("mobs", "queue_free")
	$MetaBoyTopDown.start($StartPosition.position)

	$StartTimer.start()

	$HUD.show_message("Get ready...")

	yield($StartTimer, "timeout")

	$ScoreTimer.start()
	$MobTimer.start()

	$Music.play()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func _on_Timer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()
	
	var mob = mob_scene.instance()
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)




func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


#func _on_Area2D_body_entered(body):
#	hide()
#	$CollisionShape2D.set_deferred("disabled", true)
#	emit_signal("hit")
