package modchart.core.util;

class Constants {
	public static var MODIFIER_LIST:Map<String, Class<Modifier>>;
}

@:structInit
class RenderParams {
	public var sPos:Float;
	public var time:Float;
	public var fBeat:Float;
	public var hDiff:Float;
	public var receptor:Int;
	public var field:Int;
	public var arrow:Bool;

	// for hold mods
	public var __holdParentTime:Float = 0;
	public var __holdLength:Float = 0;
	public var __holdOffset:Float = 0;
}

@:structInit
class ArrowData {
	public var time:Float;
	public var hDiff:Float;
	public var receptor:Int;
	public var field:Int;
	public var arrow:Bool;

	// for hold mods
	public var __holdParentTime:Float = 0;
	public var __holdLength:Float = 0;
	public var __holdOffset:Float = 0;
}

@:structInit
class Visuals {
	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var alpha:Float = 1;
	public var zoom:Float = 0;
	public var glow:Float = 0;
	public var glowR:Float = 1;
	public var glowG:Float = 1;
	public var glowB:Float = 1;
	public var angleX:Float = 0;
	public var angleY:Float = 0;
	public var angleZ:Float = 0;
	public var skewX:Float = 0;
	public var skewY:Float = 0;
}

@:publicFields
@:structInit
class Node {
	public var input:Array<String> = [];
	public var output:Array<String> = [];
	public var func:NodeFunction = (_, o) -> _;
}

// (InputModPercents, PlayerNumber) -> OutputModPercents
typedef NodeFunction = (Array<Float>, Int) -> Array<Float>;

class SimplePoint {
	public var x:Float;
	public var y:Float;

	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}
}
