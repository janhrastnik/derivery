extends Node

@onready var music_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level_complete():
	current_level += 1
