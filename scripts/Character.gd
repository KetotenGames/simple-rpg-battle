extends Node2D

class_name Character

# --- ステータス ---
var char_name: String = ""
var max_hp: int = 100
var hp: int = max_hp
var attack_power: int = 20
var defence: int = 5

# ダメージ計算
func take_damage(amount: int) -> int:
	var dmg = max(amount - defence, 0)
	hp = max(hp - dmg, 0)
	return dmg
	
# 攻撃アクション
func attack(target: Character) -> int:
	return target.take_damage(attack_power)
