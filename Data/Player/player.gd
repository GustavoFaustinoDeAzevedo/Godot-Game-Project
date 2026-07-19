extends CharacterBody3D
class_name Player

@onready var mover: GridMover = $GridMover
@onready var rotator: GridRotator = $GridRotator
@onready var state_machine: StateMachine = $StateMachine
