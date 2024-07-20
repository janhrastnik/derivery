class_name Player

extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var push_force = 25.0

var target_velocity = Vector3.ZERO

@onready var animation_player: AnimationPlayer = get_node("Player Model/AnimationPlayer")
@onready var ui_animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var details_text: Label = get_node("CanvasLayer/UI/Details Text")
@onready var victory_panel: Panel = get_node("CanvasLayer/UI/Victory Panel")
@onready var level_title: Label = get_node("CanvasLayer/UI/Level Title")

var nearby_box = null

var held_box = null

var next_level_countdown = 5
@onready var next_level_text: Label = get_node("CanvasLayer/UI/Victory Panel/Next Level Text")

@onready var help_panel: Panel = get_node("CanvasLayer/UI/Help Panel")

func _ready() -> void:
	Singleton.player = self
	level_title.text = Singleton.level_names[Singleton.current_level]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearby_box is DeliveryBox and held_box == null:
		grab_delivery_box(nearby_box)
	elif event.is_action_pressed("interact") and held_box != null:
		release_delivery_box()
	elif event.is_action("restart"):
		get_tree().change_scene_to_file("res://scenes/levels/level {lvl}/level_{lvl}.tscn".format({"lvl": Singleton.current_level}))
		# global_position = Singleton.player_s_pos[Singleton.current_level]
		# Singleton.delivery_box.global_position = Singleton.box_s_pos[Singleton.current_level]

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
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	
	if held_box is RigidBody3D:
		animation_player.play("Hold")
	elif abs(velocity.x) > 0 or abs(velocity.z) > 0:
		animation_player.play("Move")
	else:
		animation_player.play("Idle")
	move_and_slide()

	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var collider = c.get_collider() 
		if collider is RigidBody3D:
			collider.apply_central_impulse(-c.get_normal() * push_force * delta)

func grab_delivery_box(box: RigidBody3D):
	held_box = box
	box.reparent(self)
	box.gravity_scale = 0
	box.disable_mode = DisableMode.DISABLE_MODE_REMOVE
	box.process_mode = Node.PROCESS_MODE_DISABLED
	box.global_position = global_position + Vector3(0, 3.5, 0)
	box.global_position += basis.z.z * Vector3(0, 0, -3)
	box.global_position += basis.x.z * Vector3(3, 0, 0)

	details_text.text = "Release Box [Spacebar]"

func release_delivery_box():
	held_box.reparent(get_parent())
	held_box.gravity_scale = 1
	held_box.disable_mode = DisableMode.DISABLE_MODE_KEEP_ACTIVE
	held_box.process_mode = Node.PROCESS_MODE_INHERIT
	held_box = null

func _on_delivery_box_detector_body_entered(body: Node3D) -> void:
	if body is DeliveryBox:
		details_text.text = "Grab Box [Spacebar]"
		details_text.visible = true
		nearby_box = body
	elif body is Bridge:
		set_collision_mask_value(2, false)

func _on_delivery_box_detector_body_exited(body: Node3D) -> void:
	if body is DeliveryBox and held_box == null:
		nearby_box = null
		details_text.visible = false
	elif body is Bridge:
		set_collision_mask_value(2, true)

func level_complete():
	ui_animation_player.play("victory_popup")
	while next_level_countdown > 0:
		var txt = next_level_text.text
		txt = txt.left(-1)
		next_level_text.text = txt + str(next_level_countdown)
		await get_tree().create_timer(1).timeout
		next_level_countdown -= 1
	Singleton.switch_level()


func _on_help_mouse_entered() -> void:
	help_panel.visible = true


func _on_help_mouse_exited() -> void:
	help_panel.visible = false
