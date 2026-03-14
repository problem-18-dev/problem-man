extends Node


enum States { Chase, Scatter, Frightened, Eaten }
enum Ghosts { Ignorant, Chaser, Ambusher, Fickle }
enum Corner { TopLeft, TopRight, BottomLeft, BottomRight }
enum JailCell { Left, Center, Right, Out }

var ghost_corners: Dictionary = {
	Corner.TopLeft: Vector2(1, 1),
	Corner.TopRight: Vector2(26, 1),
	Corner.BottomLeft: Vector2(1, 27),
	Corner.BottomRight: Vector2(26, 27),
}

var ghost_jail_positions: Dictionary = {
	JailCell.Left: Vector2(184, 216), 
	JailCell.Center: Vector2(224, 216),
	JailCell.Right: Vector2(264, 216),
	JailCell.Out: Vector2(224, 184),
}
