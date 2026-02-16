extends Node2D

const COLLISION_MASK_CARD = 1

var screenSize
var cardBeingDragged
var isHoveringOnCard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size # Replace with function body.


func _process(delta: float) -> void: 
	if cardBeingDragged:
		var mousePos = get_global_mouse_position()
		cardBeingDragged.position = Vector2(clamp(mousePos.x, 0, screenSize.x), clamp(mousePos.y, 0, screenSize.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				cardBeingDragged = card
		else:
			cardBeingDragged = null
			
func connectCardSignals(card):
	card.connect("hovered", onHoveredOverCard)
	card.connect("hoveredOff", onHoveredOffCard)

func onHoveredOverCard(card):
	if !isHoveringOnCard:
		isHoveringOnCard = true
		highlightCard(card, true)

func onHoveredOffCard(card):
	isHoveringOnCard = false
	highlightCard(card, false)
	#Check if hovered off card straight onto another card
	var newCardHovered = raycast_check_for_card()
	if newCardHovered:
		highlightCard(card, true)
	else:
		isHoveringOnCard = false


func highlightCard(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
		
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return getCardWithHighestZIndex(result)
	return null
	
func getCardWithHighestZIndex(cards):
	# Assume first card in cards array has highest z index
	var highestZCard = cards[0].collider.get_parent()
	var highestZIndex = highestZCard.z_index
	
	# Loop through rest of cards checking for higher z index
	for i in range(1, cards.size()):
		var currentCard = cards[i].collider.get_parent()
		if currentCard.z_index > highestZIndex:
			highestZCard = currentCard
			highestZIndex = currentCard.z_index
	return highestZCard
