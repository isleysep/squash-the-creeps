extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true



func _on_player_twirl(yes: Variant) -> void:
	visible = yes
