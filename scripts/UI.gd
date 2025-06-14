extends Control

@onready var battle_manager = get_node("/root/BattleScene").get_node("BattleManager")
@onready var hp_label_player = $VBoxContainer/PlayerHPLabel
@onready var hp_label_enemy = $VBoxContainer/EnemyHPLabel
@onready var btn_attack = $VBoxContainer/HBoxContainer/AttackButton
@onready var btn_defend = $VBoxContainer/HBoxContainer/DefendButton

func _ready() -> void:
	# BattleManagerのシグナル接続
	battle_manager.connect("player_turn_started", Callable(self, "_on_player_turn_started"))
	
	# ボタンのpressed()シグナルを接続
	btn_attack.connect("pressed", Callable(self, "on_attack_button_pressed"))
	btn_defend.connect("pressed", Callable(self, "on_defend_button_pressed"))
	
	# 初期ラベル更新 & ボタン有効化
	_update_labels()
	_on_player_turn_started()
	
	
func _on_player_turn_started():
	btn_attack.disabled = false
	btn_defend.disabled = false
	
func on_attack_button_pressed():
	print("▶ Attack ボタンが押されました")  # デバッグ用
	btn_attack.disabled = true
	btn_defend.disabled = true
	battle_manager.on_player_action("attack")
	_update_labels()

func on_defend_button_pressed():
	print("▶ Defend ボタンが押されました")  # デバッグ用
	btn_attack.disabled = true
	btn_defend.disabled = true
	battle_manager.on_player_action("defend")
	_update_labels()
	
func _update_labels():
	hp_label_player.text = "HP: %d" % battle_manager.player.hp
	hp_label_enemy.text  = "HP: %d" % battle_manager.enemy.hp 
