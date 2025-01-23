package modchart.modifiers;

import flixel.FlxG;
import flixel.math.FlxMath;
import modchart.Manager;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

// Default modifier
// Handles scroll speed, scroll angle and reverse modifiers
class Reverse extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('xmod', 1, -1);
	}

	public function getReverseValue(dir:Int, player:Int) {
		var kNum = getKeyCount();
		var val:Float = 0;
		if (dir >= Math.floor(kNum * 0.5))
			val += getPercent("split", player);

		if ((dir % 2) == 1)
			val += getPercent("alternate", player);

		var first = kNum * 0.25;
		var last = kNum - 1 - first;

		if (dir >= first && dir <= last)
			val += getPercent("cross", player);

		val += getPercent('reverse', player) + getPercent("reverse" + Std.string(dir), player);

		if (getPercent("unboundedReverse", player) == 0) {
			val %= 2;
			if (val > 1)
				val = 2 - val;
		}

		// downscroll
		if (Adapter.instance.getDownscroll())
			val = 1 - val;
		return val;
	}

	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		var initialY = Adapter.instance.getDefaultReceptorY(params.receptor, field) + ARROW_SIZEDIV2;
		var reversePerc = getReverseValue(params.receptor, field);
		var shift = FlxMath.lerp(initialY, HEIGHT - initialY, reversePerc);

		var centerPercent = getPercent('centered', params.field);
		shift = FlxMath.lerp(shift, (HEIGHT * 0.5) - ARROW_SIZEDIV2, centerPercent);

		// TODO: long, straight and short holds
		var distance = params.hDiff;

		distance *= 0.45 * Adapter.instance.getCurrentScrollSpeed();

		var scroll = new Vector3D(0, FlxMath.lerp(distance, -distance, reversePerc));
		scroll = applyScrollMods(scroll, params);

		curPos.x += scroll.x;
		curPos.y = shift + scroll.y;
		curPos.z += scroll.z;

		return curPos;
	}

	function applyScrollMods(scroll:Vector3D, params:RenderParams) {
		var field = params.field;
		var angleX = 0.;
		var angleY = 0.;
		var angleZ = 0.;

		// Speed
		scroll.y = scroll.y * (getPercent('xmod', field))
			+ (1 + getPercent('scrollSpeed', field) + getPercent('scrollSpeed' + Std.string(params.receptor), field));

		// Main
		angleX += getPercent('scrollAngleX', field);
		angleY += getPercent('scrollAngleY', field);
		angleZ += getPercent('scrollAngleZ', field);

		// Curved
		final shift:Float = params.hDiff * 0.25 * (1 + getPercent('curvedScrollPeriod', field));

		angleX += shift * getPercent('curvedScrollX', field);
		angleY += shift * getPercent('curvedScrollY', field);
		angleZ += shift * getPercent('curvedScrollZ', field);

		// angleY doesnt do anything if angleX and angleZ are disabled
		if (angleX == 0 && angleZ == 0)
			return scroll;

		scroll = ModchartUtil.rotate3DVector(scroll, angleX, angleY, angleZ);

		return scroll;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
