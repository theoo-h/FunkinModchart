package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Invert extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final invert = -(params.receptor % 2 - 0.5) / 0.5;
		final flip = (params.receptor - 1.5) * -2;
		final sine = sin(params.hDiff * PI * (1 / 222));

		curPos.x += ARROW_SIZE * (
			invert * getPercent('invert', params.field) + invert * (getPercent('invertSine', params.field) * sine) + 
			flip * getPercent('flip', params.field) + flip * (getPercent('flipSine', params.field) * sine)
		);

        return curPos;
    }

	override public function shouldRun(params:RenderParams):Bool
		return true;
}