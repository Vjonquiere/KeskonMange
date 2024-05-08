extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_submit_button_pressed():
	if $VFlowContainer/UserNameEntry.text == "" or $VFlowContainer/HostNameEntry.text == "":
		$VFlowContainer/ErrorLabel.text = "Username and Hostname can't be empty"
		$VFlowContainer/ErrorLabel.visible = true
	var settings = {}
	settings["host"] = $VFlowContainer/HostNameEntry.text
	settings["username"] = $VFlowContainer/UserNameEntry.text
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(settings))
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_user_name_entry_text_changed():
	$VFlowContainer/ErrorLabel.visible = false


func _on_host_name_entry_text_changed():
	$VFlowContainer/ErrorLabel.visible = false


func _on_error_label_draw():
	await get_tree().create_timer(5).timeout
	$VFlowContainer/ErrorLabel.visible = false
