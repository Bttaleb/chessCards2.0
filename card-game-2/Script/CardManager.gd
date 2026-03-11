extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1
const DEFAULT_CARD_SCALE = 0.8
const CARD_BIGGER_SCALE = 0.85


var screen_size
var card_being_dragged
var is_hovering_on_card
var player_hand_reference
var isFlip
var original_card

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
		clamp(mouse_pos.y, 0, screen_size.y))
		
func animate_card_to_position_with_queue_free(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	tween.tween_callback(card.queue_free)

	
func start_drag(card):
	original_card = card
	var clone = create_card_clone(card)
	clone.position = card.position
	clone.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
	clone.z_index = 2
	add_child(clone)
	card_being_dragged = clone
	
func finish_drag():
	card_being_dragged.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
		player_hand_reference.remove_card_from_hand(original_card)
	else:
		animate_card_to_position_with_queue_free(card_being_dragged, original_card.position, DEFAULT_CARD_MOVE_SPEED)
	original_card = null
	card_being_dragged = null

func create_card_clone(original):
	var clone = preload("res://Scenes/Card.tscn").instantiate()
	clone.card_name = original.card_name
	clone.get_node("CardImage").texture = original.get_node("CardImage").texture
	clone.get_node("CardBackImage").visible = false
	clone.get_node("Attack").text = original.get_node("Attack").text
	clone.get_node("Health").text = original.get_node("Health").text
	clone.get_node("Count").visible = false
	return clone
	

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
	
func on_left_click_released():
	if card_being_dragged:
		finish_drag()
 
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_on_hovered = raycast_check_for_card()
		if new_card_on_hovered:
			highlight_card(new_card_on_hovered, true)
		else:
			is_hovering_on_card = false
	
func highlight_card(card, hovered):
	if !hovered:
		card.scale = Vector2(DEFAULT_CARD_SCALE, DEFAULT_CARD_SCALE)
		card.z_index = 1
	else:
		card.scale = Vector2(CARD_BIGGER_SCALE, CARD_BIGGER_SCALE)
		card.z_index = 2

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null
	
func get_card_with_highest_z_index(cards):
	#Assume the first card in cards array has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	#loop through rest of the cards checking for a higher z index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
