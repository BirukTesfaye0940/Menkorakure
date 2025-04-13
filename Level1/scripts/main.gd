extends Area2D

# To control the position of the tiles
var tiles = []
var solved = []
var mouse = null
var tile_h=256
var tile=preload("res://Level1/scenes/tile.tscn")
var empty_tile_index = 15  # Index of the empty tile ($tile16 is at the last position by default)
var t
var offset= tile_h + 2
var previous= ""
var movecounter=0
@onready var timer_overlay = $overLayLayer/timerOverLay
# Called when the node enters the scene tree for the first time
func _ready():
	timer_overlay.visible = true
	# Position overlay (top-center example)
	timer_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	timer_overlay.z_index = 100
	timer_overlay.anchor_left = 1.0
	timer_overlay.offset_left = -150
	timer_overlay.anchor_top = 0.0
	timer_overlay.offset_top = 20
	
	start_game()
#
#
#
func _input(event):
	if event is InputEventMouseButton:
		# Convert mouse position to local coordinates
		var local_pos = get_global_transform().affine_inverse() * event.global_position
		# Check if click is within puzzle area (adjust numbers based on your puzzle size)
		if local_pos.x >= 0 and local_pos.x < 4*(tile_h+2) and local_pos.y >= 0 and local_pos.y < 4*(tile_h+2):
			mouse = event
#
#
#
func start_game():
	var image=Image.load_from_file("res://level1/newAssets/Lalibela.png")
	var texture=ImageTexture.create_from_image(image)
	var grayimage=Image.load_from_file("res://newAssets/empty.jpg")
	var graytexture=ImageTexture.create_from_image(grayimage)
	$FullImage.texture=texture
	$FullImage.hide()
	for j in range(0,4):
		for i in range(0,4):
			var imgregion=Rect2i(i*tile_h,j*tile_h,tile_h,tile_h)
			var newimage=image.get_region(imgregion)
			var newtexture=ImageTexture.create_from_image(newimage)
			
			var newtile=tile.instantiate()
			newtile.position.x=tile_h*i + tile_h/2 + i*2
			newtile.position.y=tile_h*j + tile_h/2 + j*2
			newtile.tilename="tile" + str(j*4 + i + 1)
			if newtile.tilename == "tile16":
				newtile.tiletexture=graytexture
			else:
				newtile.tiletexture=newtexture
			add_child(newtile)
			tiles.append(newtile)
	solved = tiles.duplicate()
	shuffle_tiles()


# Called every frame. Handles mouse input
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		mouse = false
		var rows = int(mouse_copy.position.y / offset)
		var cols = int(mouse_copy.position.x / offset)
		var pos = rows * 4 + cols
		check_neighbours(rows,cols)
		if tiles == solved:
			print("you win in " + str(movecounter) +" movements." )
			$FullImage.show()
			


func shuffle_tiles():
	t=0
	while t<30:
		var random_tile=randi() %16
		if tiles[random_tile].tilename !="tile16" and tiles[random_tile].tilename != previous:
			var rows=int(tiles[random_tile].position.y/offset)
			var cols=int(tiles[random_tile].position.x/offset)
			if check_neighbours(rows,cols):
				t +=1 
		
	movecounter=0
	empty_tile_index=15 
	previous=""
	
# checks if the tile we are clicking on is next to empty space only if this is true we can move the tile
func check_neighbours(rows,cols):
	var empty=false
	var done=false
	var pos=rows*4 + cols
	while !empty and !done:
		var new_pos=tiles[pos].position
		if rows<3:
			new_pos.y += offset
			empty=find_empty(new_pos,pos)
			new_pos.y -=offset
			
		if !empty and rows>0:
			new_pos.y -= offset
			empty=find_empty(new_pos,pos)
			new_pos.y +=offset
		if !empty and cols<3:
			new_pos.x += offset
			empty=find_empty(new_pos,pos)
			new_pos.x -=offset
		if !empty and cols>0:
			new_pos.x -= offset
			empty=find_empty(new_pos,pos)
			new_pos.x +=offset
		done= true
	return empty

func find_empty(position,pos):
	#checks the rows and columns of the tile we want to check
	var new_rows = int(position.y/offset)
	var new_cols = int(position.x/offset)
	var new_pos = new_rows*4 + new_cols
	if new_pos >=0 and new_pos < 16 and tiles[new_pos].tilename == "tile16" and tiles[new_pos].tilename != previous:
		swap_tiles(pos,new_pos)
		empty_tile_index = pos
		return true
	else:
		return false

# Swaps the position of two tiles
func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position =tiles[tile_dst].position
	tiles[tile_dst].position =temp_pos
	var temp_tile=tiles[tile_src]
	tiles[tile_src]=tiles[tile_dst]
	tiles[tile_dst]=temp_tile
	
	previous=tiles[tile_dst].tilename
	movecounter +=1

# Captures mouse input events
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		mouse = event
