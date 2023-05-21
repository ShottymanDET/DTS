extends KinematicBody2D

# An example implementation of top-down player controls.

onready var speed = 400
onready var velocity = Vector2()
signal hit

var screen_size = Vector2.ZERO
onready var metaboy = $MetaBoy

func _ready():
	metaboy.part_background.hide()
	screen_size = get_viewport_rect().size
	print(screen_size)
#	hide()

func set_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _physics_process(_delta: float) -> void:
	# Movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()
	velocity = input_dir * speed
	move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y =clamp(position.y, 0, screen_size.y)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mobs"):
			hide()
			$CollisionShape2D.set_deferred("disabled", true)
			emit_signal("hit")
		pass
	
	# Animations
	if velocity.x != 0 or velocity.y != 0:
		metaboy.animation_player.play("run", -1, 2.0)
	else:
		metaboy.animation_player.play("idle")
	if velocity.x < 0:
		metaboy.body_root.scale.x = -1
	elif velocity.x > 0:
		metaboy.body_root.scale.x = 1

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

#func _on_Area2D_body_entered(body):
#	if body.name.begins_with("Mob"):
#		hide()
#		$CollisionShape2D.set_deferred("disabled", true)
#		emit_signal("hit")

