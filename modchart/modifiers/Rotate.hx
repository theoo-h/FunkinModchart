package modchart.modifiers;

import flixel.FlxG;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Rotate extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var rotateName = getRotateName();
		var field = params.field;
		var angleX = getPercent(rotateName + 'X', field);
		if (angleX == 0)
			return curPos;
		var angleY = getPercent(rotateName + 'Y', field);
		if (angleY == 0)
			return curPos;
		var angleZ = getPercent(rotateName + 'Z', field);
		if (angleZ == 0)
			return curPos;

		// if ((angleX + angleY + angleZ) == 0)
		//	return curPos;

		final origin:Vector3D = getOrigin(curPos, params);
		final diff = curPos.subtract(origin);
		final out = ModchartUtil.rotate3DVector(diff, angleX, angleY, angleZ);
		curPos.copyFrom(origin.add(out));
		return curPos;
	}

	public function getOrigin(curPos:Vector3D, params:RenderParams):Vector3D {
		return new Vector3D(40 + WIDTH / 2 * params.field + 2 * ARROW_SIZE + ARROW_SIZEDIV2, HEIGHT * 0.5);
	}

	public function getRotateName():String
		return 'rotate';

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
