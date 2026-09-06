extends CanvasLayer

@onready var titleLabel: Label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var newGameButton: Button = $PanelContainer/MarginContainer/VBoxContainer/NewGameButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Enter"):
		newGameButton.pressed.emit()

func setTitleLabel(title):
	titleLabel.text = title
	
func setNewGameButtonEnabled(enabled):
	pass #newGameButton.enabled = enabled
