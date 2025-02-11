package modchart.modifiers;

import flixel.FlxG;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Rotate extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var rotateName = getRotateName();
		var player = params.player;

		var angleX = getPercent(rotateName + 'X', player);
		var angleY = getPercent(rotateName + 'Y', player);
		var angleZ = getPercent(rotateName + 'Z', player);

		// does angleY work here if angleX and angleZ are disabled? - ye
		if (angleX == 0 && angleY == 0 && angleZ == 0)
			return curPos;

		final origin:Vector3D = getOrigin(curPos, params);
		final diff = curPos.subtract(origin);
		final out = ModchartUtil.rotate3DVector(diff, angleX, angleY, angleZ);
		curPos.copyFrom(origin.add(out));
		return curPos;
	}

	public function getOrigin(curPos:Vector3D, params:RenderParams):Vector3D {
		return new Vector3D(40 + WIDTH / 2 * params.player + 2 * ARROW_SIZE + ARROW_SIZEDIV2, HEIGHT * 0.5);
	}

	public function getRotateName():String
		return 'rotate';

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
