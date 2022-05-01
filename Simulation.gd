extends Spatial

onready var ground_shader = $Ground.mesh.surface_get_material(0)

onready var wheel_frontRight  = $Car/wheel2/s
onready var wheel_frontLeft  = $Car/wheel4/s
onready var wheel_backLeft  = $Car/wheel3/s
onready var wheel_backRight  = $Car/wheel/s

onready var cameraPot = $CameraPot

onready var car = $Car

onready var VSliderLeft = $"../../Inputs/L"
onready var VSliderRight = $"../../Inputs/R"

onready var Pointer = $"../../Inputs/Panel/Pointer"
onready var Automatic = $"../../Automatic"

var vel = 1
var dir = 0

func add_wheel(w,v):
	w.rotation.y += v

func add_LeftWheels(value):
	add_wheel(wheel_backLeft,value)
	add_wheel(wheel_frontLeft,value)

func add_RightWheels(value):
	add_wheel(wheel_backRight,value)
	add_wheel(wheel_frontRight,value)

var actual_ground_offset : Vector2
func add_groundOffset(offset:Vector2):
	actual_ground_offset += offset
	ground_shader.set_shader_param("offset",actual_ground_offset)

var directional_speed = 7
var rotational_speed = 1.2

var vector_direction = Vector2(0,0)

func _process(delta):
	
	var l
	var r
	if Automatic.pressed:
		vel += Input.get_axis("ui_down","ui_up") * 0.1
		vel = clamp(vel,-1,1)
		dir += Input.get_axis("ui_left","ui_right") * 0.05
		dir = clamp(dir,-1,1)
		l  = vel * (1 +2*dir)
		r = vel * (1 -2*dir)
		VSliderLeft.value = l
		VSliderRight.value = r
	
	else:
		l = VSliderLeft.value
		r = VSliderRight.value
		dir = (r -l) / -2
		vel = l if abs(l) >= abs(r) else r
		
	
	var _l = clamp(l,-1,1) * delta * directional_speed
	var _r = clamp(r,-1,1) * delta * directional_speed
	
	add_LeftWheels(_l)
	add_RightWheels(_r)
	
	add_groundOffset(Vector2(vel * directional_speed * 0.04,0).rotated(-car.rotation.y) * delta * (1 - abs(dir) ) )
	
	car.rotation.y += -dir * delta * vel * rotational_speed
	

	Pointer.anchor_left = (dir*0.4) + 0.5
	Pointer.anchor_top = (-vel*0.4) + 0.5
	
	cameraPot.rotation.y = (cameraPot.rotation.y * 0.99) + (car.rotation.y * 0.01)
	
	
