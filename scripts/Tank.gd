extends StaticBody2D

func _ready():
	randomize()

func _on_WaterLevel_body_entered(body):
	body.jump()
