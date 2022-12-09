extends Area2D

#export sirve para poder ver las variables en el inspector y es 
#necesario poner que tipo de variable es en este caso int
export (int) var speed = 320
var velocity = Vector2()
#estamos pasando el valor al vector
var screensize = Vector2(448,704)
signal pickup
signal hurt



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#esta funcion nos permite cargar todas las mecanicas frame a frame
func _process(delta):
	#llamada a la funcion get_input generada abajo
	get_input()
	#nos permite mover al personaje a partir de su posicion y la velocidad de esta
	position += velocity * delta 
	#estas dos lineas son para marcar entre que posiciones se puede mover
	#nuestro personaje
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)
	
	#este if nos controla las animaciones de nuestro personaje
	if velocity.length()>0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x > 0
	else:
		$AnimatedSprite.animation = "idle"


func get_input():
	velocity =  Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y +=1
	if Input.is_action_pressed("ui_left"):
		velocity.x -=1
	if Input.is_action_pressed("ui_right"):
		velocity.x +=1
	#para comprobar si se esta moviendo
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

#esta funcion es cuando muera el jugador
func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)


func _on_Player_area_entered(area):
	if area.is_in_group("apples"):
		area.pickup()
		emit_signal("pickup","apples")
	if area.is_in_group("powerUps"):
		area.pickup()
		emit_signal("pickup","powerUps")
	if area.is_in_group("enemy"):
		emit_signal("hurt")
		die()
