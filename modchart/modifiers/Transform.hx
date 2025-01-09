package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Transform extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var receptorName = Std.string(params.receptor);
		var field = params.field;
		curPos.x += getPercent('x', field) + getPercent('x' + receptorName, field) + getPercent('xoffset', field) + getPercent('xoffset' + receptorName, field);
		curPos.y += getPercent('y', field) + getPercent('y' + receptorName, field) + getPercent('yoffset', field) + getPercent('yoffset' + receptorName, field);
		curPos.z += getPercent('z', field) + getPercent('z' + receptorName, field) + getPercent('zoffset', field) + getPercent('zoffset' + receptorName, field);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
