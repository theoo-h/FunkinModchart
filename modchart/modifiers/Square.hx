package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Square extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final square = (angle:Float) -> {
			var fAngle = angle % (PI * 2);

			return fAngle >= PI ? -1.0 : 1.0;
		};

		final offset = getPercent("squareOffset", params.field);
		final period = getPercent("squarePeriod", params.field);
		final amp = (PI * (params.hDiff + offset) / (ARROW_SIZE + (period * ARROW_SIZE)));

		curPos.x += getPercent('square', params.field) * square(amp);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('square', params.field) != 0;
}