package modchart.modifiers;

import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Confusion extends Modifier {
	static final dNames = ['x' => 'roll', 'y' => 'twirl', 'z' => 'dizzy'];

	public function applyConfusion(vis:Visuals, params:RenderParams, axis:String, realAxis:String) {
		final receptorName = Std.string(params.receptor);
		final field = params.field;

		var angle = 0.;
		// real confusion
		angle -= (params.fBeat * (getPercent('confusion' + axis, field) + getPercent('confusion' + axis + receptorName, field))) % 360;
		// offset
		angle += getPercent('confusionOffset' + axis, field) + getPercent('confusionOffset' + axis + receptorName, field);
		// dizzy mods
		final cName = dNames.get(realAxis);
		angle += getPercent(cName, field) * (params.hDiff * 0.1 * (1 + getPercent('${cName}Speed', field)));

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
