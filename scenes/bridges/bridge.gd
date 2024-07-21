class_name Bridge

extends StaticBody3D

@export var is_brittle = false
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var audio_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

@export var cross_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_brittle:
		animation_player.play("brittle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cross_event():
	cross_count += 1
	if is_brittle and cross_count == 2:
		animation_player.play("break")
		audio_player.play()
		await get_tree().create_timer(1).timeout
		queue_free()
