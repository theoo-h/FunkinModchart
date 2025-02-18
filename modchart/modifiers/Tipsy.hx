package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Tipsy extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		var player = params.player;
		var speed = getPercent('tipsySpeed', player);
		var offset = getPercent('tipsyOffset', player);

		var tipsy = (cos((params.songTime * 0.001 * ((speed * 1.2) + 1.2) + params.lane * ((offset * 1.8) + 1.8))) * ARROW_SIZE * .4);

		var tipAddition = new Vector3D(getPercent('tipsyX', player), getPercent('tipsyY', player) + getPercent('tipsy', player), getPercent('tipsyZ', player));
		tipAddition.scaleBy(tipsy);

		return curPos.add(tipAddition);
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
