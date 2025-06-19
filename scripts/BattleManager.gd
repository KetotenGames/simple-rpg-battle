extends Node
class_name BattleManager

signal player_turn_started

# シーン上のプレイヤー・敵を外部から割り当て
@export var player_node_path: NodePath
@export var enemy_node_path: NodePath

@onready var ui = get_node("/root/BattleScene/CanvasLayer/UI")

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
		await _enemy_action()
		
func _enable_player_input():
	# UIボタンを活性化するなど
	emit_signal("player_turn_started")
	
func on_player_action(action: String):
	match action:
		"attack":
			await _player_attack_sequence()

		"defend":
			await _player_defend_sequence()
			
	_check_battle_end()
	
	if enemy.hp > 0 and player.hp > 0:
		is_player_turn = false
		await _enemy_action() # 攻撃演出後に敵ターン
		_check_battle_end()
		
		if enemy.hp > 0 and player.hp > 0:
			is_player_turn = true
			_start_turn()

func _check_battle_end():
	if enemy.hp <= 0:
		print("勝利！")
		get_tree().paused = true
	elif player.hp <= 0:
		print("敗北…")
		get_tree().paused = true

# プレイヤー攻撃シーケンス
func _player_attack_sequence() -> void:
	# 攻撃アニメーション再生
	ui.set_action_buttons_enabled(false) # ボタン無効化
	var animePlayer = player.get_node("AnimationPlayer")
	animePlayer.play("attack")
	await animePlayer.animation_finished
	
	# 敵へのダメージ処理
	var damage = player.attack(enemy)
	print("プレイヤーの攻撃:", damage, "ダメージ")
	
	# 敵のHPだけ更新
	ui.update_enemy_hp()
	await get_tree().create_timer(0.5).timeout

# プレイヤー防御シーケンス
func _player_defend_sequence() -> void:
	# 防御アニメーション再生
	ui.set_action_buttons_enabled(false) # ボタン無効化
	var animePlayer = player.get_node("AnimationPlayer")
	animePlayer.play("defend")
	await animePlayer.animation_finished
	
	player.defend()
	print("プレイヤーは防御の構えを取った！")
	
	# 防御時はHP変動なしだが、HP表示だけリフレッシュ
	ui.update_player_hp()
	await get_tree().create_timer(0.3).timeout
	
	
# 敵攻撃シーケンス
func _enemy_action() -> void:
	# 攻撃アニメーション再生
	ui.set_action_buttons_enabled(false) # ボタン無効化
	var animePlayer = enemy.get_node("AnimationPlayer")
	animePlayer.play("attack")
	await animePlayer.animation_finished
	
	# プレイヤーへのダメージ処理
	var damage = enemy.attack(player)
	print("敵の攻撃:", damage, "ダメージ")
	
	# プレイヤーのHPだけ更新
	ui.update_player_hp()
	await get_tree().create_timer(0.5).timeout
	

