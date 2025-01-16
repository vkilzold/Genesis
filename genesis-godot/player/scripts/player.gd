class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.ZERO
@export var direction : Vector2 = Vector2.ZERO
@export var move_speed : float = 200.0
var state : String = "walking"
@onready var sprite = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	# Ensure everything is set up correctly
	animation_player.play("idle_down")  # Default animation at start

func _process(delta):
	# Update direction based on input
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Calculate velocity
	velocity = direction * move_speed
	
	# Update animation if state or direction changes
	if SetState() == true ||  SetDirection() == true:
		update_animation()

func _physics_process(delta):
	# Apply velocity
	move_and_slide()

func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction

	if direction == Vector2.ZERO:
		return false  # No input, no direction change

	# Determine new cardinal direction
	if abs(direction.x) > abs(direction.y):  # Horizontal movement dominates
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:  # Vertical movement dominates
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
		return true  # Direction changed

	return false

func SetState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	
	state = new_state
	return true

func update_animation() -> void:
	# Play the animation based on state and direction
	var anim_name = state + "_" + AnimationDirection()
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	
	

func AnimationDirection() -> String:
	# Determine the animation direction
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	else:
		return "left"
