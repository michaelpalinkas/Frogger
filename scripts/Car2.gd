extends MovingElement
class_name Car2

const SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	super.setSpeed(SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
