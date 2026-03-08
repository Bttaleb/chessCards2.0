extends Node2D

const CARD_WIDTH = 300
const HAND_Y_POSITION = 890
const DEFAULT_CARD_MOVE_SPEED = 0.1
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var card_database_reference
var player_hand = { 
	#dictionary mapping for 1 node per key
	"Pawn": 8,
	"Knight": 2,
	"Bishop": 2,
	"Rook": 2,
	"Queen": 1,
	"King": 1 } 
var card_nodes = {}
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_database_reference = preload("res://Script/CardDatabase.gd")
	center_screen_x = get_viewport().size.x / 2
	setup_hand()
			
	
func setup_hand():
	var card_scene = preload(CARD_SCENE_PATH)
	
	for card_name in player_hand:
		var new_card = card_scene.instantiate()
		new_card.card_name = card_name
		var card_image_path = str("res://Assets/wholecards/" + card_name + "Card.png")
		new_card.get_node("CardImage").texture = load(card_image_path)
		new_card.get_node("CardBackImage").visible = false
		new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_name][0])
		new_card.get_node("Health").text = str(card_database_reference.CARDS[card_name][1])
		new_card.get_node("Count").text = str(player_hand[card_name])
		$"../CardManager".add_child(new_card)
		card_nodes[card_name] = new_card
		new_card.name = "Card" 
		add_card_to_hand(new_card, 0)

func add_card_to_hand(card, speed):
	# Check if card is in hard or not
	if card not in player_hand:
		player_hand[card.card_name] += 1
		update_hand_positions(speed)
		# Snap card back to hand if it isnt
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)
		
func update_hand_positions(speed):
	var count = 0
	for i in card_nodes:
		# Get new card position based on index
		var new_position = Vector2(calculate_card_position(count), HAND_Y_POSITION)
		var card = card_nodes[i]
		card.hand_position = new_position
		count += 1
		animate_card_to_position(card, new_position, speed)
	
func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
		
func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func _process(delta: float) -> void:
	pass

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand[card] -= 1
		update_count(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)

# TODO(human): Implement update_count
# This function receives a card_name (String, e.g. "Pawn")
# It should:
#   1. Update the Count text on the card node to reflect player_hand[card_name]
#   2. If the count is 0, tint the card to look "depleted" (modulate with reduced alpha)
#   3. If the count is > 0, ensure the card looks normal (full modulate)
# Hints:
#   - card_nodes[card_name] gets you the Card node
#   - .get_node("Count").text sets the label
#   - .modulate = Color(r, g, b, a) controls tinting
func update_count(card_name: String):
	pass
