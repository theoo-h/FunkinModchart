package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Confusion extends Modifier {
	static final dNames = ['x' => 'roll', 'y' => 'twirl', 'z' => 'dizzy'];

	public function applyConfusion(vis:Visuals, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.lane);
		final player = params.player;

		var angle = 0.;
		// real confusion
		angle -= (params.curBeat * (getPercent('confusion' + axis, player) + getPercent('confusion' + axis + receptorName, player))) % 360;
		// offset
		angle += getPercent('confusionOffset' + axis, player) + getPercent('confusionOffset' + axis + receptorName, player);
		// dizzy mods
		final cName = dNames.get(realAxis);
		angle += getPercent(cName, player) * (params.distance * 0.1 * (1 + getPercent('${cName}Speed', player)));

		switch (realAxis) {
			case 'x':
				vis.angleX += angle;
			case 'y':
				vis.angleY += angle;
			case 'z':
				vis.angleZ += angle;
		}
	}

	override public function visuals(data:Visuals, params:RenderParams) {
		applyConfusion(data, params, '', 'z');
		applyConfusion(data, params, 'x', 'x');
		applyConfusion(data, params, 'y', 'y');
		applyConfusion(data, params, 'z', 'z');

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
