package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Drunk extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var player = params.player;
		var speed = getPercent('drunkSpeed', player);
		var period = getPercent('drunkPeriod', player);
		var offset = getPercent('drunkOffset', player);

		var shift = params.songTime * 0.001 * (1 + speed) + params.lane * ((offset * 0.2) + 0.2) + params.distance * ((period * 10) + 10) / HEIGHT;
		var drunk = (cos(shift) * ARROW_SIZE * 0.5);

		curPos.x += drunk * (getPercent('drunk', player) + getPercent('drunkX', player));
		curPos.y += drunk * getPercent('drunkY', player);
		curPos.z += drunk * getPercent('drunkZ', player);

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
