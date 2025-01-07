package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Tipsy extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var speed = getPercent('tipsySpeed', params.field);
		var offset = getPercent('tipsyOffset', params.field);

		var tipsy = (cos((params.sPos * 0.001 * ((speed * 1.2) + 1.2) + params.receptor * ((offset * 1.8) + 1.8))) * ARROW_SIZE * .4);

		var tipAddition = new Vector3D(
			getPercent('tipsyX', params.field),
			getPercent('tipsyY', params.field) + getPercent('tipsy', params.field),
			getPercent('tipsyZ', params.field)
		);
		tipAddition.scaleBy(tipsy);

        return curPos.add(tipAddition);
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}