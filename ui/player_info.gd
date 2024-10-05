class_name PlayerInfo extends Control


func show_ui_element():
	$AnimationPlayer.play("show")

func hide_ui_element():
	$AnimationPlayer.play("hide")
