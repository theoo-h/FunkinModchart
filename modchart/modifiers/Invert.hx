package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Invert extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		final player = params.player;
		final invert = -(params.lane % 2 - 0.5) / 0.5;
		final flip = (params.lane - 1.5) * -2;
		final sine = sin(params.distance * Math.PI * (1 / 222));

		curPos.x += ARROW_SIZE * (invert * getPercent('invert', player) + invert * (getPercent('invertSine', player) * sine)
			+ flip * getPercent('flip', player) + flip * (getPercent('flipSine', player) * sine));

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
