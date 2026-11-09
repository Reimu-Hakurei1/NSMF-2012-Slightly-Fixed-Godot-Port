extends Node2D

var frames := 0
var scene_path := "res://scenes/levels/room_level_1_1.tscn"
var out_path := "capture.png"
var cam_x := 400.0

func _ready() -> void:
    var args := OS.get_cmdline_user_args()
    if args.size() > 0:
        scene_path = args[0]
    if args.size() > 1:
        out_path = args[1]
    if args.size() > 2:
        cam_x = float(args[2])
    var inst = load(scene_path).instantiate()
    add_child(inst)
    var cam = inst.get_node("Camera2D")
    cam.position = Vector2(cam_x, 300)
    cam.make_current()

func _process(_d: float) -> void:
    frames += 1
    if frames < 4:
        return
    get_viewport().get_texture().get_image().save_png(out_path)
    get_tree().quit()
