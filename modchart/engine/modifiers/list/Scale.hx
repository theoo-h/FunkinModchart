package modchart.engine.modifiers.list;

import modchart.backend.core.ArrowData;
import modchart.backend.core.ModifierParameters;
import modchart.backend.core.VisualParameters;

class Scale extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('scale', 1, -1);
		setPercent('scaleX', 1, -1);
		setPercent('scaleY', 1, -1);
	}

	private inline function applyScale(vis:VisualParameters, params:ModifierParameters, axis:String, realAxis:String) {
		var receptorName = Std.string(params.lane);
		var player = params.player;

		var scale = 1.;
		// Scale
		scale *= getPercent('scale' + axis, player) + getPercent('scale' + axis + receptorName, player);

		switch (realAxis) {
			case 'x':
				vis.scaleX *= scale;
			case 'y':
				vis.scaleY *= scale;
			default:
				vis.scaleX *= scale;
				vis.scaleY *= scale;
		}
	}

	override public function visuals(data:VisualParameters, params:ModifierParameters) {
		var player = params.player;
		var receptorName = Std.string(params.lane);

		applyScale(data, params, '', '');
		applyScale(data, params, 'x', 'x');
		applyScale(data, params, 'y', 'y');

		var tinyAmount = getPercent('tiny', player) + getPercent('tiny' + receptorName, player);

		// NotITG Scale (aka Tiny)
		if (tinyAmount != 0)
			tinyAmount = Math.pow(0.5, tinyAmount);

		data.scaleX *= 1 + tinyAmount;
		data.scaleY *= 1 + tinyAmount;

		return data;
	}

	override public function shouldRun(params:ModifierParameters):Bool
		return true;
}
