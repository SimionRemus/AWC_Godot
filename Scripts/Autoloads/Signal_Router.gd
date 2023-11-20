extends Node

##| Description |###############################################
################################################################
#	This Signal_Router autoload is created to allow different scenes to communicate with one another
#	As an example, pressing escape from Player scene sends a signal to this node which then relays
#	the signal to the UI. This is done in the following manner:
#
#	in Player.gd:
#		pause.connect(signalRouter._on_pause)
#		pause.emit()
#	here:
#		signal pause
#		func _on_pause():
#			pause.emit()
#	in MainMenu.gd:
#		SignalRouter.pause.connect(_pause)
#		func _pause():
#			gameplay_ui.hide()
#			main_menu.show()
#			play_button.hide()
################################################################

signal pause
func _on_pause():
	pause.emit()
	
signal unpause
func _on_unpause():
	unpause.emit()

signal player_disguise_finished
func _on_player_disguise_finished():
	player_disguise_finished.emit()
