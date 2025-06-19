extends Control

@onready var battle_manager = get_node("/root/BattleScene/BattleManager")
@onready var player_hp_label = $VBoxContainer/HBoxContainer/PlayerHPVBox/PlayerHPLabel
@onready var player_hp_bar = $VBoxContainer/HBoxContainer/PlayerHPVBox/PlayerHPBar

@onready var enemy_hp_label = $VBoxContainer/HBoxContainer/EnemyVBox/EnemyHPLabel
@onready var enemy_hp_bar = $VBoxContainer/HBoxContainer/EnemyVBox/EnemyHPBar

@onready var btn_attack = $VBoxContainer/HBoxContainer2/AttackButton
@onready var btn_defend = $VBoxContainer/HBoxContainer2/DefendButton


func _ready() -> void:
	# BattleManagerのシグナル接続
	battle_manager.connect("player_turn_started", Callable(self, "_on_player_turn_started"))
	
	# ボタンのpressed()シグナルを接続
	btn_attack.pressed.connect(on_attack_button_pressed)
	btn_defend.pressed.connect(on_defend_button_pressed)
	
	# 初期ラベル更新 & ボタン有効化
	update_labels()
	
# プレイヤーターン開始時にボタンを有効化
func _on_player_turn_started():
	set_action_buttons_enabled(true)
	
func set_action_buttons_enabled(enabled: bool):
	btn_attack.disabled = not enabled
	btn_defend.disabled = not enabled
	
func on_attack_button_pressed():
	print("▶ Attack ボタンが押されました")  # デバッグ用
	set_action_buttons_enabled(false)
	await battle_manager.on_player_action("attack")

func on_defend_button_pressed():
	print("▶ Defend ボタンが押されました")  # デバッグ用
	set_action_buttons_enabled(false)
	await battle_manager.on_player_action("defend")
	
func update_player_hp():
	player_hp_label.text = "HP: %d" % battle_manager.player.hp
	player_hp_bar.value = battle_manager.player.hp
	
func update_enemy_hp():
	enemy_hp_label.text  = "HP: %d" % battle_manager.enemy.hp 
	enemy_hp_bar.value = battle_manager.enemy.hp
	
func update_labels():
	update_player_hp()
	update_enemy_hp()
