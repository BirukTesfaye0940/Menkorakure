extends CanvasLayer

signal dialogue_finished

@onready var name_label: Label =$Panel/MargineContainer/VBoxContainer/NameLabel
@onready var dialogue_label: Label = $Panel/MargineContainer/VBoxContainer/DialogueLabel
@onready var continue_label: Label = $Panel/MargineContainer/VBoxContainer/ContinueLabel
@onready var panel: Panel = $Panel
@onready var cutscene_player = $"../CutscenePlayer"

const CHAR_READ_RATE: float = 0.06
const PUNCTUATION_PAUSE: float = 0.2

@export var tutorial_messages: Array[Dictionary] = [
	{"name": "Hi , Press Enter !!!", "text": "Welcome to the level 2!"},
	{"name": "Press Enter", "text": "Movement: Use WASD or Arrow Keys"},
	{"name": "Press Enter", "text": "Jump: Press SPACE"},
	{"name": "Press Enter ", "text": "After you find the chest you will get hard puzzle!"}
]

var _curr_dialogue: Array[Dictionary] = []
var _curr_page_index: int = 0
var _is_text_revealing: bool = false
var _is_dialogue_active: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_dialogue()
	if cutscene_player.has_signal("cutscene_signal"):
		cutscene_player.cutscene_signal.connect(_on_cutscene_signal)
	dialogue_finished.connect(_on_tutorial_complete)
	start_dialogue_sequence()

func _unhandled_input(event: InputEvent):
	if not _is_dialogue_active:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		if _is_text_revealing:
			_finish_text_reveal()
		else:
			_advance_dialogue()

func start_dialogue_sequence():
	start_dialogue(tutorial_messages)

func start_dialogue(dialogue_data: Array[Dictionary]):
	_curr_dialogue = dialogue_data
	_curr_page_index = 0
	_is_dialogue_active = true
	get_tree().paused = true
	panel.show()
	_show_current_page()

func _show_current_page():
	var page := _curr_dialogue[_curr_page_index]
	name_label.text = page.get("name", "???")
	dialogue_label.text = ""
	continue_label.hide()
	_reveal_text(page.get("text", ""))

func _reveal_text(text: String) -> void:
	_is_text_revealing = true
	for i in range(text.length()):
		dialogue_label.text = text.substr(0, i + 1)
		var wait_time := CHAR_READ_RATE
		if text[i] in [".", ",", "?", "!"]:
			wait_time = PUNCTUATION_PAUSE
		await get_tree().create_timer(wait_time).timeout
		if not _is_text_revealing:
			break
	_finish_text_reveal()

func _finish_text_reveal():
	dialogue_label.text = _curr_dialogue[_curr_page_index].get("text", "")
	_is_text_revealing = false
	continue_label.show()

func _advance_dialogue():
	_curr_page_index += 1
	if _curr_page_index >= _curr_dialogue.size():
		hide_dialogue()
	else:
		_show_current_page()

func hide_dialogue():
	panel.hide()
	_is_dialogue_active = false
	_curr_dialogue.clear()
	get_tree().paused = false
	dialogue_finished.emit()

# Optional: for cutscene control
func _on_cutscene_signal(signal_name: String):
	match signal_name:
		"show_movement_tutorial":
			start_dialogue([{"name": "System", "text": "Use WASD or arrow keys to move"}])
		"show_jump_tutorial":
			start_dialogue([{"name": "System", "text": "Press SPACE to jump over obstacles"}])

func _on_tutorial_complete():
	if cutscene_player and cutscene_player.has_method("resume"):
		cutscene_player.resume()
