package modchart.modifiers.false_paradise;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;
import modchart.core.util.ModchartUtil;

class CounterClockWise extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var strumTime = params.sPos + params.hDiff;
		var centerX = WIDTH * .5;
		var centerY = HEIGHT * .5;
		var radiusOffset = ARROW_SIZE * (params.receptor - 1.5);
		var radius = 200 + radiusOffset * cos(strumTime / Adapter.instance.getStaticCrochet() * .25 / 16 * PI);
		var outX = centerX + cos(strumTime / Adapter.instance.getStaticCrochet() / 4 * PI) * radius;
		var outY = centerY + sin(strumTime / Adapter.instance.getStaticCrochet() / 4 * PI) * radius;

		return ModchartUtil.lerpVector3D(curPos, new Vector3D(outX, outY, 0, 0), getPercent('counterClockWise', params.field));
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('counterclockwise', params.field) != 0;
}