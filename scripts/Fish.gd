extends KinematicBody2D

const MAX_SPEED = 50
const ACCELERATION = 50
const RESISTANCE = 25
const GRAVITY = 50

enum {
	WANDER,
	FALL,
	EAT
}

export(int) var min_move_distance: int = 50
export(int) var max_move_distance: int = 100
export(float) var min_move_time: float = 2
export(float) var max_move_time: float = 4

onready var sprite: Sprite = $Sprite
onready var moveTimer: Timer = $MoveTimer

var moving: bool = false
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var orignal_position: Vector2
var distance: float
var state = WANDER

func _ready() -> void:
	set_move_timer()

func _physics_process(delta: float) -> void:
	match state:
		WANDER:
			wander_state(delta)
		FALL:
			fall_state(delta)
		EAT:
			pass

func wander_state(delta: float) -> void:
	if moving:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		if position.distance_to(orignal_position) >= distance:
			moving = false
			set_move_timer()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, RESISTANCE * delta)
	
	velocity = move_and_slide(velocity)

func fall_state(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity)
	
	if position.y - 15 >= 0:
		state = WANDER
		moving = false

func jump() -> void:
	state = FALL

func check_bounds() -> bool:
	return true

func set_move_timer() -> void:
	moveTimer.start(rand_range(min_move_time, max_move_time))

func _on_MoveTimer_timeout() -> void:
	moveTimer.stop()
	orignal_position = position
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	sprite.flip_h = direction.x < 0
	distance = rand_range(min_move_distance, max_move_distance)
	moving = true
