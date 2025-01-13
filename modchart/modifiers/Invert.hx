package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import openfl.geom.Vector3D;

class Invert extends Modifier {
	override public function render(curPos:Vector3D, params:RenderParams) {
		final field = params.field;
		final invert = -(params.receptor % 2 - 0.5) / 0.5;
		final flip = (params.receptor - 1.5) * -2;
		final sine = sin(params.hDiff * Math.PI * (1 / 222));

		curPos.x += ARROW_SIZE * (invert * getPercent('invert', field) + invert * (getPercent('invertSine', field) * sine)
			+ flip * getPercent('flip', field) + flip * (getPercent('flipSine', field) * sine));

		return curPos;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
