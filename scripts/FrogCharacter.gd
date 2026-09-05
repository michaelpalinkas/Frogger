extends Node2D

@onready var frog: Node2D = $"."
@onready var frogSprite: Sprite2D = $FrogSprite
@onready var frogShape: Area2D = $FrogSprite/FrogShape
@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var drownTimer: Timer = $DrownTimer

const SPEED = 200
const MOVE_LENGTH = 32
const FRAME_STOPPED = 0
const FRAME_JUMPING = 1
const VECTORSPACECHECK = 6

var processingmove: bool = false
var destinationX: int = -1
var destinationY: int = -1
var startingPos: Vector2
var isDead: bool = false
var waterSafe: bool = false
var matchMoveVel: Vector2

var currentPos: Vector2
var destPos: Vector2
var drawRay: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isDead:
		if waterSafe:
			self.translate(matchMoveVel)
		
		if Input.is_action_just_pressed("LEFT"):
			if processingmove == false:
				processingmove = true		
				frogSprite.rotation_degrees = -90
				destinationX = frog.position.x - MOVE_LENGTH
		
		if Input.is_action_just_pressed("RIGHT"):
			if processingmove == false:
				processingmove = true		
				frogSprite.rotation_degrees = 90
				destinationX = frog.position.x + MOVE_LENGTH
			
		if Input.is_action_just_pressed("UP"):
			if processingmove == false:
				processingmove = true		
				frogSprite.rotation_degrees = 0
				destinationY = frog.position.y - MOVE_LENGTH
		
		if Input.is_action_just_pressed("DOWN"):
			if processingmove == false:
				processingmove = true		
				frogSprite.rotation_degrees = 180
				destinationY = frog.position.y + MOVE_LENGTH
		
	if processingmove == true:
		if !isDead:
			frogSprite.frame = FRAME_JUMPING
		if destinationX != -1 and frog.position.x > destinationX: #left
			frog.position.x = frog.position.x - (delta * SPEED)
			if frog.position.x <= destinationX:
				frog.position.x = destinationX
				processingmove = false
				destinationX = -1
		if destinationX != -1 and frog.position.x < destinationX: #right
			frog.position.x = frog.position.x + (delta * SPEED)
			if frog.position.x >= destinationX:
				frog.position.x = destinationX
				processingmove = false
				destinationX = -1
		if destinationY != -1 and frog.position.y > destinationY: #up
			frog.position.y = frog.position.y - (delta * SPEED)
			if frog.position.y <= destinationY:
				frog.position.y = destinationY
				processingmove = false
				destinationY = -1
		if destinationY != -1 and frog.position.y < destinationY: #down
			frog.position.y = frog.position.y + (delta * SPEED)
			if frog.position.y >= destinationY:
				frog.position.y = destinationY
				processingmove = false
				destinationY = -1
	else:
		if !isDead:
			frogSprite.frame = FRAME_STOPPED
		
func splat():
	isDead = true
	matchMoveVel = Vector2(0, 0)
	animPlayer.play("Splat")

func drown():
	isDead = true
	matchMoveVel = Vector2(0, 0)
	animPlayer.play("Drown")

func _on_frog_shape_area_entered(area):
	var collisionArea: Area2D = area
	match collisionArea.name:
		"VehicleArea":
			splat()
		"WaterArea":
			if !waterSafe:
				drownTimer.start()
		"LogArea", "TurtleArea":
			if !waterSafe:
				waterSafe = true
				var movingElement: MovingElement = collisionArea.get_parent().get_parent()
				matchMoveVel = movingElement.getVelocity()
			
func _on_frog_shape_area_exited(area):
	var collisionArea: Area2D = area
	match collisionArea.name:
		"LogArea", "TurtleArea":
			if waterSafe:
				waterSafe = false
				var spaceState = get_world_2d().direct_space_state
				var query: PhysicsRayQueryParameters2D				
				var rotationDeg: int = frogSprite.rotation_degrees
				var results
				currentPos = self.global_position
				match rotationDeg:
					0:
						currentPos.y = currentPos.y - VECTORSPACECHECK
						destPos = Vector2(currentPos.x, currentPos.y - VECTORSPACECHECK)
					90:
						currentPos.x = currentPos.x + VECTORSPACECHECK
						destPos = Vector2(currentPos.x + VECTORSPACECHECK, currentPos.y)
					-90:
						currentPos.x = currentPos.x - VECTORSPACECHECK
						destPos = Vector2(currentPos.x - VECTORSPACECHECK, currentPos.y)
					180:
						currentPos.y = currentPos.y + VECTORSPACECHECK
						destPos = Vector2(currentPos.x, currentPos.y + VECTORSPACECHECK)
				query = PhysicsRayQueryParameters2D.create(currentPos, destPos)
				query.hit_from_inside = true
				query.collide_with_areas = true
				query.collision_mask = 1
				query.exclude = [frogShape.get_rid()]
				#drawRay = true
				#queue_redraw()
				results = spaceState.intersect_ray(query)
				if results:
					var collisionObject: Area2D = results["collider"]
					if collisionObject:
						#print(collisionObject.name)
						match collisionObject.name:
							"TurtleArea", "LogArea":
								waterSafe = true
				else:
					query.collision_mask = 2
					results = spaceState.intersect_ray(query)
					if results:
						var collisionObject: Area2D = results["collider"]
						if collisionObject:
							#print(collisionObject.name)
							match collisionObject.name:
								"WaterArea":
									drown()
					
	

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Splat", "Drown":
			isDead = false
			self.position.x = startingPos.x
			self.position.y = startingPos.y
			frogSprite.rotation_degrees = 0
			frogSprite.self_modulate.a = 1		

func _on_drown_timer_timeout():
	if !waterSafe:
		drown()
		
func _draw(): 
	if drawRay: #just for debugging
		draw_line(to_local(currentPos), to_local(destPos), Color.GREEN, 2)
