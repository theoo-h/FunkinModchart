package modchart.modifiers;

import modchart.core.util.Constants.RenderParams;
import modchart.core.util.Constants.ArrowData;
import openfl.geom.Vector3D;

class Bounce extends Modifier
{
    override public function render(curPos:Vector3D, params:RenderParams)
    {
		var speed = getPercent('bounceSpeed', params.field);
		var offset = getPercent('bounceOffset', params.field);

		var bounce = Math.abs(sin((params.fBeat + offset) * (1 + speed) * PI)) * ARROW_SIZE;

        curPos.x += bounce * getPercent('bounceX', params.field);
        curPos.y += bounce * (getPercent('bounce', params.field) + getPercent('bounceY', params.field));
        curPos.z += bounce * getPercent('bounceZ', params.field);

        return curPos;
    }
	override public function shouldRun(params:RenderParams):Bool
		return true;
}