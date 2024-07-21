class_name DeliveryBox

extends RigidBody3D

@onready var water_splash: AudioStreamPlayer = get_node("Water Splash")

@export var is_heavy = false

var metal_material = load("res://materials/metal_material.tres")

var in_river = false

var river_ref: River = null

var already_switched = false

@onready var cube: MeshInstance3D = get_node("delivery_box/Cube")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton.delivery_box = self
	if is_heavy:
		cube.set_surface_override_material(0, metal_material)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_river_seeking_area_body_entered(body: Node3D) -> void:
	print("body entered")
	if body is River and not in_river:
		print("RIVER ENTER CALL")
		river_enter(body)
		Singleton.player.box_drop.stop()
		water_splash.play()
	elif body is River and in_river and body != river_ref and not already_switched:
		print("RIVER SWITCH CALL")
		already_switched = true
		leave_river()
		river_enter(body)

func river_enter(river: River):
	#linear_velocity = Vector3.ZERO
	#angular_velocity = Vector3.ZERO
	freeze = true
	in_river = true
	gravity_scale = 0
	call_deferred("deffered_river_enter", river)

func deffered_river_enter(river: River):
	reparent(river)
	# disable_mode = DISABLE_MODE_REMOVE
	# set_collision_mask_value(2, false)
	# set_collision_layer_value(1, false)
	# process_mode = Node.PROCESS_MODE_DISABLED
	
	river.calculate_path(self)

func leave_river():
	if river_ref != null:
		river_ref.leave_river()
		# river_ref = null
		# in_river = false
		# freeze = false
