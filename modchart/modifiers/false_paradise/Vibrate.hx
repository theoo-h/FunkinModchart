package modchart.modifiers.false_paradise;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Vibrate extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		curPos.x += (Math.random() - 0.5) * getPercent('vibrate', params.field) * 20;
		curPos.y += (Math.random() - 0.5) * getPercent('vibrate', params.field) * 20;

		return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('vibrate', params.field) != 0;
}