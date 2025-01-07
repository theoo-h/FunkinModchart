package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import modchart.core.util.Constants.Visuals;
import openfl.geom.Vector3D;

class Mini extends Modifier
{
	override public function visuals(data:Visuals, params:RenderParams)
	{
		data.zoom -= (0.5 * getPercent('mini', params.field));

		return data;
	}

	override public function shouldRun(params:RenderParams):Bool
		return true;
}