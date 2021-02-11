extends LineEdit

signal time_scale_changed(time_scale)

var old_text := text


func _on_TimeScale_text_changed(new_text: String) -> void:
	if old_text == new_text:
		return

	if new_text.is_valid_integer() or new_text.empty():
		old_text = new_text
		emit_signal("time_scale_changed", int(new_text))
	else:
		text = old_text
