
extends KinematicBody

const SPEED_WALK = 2
const SPEED_RUN = 4
const SPEED_CROUCH = 0.5

var vel = Vector3()
var anim = ''
var state = ''
var run = false
var crouch = false
var anim_speed = 3
var move_speed = 0
var active_pistol = null

func _ready():
	Global.player = self
	Anim('Idle', 'Idle')
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta: float) -> void:
	get_parent().get_node("Terrain/Grass/multigrass").material_override.set_shader_param("player_pos", global_transform.origin)
	get_parent().get_node("Terrain/Grass/multiflower").material_override.set_shader_param("player_pos", global_transform.origin)

func _physics_process(_delta):
	vel.x = 0
	vel.z = 0
	vel.y = -7
	
		
	if is_on_floor():
		vel.y = 0
	
	if move_speed:
		if run:
			vel.z = move_speed * SPEED_RUN
			anim_speed = 8
			Anim('Run', 'Run')
		elif crouch:
			vel.z = move_speed *SPEED_CROUCH
			anim_speed = 2
			Anim('Walk_Hide', 'Walk_Hide')
		else:
			vel.z = move_speed * SPEED_WALK
			anim_speed = 6
			Anim('Walk', 'Walk')
	else:
		Anim('Idle', 'Idle')
		
	vel = vel.rotated(Vector3.UP, rotation.y)
	vel = move_and_slide(vel, Vector3.UP, true)

func Anim(s, a):
	if s && s != state:
		state = s
	if a && a != anim:
		$AnimationPlayer.play(a, 0.2, anim_speed)
		anim = a
