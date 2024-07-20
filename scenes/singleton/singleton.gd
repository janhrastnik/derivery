extends Node

@onready var music_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

var current_level = 0

var player = null
var delivery_box = null

var player_s_pos = [
	Vector3(-16, 1.5, -14)
]

var box_s_pos = [
	Vector3(1, 2, -15)
]

var level_names = [
	"'Straight to the point'",
	"'Something is afloat'"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func level_complete_event():
	current_level += 1
	if player is Player:
		player.level_complete()
