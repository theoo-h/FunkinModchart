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
		final scaleForce = getPercent('scaleForce', params.field);

		if (scaleForce != 0)
		{
			data.scaleX = scaleForce;
			data.scaleY = scaleForce;
			return data;
		}

		// normal scale
		data.scaleX *= getPercent('scaleX', params.field);
		data.scaleY *= getPercent('scaleY', params.field);

		// tiny
		data.scaleX *= Math.pow(0.5, getPercent('tinyX', params.field)) * Math.pow(0.5, getPercent('tiny', params.field));
		data.scaleY *= Math.pow(0.5, getPercent('tinyY', params.field)) * Math.pow(0.5, getPercent('tiny', params.field));

		data.scaleX *= getPercent('scale', params.field);
		data.scaleY *= getPercent('scale', params.field);

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}