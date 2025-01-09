package modchart.modifiers.false_paradise;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;
import modchart.core.util.ModchartUtil;

class Spiral extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var field = params.field;
		var PI = Math.PI;
		var centerX = WIDTH * .5;
		var centerY = HEIGHT * .5;
		var radiusOffset = -params.hDiff * .25;
		var crochet = Adapter.instance.getStaticCrochet();
		var radius = radiusOffset + getPercent('spiralDist', field) * params.receptor;
		var outX = centerX + cos(-params.hDiff / crochet * PI + params.fBeat * (PI * .25)) * radius;
		var outY = centerY + sin(-params.hDiff / crochet * PI - params.fBeat * (PI * .25)) * radius;

		return ModchartUtil.lerpVector3D(curPos, new Vector3D(outX, outY, radius / (centerY * 4) - 1, 0), getPercent('spiral', field));
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('spiral', params.field) != 0;
}