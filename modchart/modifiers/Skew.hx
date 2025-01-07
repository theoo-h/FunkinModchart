package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Skew extends Modifier
{
	override public function visuals(data:Visuals, params:RenderParams):Visuals
	{
		final x = getPercent('skewX', params.field) + getPercent('skewX' + Std.string(params.receptor), params.field);
		final y = getPercent('skewY', params.field) + getPercent('skewY' + Std.string(params.receptor), params.field);
		
        data.skewX += x;
        data.skewY += y;

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}