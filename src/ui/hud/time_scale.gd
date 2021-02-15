extends LineEdit

signal time_scale_changed(time_scale)

var _old_text := text
var _max_time_scale: int = floor((pow(2, 31) - 1) / 60)


func _on_TimeScale_text_changed(new_text: String) -> void:
	var num := int(new_text)
	var old_num := int(_old_text)
	if new_text.empty():
		num = 0
	elif num > _max_time_scale:
		num = _max_time_scale
		new_text = str(num)
		var caret_position_temp := caret_position
		text = new_text
		caret_position = caret_position_temp
	elif not new_text.is_valid_integer() or num < 0 or (old_num == num and not _old_text.empty()):
		var caret_position_temp := caret_position
		text = _old_text
		caret_position = caret_position_temp
		return

	if old_num != num:
		emit_signal("time_scale_changed", num)
	_old_text = new_text
