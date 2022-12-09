extends Node


export (PackedScene) var Apple
export (PackedScene) var GoldenApple
export (int) var playTime = 30
var level
var score
var time_left
var screenSize
var playing = false

func _ready():
	randomize()
	screenSize = get_viewport().get_visible_rect().size
	$Player.screensize = screenSize
	$Player.hide()
	$Wolf.screensize = screenSize
	$Wolf.hide()
	

func _process(delta):
	if playing and $AppleContainer.get_child_count() ==0:
		level +=1
		Audio.play("level_up",15)
		time_left+=6
		$Wolf.move()
		spawnPowerUp()
		apple_spawn()

func new_game():
	Audio.background_music(true)
	playing = true
	level = 1
	score = 0
	time_left = playTime
	$Player.start($PlayerStart.position)
	$Player.show()
	$Wolf.show()
	$Wolf.setup($WolfStart.position)
	$GameTimer.start()
	apple_spawn()
	$HUD.update_score(score)
	$HUD.update_time(time_left)

func apple_spawn():
	for i in 3 + level:
		var apple = Apple.instance()
		$AppleContainer.add_child(apple)
		apple.screenSize = screenSize
		apple.position = Vector2(
			rand_range(0, screenSize.x), 
			rand_range(0,screenSize.y))


func _on_GameTimer_timeout():
	time_left -=1
	$HUD.update_time(time_left)
	if time_left < 0:
		$HUD.update_time(0)
		game_over()
	

func _on_Player_hurt():
	game_over()


func _on_Player_pickup(type):
	match type:
		"apples":
			score+=1
			$HUD.update_score(score)
			Audio.play("pickup_apple",15)
		"powerUps":
			time_left+=10
			$HUD.update_time(time_left)
			Audio.play("powerup",15)

func game_over():
	Audio.background_music(false)
	Audio.play("die",15)
	playing = false
	$GameTimer.stop()
	for apple in $AppleContainer.get_children():
		apple.queue_free()
	$HUD.show_gameOver()
	$Player.die()


func _on_HUD_start_game():
	new_game()

func spawnPowerUp():
	$PowerUpTimer.wait_time = rand_range(5,10)
	$PowerUpTimer.start()

func _on_PowerUpTimer_timeout():
	var powerUpGoldenApple = GoldenApple.instance()
	add_child(powerUpGoldenApple) 
	powerUpGoldenApple.screenSize = screenSize
	powerUpGoldenApple.position = Vector2(
			rand_range(0, screenSize.x), 
			rand_range(0,screenSize.y))
