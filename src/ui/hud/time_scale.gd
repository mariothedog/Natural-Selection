extends LineEdit

signal time_scale_changed(time_scale)

var old_text := text

var _max_time_scale = floor((pow(2, 31) - 1) / 60)


func _on_TimeScale_text_changed(new_text: String) -> void:
	if old_text == new_text:
		return
	
	var num = int(new_text)
	if (new_text.is_valid_integer() or new_text.empty()):
		if num > _max_time_scale:
			num = _max_time_scale
		new_text = str(num)
		if text != new_text:
			text = new_text
		old_text = new_text
		emit_signal("time_scale_changed", num)
	else:
		text = old_text
