package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Scale extends Modifier {
	public function new(pf) {
		super(pf);

		setPercent('scale', 1, -1);
		setPercent('scaleX', 1, -1);
		setPercent('scaleY', 1, -1);
	}

	public function applyScale(vis:Visuals, params:RenderParams, axis:String, realAxis:String) {
		var receptorName = Std.string(params.lane);
		var player = params.player;

		var scale = 1.;
		var tinyPow = Math.pow(0.5, getPercent('tinyPow', player)); // does not need "lane" variant

		// Scale
		scale *= getPercent('scale' + axis, player) + getPercent('scale' + axis + receptorName, player);

		// NotITG Scale (aka Tiny)
		scale *= Math.pow(0.5, getPercent('tiny' + axis, player) + getPercent('tiny' + axis + receptorName, player)) * tinyPow;

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

	override public function visuals(data:Visuals, params:RenderParams) {
		var player = params.player;
		var receptorName = Std.string(params.lane);
		final scaleForce = getPercent('scaleForce' + receptorName, player) + getPercent('scaleForce' + receptorName, player);

		if (scaleForce != 0) {
			data.scaleX = scaleForce;
			data.scaleY = scaleForce;
			return data;
		}

		applyScale(data, params, '', '');
		applyScale(data, params, 'x', 'x');
		applyScale(data, params, 'y', 'y');

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
