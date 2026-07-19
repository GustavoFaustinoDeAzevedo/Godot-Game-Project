extends StateBase
class_name PlayerState

var player: Player:
	get:
		return character as Player

func exit():
	print(self.name, ' exit')
