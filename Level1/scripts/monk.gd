extends CharacterBody2D

# References to the UI labels
@onready var prompt_label: Label = get_node("/root/GamePlay1/UI/PromptLabel")
@onready var dialogue_label: Label = get_node("/root/GamePlay1/UI/DialogueLabel")
var can_interact: bool = false

func _ready():
	# Ensure the labels are hidden initially
	prompt_label.visible = false
	dialogue_label.visible = false

func interact():
	# Show the Monk's dialogue
	dialogue_label.text = "You can find the manuscripts and the hidden chamber in the first room."
	dialogue_label.visible = true
	# Hide the prompt while the dialogue is shown
	prompt_label.visible = false
	# Hide the dialogue after 3 seconds
	await get_tree().create_timer(3.0).timeout
	dialogue_label.visible = false
	# Re-show the prompt if the Engineer is still in the interaction zone
	if can_interact:
		prompt_label.visible = true

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.name == "Engineer":  # Check if the body is the Engineer
		can_interact = true
		body.nearby_monk = self  # Set the Engineer's nearby_monk to this Monk
		prompt_label.text = "To interact with the monk, press E"
		prompt_label.visible = true

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.name == "Engineer":
		can_interact = false
		body.nearby_monk = null  # Clear the Engineer's nearby_monk reference
		prompt_label.visible = false
