class_name DeliveryPlatform

extends StaticBody3D

@onready var confetti: GPUParticles3D = get_node("Confetti")
@onready var clap_sound: AudioStreamPlayer = get_node("AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is DeliveryBox:
		# level complete!
		confetti.emitting = true
		clap_sound.play()
		Singleton.level_complete_event()
