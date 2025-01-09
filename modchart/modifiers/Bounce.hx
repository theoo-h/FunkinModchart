package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Bounce extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var field = params.field;
		var speed = getPercent('bounceSpeed', field);
		var offset = getPercent('bounceOffset', field);

		var bounce = Math.abs(sin((params.fBeat + offset) * (1 + speed) * Math.PI)) * ARROW_SIZE;

		curPos.x += bounce * getPercent('bounceX', field);
		curPos.y += bounce * (getPercent('bounce', field) + getPercent('bounceY', field));
		curPos.z += bounce * getPercent('bounceZ', field);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
