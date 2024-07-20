class_name DeliveryBox

extends RigidBody3D

var in_river = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton.delivery_box = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_river_seeking_area_body_entered(body: Node3D) -> void:
	if body is River and not in_river:
		river_enter(body)

func river_enter(river: River):
	in_river = true
	call_deferred("deffered_river_enter", river)

func deffered_river_enter(river: River):
	reparent(river)
	gravity_scale = 0
	disable_mode = DISABLE_MODE_REMOVE
	set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)
	# process_mode = Node.PROCESS_MODE_DISABLED
	linear_velocity = Vector3.ZERO
	river.calculate_path(self)
