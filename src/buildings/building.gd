extends Node2D

class_name Building

var exterior_sprite : Sprite2D:
	get: 
		return $ExteriorSprite
var body_inside : bool
var area : Area2D:
	get: 
		return $InteriorArea2D
var rect : RectangleShape2D:
	get: 
		return $InteriorArea2D/CollisionShape2D.shape

@warning_ignore("unused_parameter")
func _process(delta):
	var fade_rate = -0.02 if body_inside else 0.02
	exterior_sprite.modulate.a = clamp(exterior_sprite.modulate.a + fade_rate, 0, 1)


func _on_interior_area_2d_body_entered(body):
	if body.name == "Player":
		body_inside = true


func _on_interior_area_2d_body_exited(body):
	if body.name == "Player":
		body_inside = false
