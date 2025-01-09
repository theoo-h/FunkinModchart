package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import modchart.core.util.ModchartUtil;
import openfl.geom.Vector3D;

class Skew extends Modifier {
	override public function visuals(data:Visuals, params:RenderParams):Visuals {
		var receptorName = Std.string(params.receptor);
		var field = params.field;
		final x = getPercent('skewX', field) + getPercent('skewX' + receptorName, field);
		final y = getPercent('skewY', field) + getPercent('skewY' + receptorName, field);

		data.skewX += x;
		data.skewY += y;

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
