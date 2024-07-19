extends Node

@onready var music_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
