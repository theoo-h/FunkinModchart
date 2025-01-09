package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Scale extends Modifier
{
	public function new(pf)
	{
		super(pf);

		setPercent('scale', 1, -1);
		setPercent('scaleX', 1, -1);
		setPercent('scaleY', 1, -1);
	}
	override public function visuals(data:Visuals, params:RenderParams)
	{
		var field = params.field;
		final scaleForce = getPercent('scaleForce', field);

		if (scaleForce != 0)
		{
			data.scaleX = scaleForce;
			data.scaleY = scaleForce;
			return data;
		}

		// normal scale
		data.scaleX *= getPercent('scaleX', field);
		data.scaleY *= getPercent('scaleY', field);

		// tiny

		var tinyPow = Math.pow(0.5, getPercent('tinyPow', field));
		data.scaleX *= Math.pow(0.5, getPercent('tinyX', field)) * tinyPow;
		data.scaleY *= Math.pow(0.5, getPercent('tinyY', field)) * tinyPow;

		var scale = getPercent('scale', field);
		data.scaleX *= scale;
		data.scaleY *= scale;

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}