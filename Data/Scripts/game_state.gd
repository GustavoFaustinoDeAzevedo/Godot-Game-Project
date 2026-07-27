extends Node

#===============================================================================
# GLOBAL STATE
#===============================================================================

## Switches globais do jogo.
## Exemplo:
## "door_open" -> true
## "boss_dead" -> false
var switches: Dictionary[StringName, bool] = {}

## Variáveis globais do jogo.
## Exemplo:
## "gold" -> 350
## "player_level" -> 12
var variables: Dictionary[StringName, Variant] = {}

#===============================================================================
# SWITCHES
#===============================================================================

## Define o valor de um switch global.
func set_switch(
	switch_name: StringName,
	value: bool
):

	switches[switch_name] = value


## Retorna o valor de um switch.
## Caso não exista, retorna false.
func get_switch(
	switch_name: StringName
) -> bool:

	return switches.get(
		switch_name,
		false
	)


## Alterna automaticamente o valor do switch.
func toggle_switch(
	switch_name: StringName
):

	set_switch(
		switch_name,
		!get_switch(switch_name)
	)


## Remove um switch.
func erase_switch(
	switch_name: StringName
):

	switches.erase(switch_name)

#===============================================================================
# VARIABLES
#===============================================================================

## Define uma variável global.
func set_variable(
	variable_name: StringName,
	value: Variant
):

	variables[variable_name] = value


## Retorna uma variável.
## Caso não exista, retorna o valor padrão informado.
func get_variable(
	variable_name: StringName,
	default_value: Variant = null
) -> Variant:

	return variables.get(
		variable_name,
		default_value
	)


## Remove uma variável.
func erase_variable(variable_name: StringName):
	variables.erase(variable_name)

#===============================================================================
# RESET
#===============================================================================

## Limpa completamente o estado do jogo.
## Útil para "Novo Jogo".
func clear():

	switches.clear()
	variables.clear()
