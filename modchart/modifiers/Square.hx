package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Square extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		final squarep = getPercent('square', params.field);

		if (squarep == 0)
			return curPos;

		final square = (angle:Float) -> {
			var fAngle = angle % (Math.PI * 2);

			return fAngle >= Math.PI ? -1.0 : 1.0;
		};

		final offset = getPercent("squareOffset", params.field);
		final period = getPercent("squarePeriod", params.field);
		final amp = (Math.PI * (params.hDiff + offset) / (ARROW_SIZE + (period * ARROW_SIZE)));

		curPos.x += squarep * square(amp);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}