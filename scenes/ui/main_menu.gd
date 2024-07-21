extends Node

@onready var path_follow: PathFollow3D = get_node("River/Path3D/PathFollow3D")
@onready var button_sound: AudioStreamPlayer = get_node("ButtonSound")
@onready var button: Button = get_node("CanvasLayer/Button")
@onready var notice_sound: AudioStreamPlayer = get_node("NoticeSound")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var disclaimer: Panel = get_node("CanvasLayer/Disclaimer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton.main_menu_music()

func _physics_process(delta: float) -> void:
	path_follow.progress += 4 * delta


func _on_button_pressed() -> void:
	button_sound.play()
	button.disabled = true
	animation_player.play("start_game_animation")
	
	await get_tree().create_timer(3).timeout
	show_notice()
	
func show_notice():
	notice_sound.play()
	disclaimer.visible = true


func _on_continue_button_pressed() -> void:
	button_sound.play()
	button.disabled = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level 0/level_0.tscn")
