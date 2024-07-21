extends Node

@onready var music_player: AudioStreamPlayer = get_node("AudioStreamPlayer")

var current_level = 0

var player = null
var delivery_box = null

var playlist_index = 0

var easy_lemon = load("res://assets/music/Easy Lemon.mp3")
var eastminster = load("res://assets/music/Eastminster.mp3")
var pixelland = load("res://assets/music/Pixelland.mp3")

var level_names = [
	"'Straight to the point'",
	"'Something is afloat'",
	"'Who built this stinkin' bridge?'",
	"'This is starting to be concerning'",
	"'How am I supposed to carry this??'",
	"'There's a right time for everything'",
	"Two at once"
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
		if current_level == 7:
			get_tree().change_scene_to_file("res://scenes/ui/game_complete.tscn")
			victory_music()
		else:
			player.level_complete()

func switch_level():
	get_tree().change_scene_to_file("res://scenes/levels/level {lvl}/level_{lvl}.tscn".format({"lvl": str(current_level)}))


func _on_audio_stream_player_finished() -> void:
	if playlist_index == 0:
		music_player.stream = eastminster
		playlist_index = 1
	else:
		music_player.stream = easy_lemon
		playlist_index = 0
	music_player.play()

func main_menu_music():
	music_player.stream = easy_lemon
	playlist_index = 0
	music_player.play()

func victory_music():
	music_player.stream = pixelland
	music_player.play()
