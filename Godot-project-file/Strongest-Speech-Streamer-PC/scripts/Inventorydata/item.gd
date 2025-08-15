extends Resource
class_name ItemData

# 物品属性
@export var item_name: String # 物品名称
@export var stackable: bool # 是否堆叠
@export var item_texture: AtlasTexture # 纹理
@export_multiline var description: String # 物品描述
@export_range(1, 99) var item_max_amount: int # 物品最大数量
@export var group_name: String # 物品分类
@export var energy_value: int # 物品回复体力值
@export var exp_buff_value: float # 经验加成buff
@export var gold_buff_value: float # 金币加成buff
@export var buff_round: int # buff持续回合数
@export var equipment_type: EquipType# 装备类型
enum EquipType { None, Head, Clothes, Pants, Shoes, Car }

@export var equipment_value: int #衣服序号,0代表不是衣服
@export var price: int # 物品价格
@export var is_commodity: bool # 是否是商品

@export var layer: int # 用于家具可以摆放在第几层
@export var source_id: int # 用于壁纸和地板的ID

@export var interactive_type: String # 1.sleep 2.game 3.book
