package modchart.engine.modifiers.list;

import flixel.FlxG;
import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;
import modchart.backend.util.ModchartUtil;

class Rotate extends Modifier {
	override public function render(curPos:Vector3, params:RenderParams) {
		var rotateName = getRotateName();
		var player = params.player;

		var angleX = getPercent(rotateName + 'X', player);
		var angleY = getPercent(rotateName + 'Y', player);
		var angleZ = getPercent(rotateName + 'Z', player);

		// does angleY work here if angleX and angleZ are disabled? - ye
		if (angleX == 0 && angleY == 0 && angleZ == 0)
			return curPos;

		final origin:Vector3 = getOrigin(curPos, params);
		final diff = curPos.subtract(origin);
		final out = ModchartUtil.rotate3DVector(diff, angleX, angleY, angleZ);
		curPos.copyFrom(origin.add(out));
		return curPos;
	}

	public function getOrigin(curPos:Vector3, params:RenderParams):Vector3 {
		var fixedLane = Math.round(getKeyCount(params.player) * .5);
		return new Vector3(getReceptorX(fixedLane, params.player), FlxG.height / 2);
	}

	public function getRotateName():String
		return 'rotate';

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
