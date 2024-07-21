extends Node

@onready var confetti_one = get_node("Delivery Platform/Confetti")
@onready var confetti_two = get_node("Delivery Platform2/Confetti")
@onready var clap_sound = get_node("AudioStreamPlayer")

var is_delivered_one = false

var is_delivered_two = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func delivery_event():
	if is_delivered_one and is_delivered_two:
		# level complete!
		confetti_one.emitting = true
		confetti_two.emitting = true
		clap_sound.play()
		Singleton.level_complete_event()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is DeliveryBox:
		is_delivered_one = true
		delivery_event()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is DeliveryBox:
		is_delivered_one = false


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body is DeliveryBox:
		is_delivered_two = true
		delivery_event()


func _on_area_3d_2_body_exited(body: Node3D) -> void:
	if body is DeliveryBox:
		is_delivered_two = false
