package modchart.modifiers.false_paradise;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Wiggle extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		curPos.x += sin(params.fBeat) * getPercent('wiggle', params.field) * 20;
		curPos.y += sin(params.fBeat + 1) * getPercent('wiggle', params.field) * 20;

		setPercent('rotateZ', (sin(params.fBeat) * 0.2 * getPercent('wiggle', params.field)) * 180 / Math.PI);

		return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return getPercent('wiggle', params.field) != 0;
}