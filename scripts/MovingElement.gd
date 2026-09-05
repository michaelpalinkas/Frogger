extends Node2D
class_name MovingElement

const LEFT_EDGE = -32
const RIGHT_EDGE = 512

var speed: int 
var direction: int
var startingY: int
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(delta * speed * direction, 0)
	self.translate(velocity)
	
	if direction == 1:
		if self.position.x > RIGHT_EDGE:
			self.position.x = LEFT_EDGE
	elif direction == -1:
		if self.position.x < LEFT_EDGE:
			self.position.x = RIGHT_EDGE 
	
func setup(startingVector, startingDirection):
	startingY = startingVector.y
	velocity = startingVector
	self.translate(velocity)
	direction = startingDirection

func setSpeed(setSpeed):
	speed = setSpeed
	
func getVelocity() -> Vector2:
	return velocity
	

