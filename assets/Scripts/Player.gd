extends KinematicBody

var speed = 10
var mouse_Sensativity = 0.05
var h_acceleration = 6
var gravity = 20
var jump = 10
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()


onready var head = $head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Camera movement
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_Sensativity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_Sensativity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
# Movement
func _physics_process(delta):
	direction = Vector3()
	
	# Gravity
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	else:
		gravity_vec = get_floor_normal() * -gravity
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump
	
	# Movement
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	
	move_and_slide(movement, Vector3.UP)
