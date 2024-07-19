extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

@onready var animation_player: AnimationPlayer = get_node("Player Model/AnimationPlayer")

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		pass
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		basis = Basis.looking_at(direction * -1)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		# target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		pass

	# Moving the Character
	velocity = target_velocity
	if velocity.length() > 0:
		animation_player.play("Move")
		print(velocity)
	else:
		animation_player.stop()
	move_and_slide()
