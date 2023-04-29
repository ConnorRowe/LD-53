extends Node

@export var max_angle: float = .1
@export var max_translation: Vector2 = Vector2(4, 4)
@export var max_scale: Vector2 = Vector2.ZERO
@export var decay: float = .9
@export var noise: Noise

var parent: Node
var trauma: float = 0
var noise_y: int = 0

var initial_pos: Vector2
var initial_rot: float
var initial_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	
	initial_pos = parent.position
	initial_rot = parent.rotation
	initial_scale = parent.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trauma > 0:
		trauma = maxf(trauma - (decay * delta), 0)
		
		var amount: float = pow(trauma, 2)
		
		if noise_y > 1000000:
			noise_y = 0
		else:
			noise_y += 1
		
		var translation = Vector2()
		translation.x = max_translation.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
		translation.y = max_translation.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
		
		parent.position = initial_pos + translation
		
		var rotation = max_angle * amount * noise.get_noise_2d(noise.seed, noise_y)
		
		parent.rotation = initial_rot + rotation
		
		var scale = Vector2()
		scale.x = max_scale.x * amount * noise.get_noise_2d(noise.seed * 4, noise_y)
		scale.y = max_scale.y * amount * noise.get_noise_2d(noise.seed * 5, noise_y)
		
		parent.scale = initial_scale + scale

func shake(strength: float):
	trauma = minf(trauma + strength, 1)
