package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Tipsy extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var field = params.field;
		var speed = getPercent('tipsySpeed', field);
		var offset = getPercent('tipsyOffset', field);

		var tipsy = (cos((params.sPos * 0.001 * ((speed * 1.2) + 1.2) + params.receptor * ((offset * 1.8) + 1.8))) * ARROW_SIZE * .4);

		var tipAddition = new Vector3D(
			getPercent('tipsyX', field),
			getPercent('tipsyY', field) + getPercent('tipsy', field),
			getPercent('tipsyZ', field)
		);
		tipAddition.scaleBy(tipsy);

        return curPos.add(tipAddition);
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}