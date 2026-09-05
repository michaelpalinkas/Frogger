extends Node2D
class_name Lives

@onready var livesSprite: Sprite2D = $LivesSprite

signal gameOver
var lives
# Called when the node enters the scene tree for the first time.
func _ready():
	lives = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addLife():
	if lives <= 5:
		lives += 1
		livesSprite.frame = lives - 1
	
func decreaseLife():
	if lives >= 1:
		lives -= 1
		livesSprite.frame = lives
		if lives == 0:
			gameOver.emit()
		
