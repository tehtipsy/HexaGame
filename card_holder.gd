extends Container


var card_in_hand = ""

func _process(delta):
	self.global_position = get_global_mouse_position()
