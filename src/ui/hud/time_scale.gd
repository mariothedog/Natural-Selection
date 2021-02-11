extends LineEdit

signal time_scale_changed(time_scale)

var old_text := text

var _max_time_scale := floor((pow(2, 31) - 1) / 60)


func _on_TimeScale_text_changed(new_text: String) -> void:
	var num := int(new_text)
	if int(old_text) == num or num < 0:
		text = old_text
		return
	
	num = int(min(num, _max_time_scale))
	
	new_text = str(num)
	if text != new_text:
		text = new_text
	old_text = new_text
	emit_signal("time_scale_changed", num)
