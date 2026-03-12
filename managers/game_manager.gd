extends Node


enum Ghosts { Ignorant, Chaser, Ambusher, Fickle }
enum Corner { TopLeft, TopRight, BottomLeft, BottomRight }
enum JailCell { Left, Center, Right, Out }

var ghost_corners: Dictionary = {
	Corner.TopLeft: Vector2(1, 1),
	Corner.TopRight: Vector2(26, 1),
	Corner.BottomLeft: Vector2(1, 28),
	Corner.BottomRight: Vector2(26, 28),
}

var ghost_jail_positions: Dictionary = {
	JailCell.Left: Vector2(184, 232), 
	JailCell.Center: Vector2(224, 216),
	JailCell.Right: Vector2(264, 232),
	JailCell.Out: Vector2(224, 184),
}
