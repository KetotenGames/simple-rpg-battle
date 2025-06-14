extends Node2D

class_name Character

# --- ステータス ---
var char_name: String = ""
var max_hp: int = 100
var hp: int = max_hp
var attack_power: int = 20
var defence: int = 5

# 防御フラグ
var is_defending: bool = false

# 防御アクション
func defend():
	is_defending = true

# ダメージ計算
func take_damage(amount: int) -> int:
	# Defend中ならダメージを半分にする
	if is_defending:
		amount = int(amount * 0.5)
		
	# ダメージ計算
	var dmg = max(amount - defence, 0)
	hp = max(hp - dmg, 0)
	
	# 防御効果をリセット
	is_defending = false;
	
	return dmg
	
# 攻撃アクション
func attack(target: Character) -> int:
	return target.take_damage(attack_power)
