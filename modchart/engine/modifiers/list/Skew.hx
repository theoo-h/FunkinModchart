package modchart.engine.modifiers.list;

import modchart.backend.util.Constants.ArrowData;
import modchart.backend.util.Constants.RenderParams;
import modchart.backend.util.Constants.Visuals;
import modchart.backend.util.ModchartUtil;

class Skew extends Modifier {
	override public function visuals(data:Visuals, params:RenderParams):Visuals {
		var receptorName = Std.string(params.lane);
		var player = params.player;
		final x = getPercent('skewX', player) + getPercent('skewX' + receptorName, player);
		final y = getPercent('skewY', player) + getPercent('skewY' + receptorName, player);

		data.skewX += x;
		data.skewY += y;

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
