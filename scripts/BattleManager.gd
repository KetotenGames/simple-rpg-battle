extends Node
class_name BattleManager

signal player_turn_started

# シーン上のプレイヤー・敵を外部から割り当て
@export var player_node_path: NodePath
@export var enemy_node_path: NodePath

var player: Character
var enemy: Character
var is_player_turn: bool = true

func _ready() -> void:
	player = get_node(player_node_path)
	enemy = get_node(enemy_node_path)
	_start_turn()
	
func _start_turn():
	if is_player_turn:
		_enable_player_input()
	else:
		_enemy_action()
		
func _enable_player_input():
	# UIボタンを活性化するなど
	emit_signal("player_turn_started")
	
func on_player_action(action: String):
	match action:
		"attack":
			var damage = player.attack(enemy)
			print("プレイヤーの攻撃:", damage, "ダメージ")
		"defend":
			# defend用のロジック(省略)
			pass
			
	_check_battle_end()
	is_player_turn = false
	_start_turn()
	
func _enemy_action():
	# シンプルに常に攻撃
	var damage = enemy.attack(player)
	print("敵の攻撃:", damage, "ダメージ")
	_check_battle_end()
	is_player_turn = true
	_start_turn()
	
func _check_battle_end():
	if enemy.hp <= 0:
		print("勝利！")
		get_tree().paused = true
	elif player.hp <= 0:
		print("敗北…")
		get_tree().paused = true
