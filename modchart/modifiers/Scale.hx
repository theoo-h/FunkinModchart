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
		var receptorName = Std.string(params.receptor);
		var field = params.field;

		var scale = 1.;
		var tinyPow = Math.pow(0.5, getPercent('tinyPow', field)); //does not need "lane" variant

		//Scale
		scale *= getPercent('scale' + axis, field) + getPercent('scale' + axis + receptorName, field);

		//NotITG Scale (aka Tiny)
		scale *= Math.pow(0.5, getPercent('tiny' + axis, field) + getPercent('tiny' + axis + receptorName, field)) * tinyPow;

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

		var field = params.field;
		var receptorName = Std.string(params.receptor);
		final scaleForce = getPercent('scaleForce' + receptorName, field) + getPercent('scaleForce' + receptorName, field);

		if (scaleForce != 0) {
			data.scaleX = scaleForce;
			data.scaleY = scaleForce;
			return data;
		}

		applyScale(data,params,'','');
		applyScale(data,params,'x','x');
		applyScale(data,params,'y','y');

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}
