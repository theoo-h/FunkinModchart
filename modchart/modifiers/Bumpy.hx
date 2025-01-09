package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Bumpy extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		var hDiff = params.hDiff;
		var bumpyX = (40 * sin((hDiff + (100.0 * getPercent('bumpyXOffset', field))) / ((getPercent('bumpyXPeriod', field) * 24.0) + 24.0)));
		var bumpyY = (40 * sin((hDiff + (100.0 * getPercent('bumpyYOffset', field))) / ((getPercent('bumpyYPeriod', field) * 24.0) + 24.0)));
		var bumpyZ = (40 * sin((hDiff + (100.0 * getPercent('bumpyZOffset', field))) / ((getPercent('bumpyZPeriod', field) * 24.0) + 24.0)));

		curPos.x += bumpyX * getPercent('bumpyX', field);
		curPos.y += bumpyY * getPercent('bumpyY', field);
		curPos.z += bumpyZ * (getPercent('bumpy', field) + getPercent('bumpyZ', field));

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
