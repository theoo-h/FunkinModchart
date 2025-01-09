package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class SchmovinTornado extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final tord = getPercent('schmovinTornado', params.field);

		if (tord == 0)
			return curPos;
		final columnShift = params.receptor * Math.PI / 3;
		final strumNegator = (-cos(-columnShift) + 1) / 2 * ARROW_SIZE * 3;
		curPos.x += ((-cos((params.hDiff / 135) - columnShift) + 1) / 2 * ARROW_SIZE * 3 - strumNegator) * tord;

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}