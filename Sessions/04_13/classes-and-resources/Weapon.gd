extends Item
class_name Weapon

@export var damage = 5


func _attack():
	print('you did ',damage, 'damage!')
	


func use():
	_attack()
