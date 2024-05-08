extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_connexion_status(connected:bool):
	if !connected:
		$ConnectedTexture.texture = load("res://Main/ServerStatusWidget/disconnected.png")
		$ConnectedTexture/ConnectedLabel.text = "Offline"
	else:
		$ConnectedTexture.texture = load("res://Main/ServerStatusWidget/connected.png")
		$ConnectedTexture/ConnectedLabel.text = "Online"
