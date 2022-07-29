extends Position3D

export(NodePath) var target_node
var camera
var target
var rot_y = 0
var ray1


func _ready():
	target = get_node(target_node)
	camera = $Camera
	ray1 = camera.transform
	
	
func _process(_delta):
	transform.origin = target.transform.origin + Vector3(0, 1.5, 0)
	
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_shift"):
			target.run = true
		elif Input.is_action_pressed("ui_crouched"):
			target.crouch = true
		else:
			target.run = false
			target.crouch = false
		target.move_speed = -1
		rot_y = rotation.y
	elif Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_shift"):
			target.run = true
		elif Input.is_action_pressed("ui_crouched"):
			target.crouch = true
		else:
			target.run = false
			target.crouch = false
		target.move_speed = -1
		rot_y = rotation.y - PI
	elif Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_shift"):
			target.run = true
		elif Input.is_action_pressed("ui_crouched"):
			target.crouch = true
		else:
			target.run = false
			target.crouch = false
		target.move_speed = -1
		rot_y = rotation.y + PI/2
	elif Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_shift"):
			target.run = true
		elif Input.is_action_pressed("ui_crouched"):
			target.crouch = true
		else:
			target.run = false
			target.crouch = false
		target.move_speed = -1
		rot_y = rotation.y - PI/2
	else:
		target.move_speed = 0
	
	if target.move_speed:
		target.transform.basis = Basis(target.transform.basis.get_rotation_quat().slerp(Basis(Vector3.UP, rot_y).get_rotation_quat(), 5 * _delta))
	
	if $detector.is_colliding():
		
		ray1.origin.z = $detector.get_collision_point().distance_to(global_transform.origin) - 0.5
	else:
		ray1.origin.z = 10
	camera.transform = camera.transform.interpolate_with(ray1, 5 * _delta)
func _input(e):
	if e is InputEventMouseMotion:
		rotation.y -= e.relative.x * 0.007
		rotation.x = clamp(rotation.x - e.relative.y * 0.005, -1.2, 0) 
		
