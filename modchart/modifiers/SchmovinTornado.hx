package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class SchmovinTornado extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final columnShift = params.receptor * Math.PI / 3;
		final strumNegator = (-cos(-columnShift) + 1) / 2 * ARROW_SIZE * 3;
		curPos.x += ((-cos((params.hDiff / 135) - columnShift) + 1) / 2 * ARROW_SIZE * 3 - strumNegator) * getPercent('schmovinTornado', params.field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}