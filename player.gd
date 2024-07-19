extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var push_force = 25.0

var target_velocity = Vector3.ZERO

@onready var animation_player: AnimationPlayer = get_node("Player Model/AnimationPlayer")

var nearby_box = null

var held_box = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearby_box is RigidBody3D:
		grab_delivery_box(nearby_box)
	elif event.is_action_pressed("interact"):
		print(basis)

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
		basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		# target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		pass

	# Moving the Character
	velocity = target_velocity
	
	if held_box is RigidBody3D:
		animation_player.play("Hold")
	elif velocity.length() > 0:
		animation_player.play("Move")
	else:
		animation_player.play("Idle")
	move_and_slide()

	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider() 
		if collider is RigidBody3D:
			nearby_box = collider
			collider.apply_central_impulse(-c.get_normal() * push_force * delta)

func grab_delivery_box(box: RigidBody3D):
	box.reparent(self)
	held_box = box
	box.gravity_scale = 0
	box.disable_mode = DisableMode.DISABLE_MODE_REMOVE
	box.process_mode = Node.PROCESS_MODE_DISABLED
	box.global_position = global_position + Vector3(0, 2, 0) + basis.z.sign() * Vector3(0, 0, -3)
	print(position)
	print(basis.z.sign() * Vector3(0, 0, 1))
