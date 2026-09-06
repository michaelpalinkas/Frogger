extends Node2D
class_name MovingElement

const LEFT_EDGE = 0
const RIGHT_EDGE = 480
const SEGMENT_LENGTH = 32

var speed: int 
var direction: int
var startingY: int
var velocity: Vector2
var length: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(delta * speed * direction, 0)
	self.translate(velocity)
	
	if direction == 1:
		if self.position.x  > RIGHT_EDGE :
			self.position.x = LEFT_EDGE - (SEGMENT_LENGTH * length)
	elif direction == -1:
		if self.position.x < LEFT_EDGE - (SEGMENT_LENGTH * length):
			self.position.x = RIGHT_EDGE  + (SEGMENT_LENGTH * length)
	
func setup(startingVector, startingDirection, numberOfPieces: int = 1):
	startingY = startingVector.y
	velocity = startingVector
	self.translate(velocity)
	direction = startingDirection
	length = numberOfPieces
	

func setSpeed(setSpeed):
	speed = setSpeed
	
func getVelocity() -> Vector2:
	return velocity
	

