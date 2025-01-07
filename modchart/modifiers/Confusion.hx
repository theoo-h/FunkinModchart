package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Confusion extends Modifier
{
	public function applyConfusion(vis:Visuals, params:RenderParams, axis:String, realAxis:String)
	{
		// x, y, z
		var string2 = Std.string(axis);

		var angle = 0.;
		// real confusion
		angle -= (params.fBeat * (getPercent('confusion' + string2, params.field) + getPercent('confusion' + string2 + Std.string(params.receptor), params.field))) % 360;
		// offset
		angle += getPercent('confusionOffset' + string2, params.field) + getPercent('confusionOffset' + string2 + Std.string(params.receptor), params.field);
		// other
		angle += getPercent('dizzy' + string2, params.field) * (params.hDiff * 0.1 * (1 + getPercent('dizzySpeed', params.field)));
		
		switch (realAxis.toLowerCase())
		{
			case 'x':
				vis.angleX += angle;
			case 'y':
				vis.angleY += angle;
			case 'z':
				vis.angleZ += angle;
		}
	}
	override public function visuals(data:Visuals, params:RenderParams)
	{
		applyConfusion(data, params, '', 'z');
		applyConfusion(data, params, 'x', 'x');
		applyConfusion(data, params, 'y', 'y');
		applyConfusion(data, params, 'z', 'z');

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}