extends CanvasLayer


signal start_game

func _ready():
	$Control/StartButtom.grab_focus()

func update_score(value):
	$Control/HBoxContainer/SccoreLabel.text = str(value)

func update_time(value):
	$Control/HBoxContainer/TimerLabel.text = str(value)

func show_message(text):
	$Control/MessageLabel.text = text
	$Control/MessageLabel.show()
	$MessageTimer.start()

func _on_MessageTimer_timeout():
	$Control/MessageLabel.hide()



func _on_StartButtom_pressed():
	$Control/StartButtom.hide()
	_on_MessageTimer_timeout()
	emit_signal("start_game")

func show_gameOver():
	show_message("!!!GAME OVER!!!")
	yield($MessageTimer,"timeout")
	$Control/StartButtom.show()
	$Control/StartButtom.grab_focus()
	$Control/MessageLabel.text = "Pick The Apple!"
	$Control/MessageLabel.show()
