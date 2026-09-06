extends MovingElement
class_name Log

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var logSpriteShort: Sprite2D = $LogSpriteShort
@onready var logSpriteLong: Sprite2D = $LogSpriteLong
@onready var logSpriteExtraLong: Sprite2D = $LogSpriteExtraLong
@onready var logAreaShort: Area2D = $LogSpriteShort/LogArea
@onready var logAreaLong: Area2D = $LogSpriteLong/LogArea
@onready var logAreaExtraLong: Area2D = $LogSpriteExtraLong/LogArea

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
func setup(startingVector, startingDirection, numberOfPieces: int = 3, speedSetter: int = 100):
	super.setup(startingVector, startingDirection, numberOfPieces)
	super.setSpeed(speedSetter)
	
func setLength():
	match length:
		3:
			logSpriteLong.visible = false
			logSpriteExtraLong.visible = false
			logAreaLong.set_deferred("collision_layer", 0)
			logAreaExtraLong.set_deferred("collision_layer", 0)
		4:
			logSpriteShort.visible = false
			logSpriteExtraLong.visible = false
			logAreaShort.set_deferred("collision_layer", 0)
			logAreaExtraLong.set_deferred("collision_layer", 0)
		5:
			logSpriteShort.visible = false
			logSpriteLong.visible = false
			logAreaShort.set_deferred("collision_layer", 0)
			logAreaLong.set_deferred("collision_layer", 0)
